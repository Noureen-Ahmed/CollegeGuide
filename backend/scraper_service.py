from flask import Flask, request, jsonify
from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeout
from bs4 import BeautifulSoup
import re
import logging
import traceback

app = Flask(__name__)
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

UMS_BASE = 'https://ums.asu.edu.eg'
LOGIN_URL = f'{UMS_BASE}/App/Login_Form'
ACCOUNT_URL = f"{UMS_BASE}/UserInformation"
COURSES_URL = f'{UMS_BASE}/UserInformation/CurrentCourse'
REGISTRATION_URL = f'{UMS_BASE}/RegisterElectiveCourse/Registration'


def perform_scrape(username, password):
    """Launch headless Chromium, log in to UMS, and scrape all 3 target pages."""
    login_id = username.split('@')[0] if '@' in username else username

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        # ── Step 1: Navigate to login page ──
        logging.info(f"Opening login page for {login_id}...")
        page.goto(LOGIN_URL, timeout=30000)
        page.wait_for_load_state('networkidle', timeout=20000)

        # ── Step 2: Set DomainName to @sci.asu.edu.eg via JS (bypasses Kendo UI) ──
        # The Kendo dropdown populates a hidden input. We set it directly.
        domain = '@' + username.split('@')[1] if '@' in username else '@sci.asu.edu.eg'
        page.evaluate(f"""
            // Set hidden DomainName input
            var inputs = document.querySelectorAll('input[name="DomainName"]');
            inputs.forEach(function(el) {{ el.value = '{domain}'; }});
            // Also update Kendo widget text if present
            var kdrop = document.querySelector('[data-role="dropdownlist"]');
            if (kdrop) {{
                var kendoWidget = window.jQuery && window.jQuery(kdrop).data('kendoDropDownList');
                if (kendoWidget) {{
                    var items = kendoWidget.dataSource.data();
                    for (var i=0; i<items.length; i++) {{
                        if (items[i].Value === '{domain}') {{
                            kendoWidget.value(items[i].Value);
                            kendoWidget.trigger('change');
                            break;
                        }}
                    }}
                }}
            }}
        """)
        logging.info(f"Set DomainName to {domain} via JS injection")

        # ── Step 3: Fill login name and password ──
        page.fill('input[name="LoginName"]', login_id)
        page.fill('input[name="password"]', password)

        # ── Step 4: Submit ──
        page.click('button[type="submit"]')
        logging.info("Submitted login form. Waiting for navigation...")

        try:
            page.wait_for_url(lambda url: '/App/Login_Form' not in url, timeout=20000)
        except PlaywrightTimeout:
            # Check if there's an error message on the page
            err_el = page.query_selector('.text-danger, .validation-summary-errors, .alert-danger')
            err_msg = err_el.inner_text() if err_el else "Login timed out"
            logging.error(f"Login failed: {err_msg}")
            browser.close()
            return None, err_msg

        logging.info(f"Login succeeded! Now at: {page.url}")

        dashboard_html = page.content()
        with open("dashboard_debug.html", "w", encoding="utf-8") as f:
            f.write(dashboard_html)
            
        result = {"profile": {}, "courses": [], "grades": []}

        # ── Step 5: Scrape /UserInformation ──
        logging.info(f"Scraping {ACCOUNT_URL}...")
        page.goto(ACCOUNT_URL, timeout=20000)
        try:
            page.wait_for_load_state('networkidle', timeout=10000)
        except PlaywrightTimeout:
            pass
        result['profile'] = parse_account_page(page.content())

        # ── Step 6: Scrape /UserInformation/CurrentCourse ──
        logging.info(f"Scraping {COURSES_URL}...")
        page.goto(COURSES_URL, timeout=20000)
        try:
            page.wait_for_load_state('networkidle', timeout=10000)
        except PlaywrightTimeout:
            pass
        result['courses'] = parse_courses_page(page.content())

        # ── Step 7: Scrape /RegisterElectiveCourse/Registration ──
        logging.info(f"Scraping {REGISTRATION_URL}...")
        page.goto(REGISTRATION_URL, timeout=20000)
        try:
            page.wait_for_load_state('networkidle', timeout=10000)
        except PlaywrightTimeout:
            pass
        reg_info = parse_registration_page(page.content())
        result['profile'].update(reg_info)

        browser.close()
        logging.info(f"✅ Scrape complete: {len(result['courses'])} courses, profile keys: {list(result['profile'].keys())}")
        return result, None


