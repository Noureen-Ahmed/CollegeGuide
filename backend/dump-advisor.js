/**
 * Dump Academic Advisor Page HTML
 */
const puppeteer = require('puppeteer-core');
const fs = require('fs');

const UMS_BASE = 'https://ums.asu.edu.eg';
const CHROME_PATH = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

async function test() {
  const loginName = '30410030100903';
  const password = 'Noureen@1610';

  console.log('[UMS] Launching headless Chrome...');
  const browser = await puppeteer.launch({
    executablePath: CHROME_PATH,
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']
  });

  try {
    const page = await browser.newPage();
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');

    await page.goto(`${UMS_BASE}/App/Login_Form`, { waitUntil: 'networkidle2', timeout: 30000 });
    console.log('[UMS] Login page loaded');

    await new Promise(r => setTimeout(r, 2000));

    await page.evaluate((domainValue) => {
      const ddl = $('#DomainName').data('kendoDropDownList');
      if (ddl) { ddl.value(domainValue); ddl.trigger('change'); }
      document.querySelectorAll('input[name="DomainName"]').forEach(el => el.value = domainValue);
    }, '@sci.asu.edu.eg');
    
    const loginField = await page.$('#user-name') || await page.$('input[name="LoginName"]');
    if (loginField) {
      await loginField.click({ clickCount: 3 });
      await loginField.type(loginName, { delay: 30 });
    }

    const passwordField = await page.$('#pass') || await page.$('input[name="password"]');
    if (passwordField) {
      await passwordField.type(password, { delay: 30 });
    }

    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 30000 }).catch(() => {}),
      page.click('button[type="submit"], input[type="submit"], .btn-primary, #btnLogin').catch(async () => {
        await page.keyboard.press('Enter');
      })
    ]);

    console.log('[UMS] Login submitted. Waiting for page to load...');
    await new Promise(r => setTimeout(r, 3000));

    console.log('[UMS] Navigating to Registration page...');
    await page.goto(`${UMS_BASE}/RegisterElectiveCourse/Registration`, { waitUntil: 'networkidle2', timeout: 30000 });

    const html = await page.content();
    fs.writeFileSync('advisor_page.html', html);
    console.log('[UMS] Saved HTML to advisor_page.html');

  } catch (err) {
    console.error('Error:', err.message);
  } finally {
    await browser.close();
  }
}

test();
