import json
from bs4 import BeautifulSoup

def parse_account_page(html):
    profile = {}
    soup = BeautifulSoup(html, 'html.parser')

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

    return profile

if __name__ == "__main__":
    with open("profile_debug.html", "r", encoding="utf-8") as f:
        html = f.read()
    print(json.dumps(parse_account_page(html), ensure_ascii=False, indent=2))
