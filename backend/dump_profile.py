from playwright.sync_api import sync_playwright
import time

def dump():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context()
        page = context.new_page()

        print("Navigating to login...")
        page.goto("https://ums.asu.edu.eg/login")
        
        page.fill("input[name='loginName']", "30410030100903")
        page.fill("input[name='password']", "Top1@Hacking")
        
        print("Injecting DomainName...")
        page.evaluate("document.getElementById('DomainName').value = 'كلية العلوم';")
        
        print("Clicking login...")
        page.click("button[type='submit']")
        
        page.wait_for_load_state('networkidle', timeout=15000)
        
        print("Navigating to MyAccount...")
        page.goto("https://ums.asu.edu.eg/UserInformation/MyAccount")
        page.wait_for_load_state('networkidle', timeout=15000)
        
        html = page.content()
        with open("profile_dump.html", "w", encoding="utf-8") as f:
            f.write(html)
            
        print("Done compiling profile_dump.html!")
        browser.close()

if __name__ == "__main__":
    dump()