def parse_account_page(html):
    """Parse /UserInformation — extract full profile fields."""
    profile = {}
    soup = BeautifulSoup(html, 'html.parser')

    # Look for grid rows mapping h5 (label) to p or span (value)
    for row in soup.find_all('div', class_='row'):
        h5 = row.find('h5')
        val_el = row.find('p') or row.find('span')
        if h5 and val_el:
            k = h5.get_text(strip=True)
            v = val_el.get_text(strip=True)
            
            if any(x in k for x in ['القومي', 'جواز']):
                profile['studentId'] = v
            elif any(x in k for x in ['اسم المستخدم', 'الطالب', 'Name']):
                if 'nameAr' not in profile: profile['nameAr'] = v
            elif any(x in k for x in ['الإلكتروني', 'email', 'Email']):
                if 'email' not in profile: profile['email'] = v
            elif any(x in k for x in ['الهاتف', 'phone', 'Phone', 'تليفون']):
                profile['phone'] = v
            elif any(x in k for x in ['الكلية', 'Faculty', 'كلية']):
                profile['faculty'] = v
            elif any(x in k for x in ['البرنامج', 'Program']):
                profile['program'] = v
            elif any(x in k for x in ['الأكاديمية', 'academicYear', 'السنة']):
                profile['academicYear'] = v
            elif any(x in k for x in ['المستوى', 'Level']):
                profile['level'] = v
            elif any(x in k for x in ['الفصل الدراسي', 'semester']):
                profile['semester'] = v

    # Fallback to extract Department from unstructured list items
    if 'department' not in profile:
        for li in soup.find_all('li'):
            text = li.get_text(strip=True)
            if 'قسم' in text and len(text) < 50:
                profile['department'] = text
                break

    logging.info(f"Profile parsed: {profile}")
    return profile


def parse_courses_page(html):
    """Parse /UserInformation/CurrentCourse — extract enrolled courses from card divs."""
    courses = []
    soup = BeautifulSoup(html, 'html.parser')

    # The page uses div.price-table-box2 cards for each course
    cards = soup.find_all('div', class_='price-table-box2')
    logging.info(f"Courses page: {len(cards)} course cards found")

    for card in cards:
        course = {}

        # Course name and code come from h5 element
        # e.g. "هندسه البرمجيات [COMP 404]"
        title_el = card.find('h5')
        if title_el:
            full_title = title_el.get_text(strip=True)
            # Extract code from brackets
            code_match = re.search(r'\[([^\]]+)\]', full_title)
            if code_match:
                course['courseCode'] = code_match.group(1).strip()
                course['courseName'] = full_title[:full_title.rfind('[')].strip()
            else:
                course['courseName'] = full_title
                course['courseCode'] = ''

        # Grade fields are in row divs with span elements
        grades = {}
        for row in card.find_all('div', class_='row'):
            text = row.get_text(separator='|', strip=True)
            parts = text.split('|')
            for i in range(len(parts) - 1):
                label = parts[i].strip()
                val_str = parts[i + 1].strip()
                try:
                    val = float(val_str)
                    if 'تحريري' in label:
                        grades['written'] = val
                    elif 'عملي' in label:
                        grades['practical'] = val
                    elif 'شفوي' in label:
                        grades['oral'] = val
                    elif 'أعمال' in label or 'اعمال' in label:
                        grades['semesterWork'] = val
                except ValueError:
                    pass

        course['grades'] = grades
        course['creditHours'] = None
        course['section'] = None
        course['instructorName'] = None

        if course.get('courseCode') or course.get('courseName'):
            logging.info(f"  Course: {course['courseCode']} - {course.get('courseName', '')}, grades: {grades}")
            courses.append(course)

    logging.info(f"Total courses: {len(courses)}")
    return courses


def parse_registration_page(html):
    """Parse /RegisterElectiveCourse/Registration — extract advisor info."""
    info = {}
    soup = BeautifulSoup(html, 'html.parser')
    text = soup.get_text()

    adv_name = re.search(r'للمرشد الأكاديم[يى]\s*[:\-]*\s*([^\n\r<]{2,80})', text)
    if adv_name:
        info['advisorName'] = adv_name.group(1).strip()

    adv_email = re.search(r'mailto:([^"\'>\s]+)', html)
    if adv_email:
        info['advisorEmail'] = adv_email.group(1).strip()

    logging.info(f"Registration info: {info}")
    return info


# ============ API ENDPOINTS ============

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok", "message": "Python Playwright scraper v3 running!"})


@app.route('/scrape/all', methods=['POST'])
def scrape_all():
    data = request.json or {}
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({"success": False, "error": "Username and password required"}), 400

    logging.info(f"🔄 Starting full scrape for {username}")

    try:
        result, error = perform_scrape(username, password)

        if error:
            logging.error(f"❌ Scrape failed for {username}: {error}")
            return jsonify({"success": False, "error": error}), 401

        return jsonify({"success": True, "data": result})

    except Exception as e:
        logging.error(f"❌ Unexpected error for {username}: {traceback.format_exc()}")
        return jsonify({"success": False, "error": str(e)}), 500


if __name__ == '__main__':
    logging.info("🚀 Starting UMS Playwright Scraper Service v3 on port 5000")
    app.run(host='0.0.0.0', port=5000, debug=False)
