import requests
from bs4 import BeautifulSoup
import sys

# Updated trace to use multipart/form-data — matching the actual UMS form

UMS_BASE = 'https://ums.asu.edu.eg'

def test():
    session = requests.Session()
    session.headers.update({
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    })

    print('1. Getting login page...')
    res = session.get(f"{UMS_BASE}/App/Login_Form", timeout=15)
    print(f'   Status: {res.status_code}')

    soup = BeautifulSoup(res.text, 'html.parser')
    token_input = soup.find('input', {'name': '__RequestVerificationToken'})
    req_token = token_input.get('value', '') if token_input else ''
    print(f'   Token found: {bool(req_token)}')

    # Using multipart/form-data with files= parameter - this is what UMS requires
    form_fields = {
        '__RequestVerificationToken': (None, req_token),
        'DomainName': (None, '@sci.asu.edu.eg'),
        'LoginName': (None, '30410030100903'),
        'password': (None, 'N@276574458680uj'),
        'RememberMe': (None, 'false'),
    }

    print('2. Posting login (multipart/form-data)...')
    res2 = session.post(f"{UMS_BASE}/App/Login_Form", files=form_fields, allow_redirects=False, timeout=15)
    print(f'   Status: {res2.status_code}')
    print(f'   Location: {res2.headers.get("Location", "None")}')
    print(f'   Cookies: {list(session.cookies.keys())}')

    if res2.status_code in [301, 302]:
        loc = res2.headers.get('Location', '')
        if '/App/Login_Form' not in loc and 'Error' not in loc:
            print('   Login SUCCESS! Following redirect...')
            session.get(UMS_BASE + loc, timeout=15)
            print(f'   Cookies after redirect: {list(session.cookies.keys())}')

            print('3. Fetching /UserInformation/CurrentCourse...')
            r3 = session.get(f"{UMS_BASE}/UserInformation/CurrentCourse", timeout=15)
            print(f'   Status: {r3.status_code}')
            soup3 = BeautifulSoup(r3.text, 'html.parser')
            tables = soup3.find_all('table')
            print(f'   Tables found: {len(tables)}')
            for i, t in enumerate(tables):
                rows = t.find_all('tr')
                print(f'   Table {i}: {len(rows)} rows')
                for row in rows[:3]:
                    cells = [td.get_text(strip=True) for td in row.find_all(['th', 'td'])]
                    print(f'     {cells}')
        else:
            print(f'   Login FAILED, redirected to: {loc}')
    elif res2.status_code == 200:
        err = BeautifulSoup(res2.text, 'html.parser').find(class_=['text-danger', 'validation-summary-errors'])
        if err:
            print(f'   Login error: {err.get_text(strip=True)}')
        else:
            print('   Login might be OK, no error found')

if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    test()
