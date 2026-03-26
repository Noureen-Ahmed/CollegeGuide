const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const session = await prisma.umsSession.findFirst({
    orderBy: { lastSyncAt: 'desc' }
  });
  console.log('Session cookies exist?', !!session?.cookies, 'Count:', session?.cookies?.length);

  if (session && session.cookies) {
    const puppeteer = require('puppeteer-core');
    const browser = await puppeteer.launch({
      executablePath: 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
      headless: true
    });
    const page = await browser.newPage();
    
    // Determine the UMS_BASE URL format
    const UMS_BASE = 'https://ums.asu.edu.eg';
    
    // Cookies are stored as string or array?
    let cookies = session.cookies;
    if (typeof cookies === 'string') {
        try { cookies = JSON.parse(cookies); } catch(e) {}
    }
    
    // Set cookies
    for (const c of cookies) {
      if (!c.domain) c.domain = 'ums.asu.edu.eg';
      // Puppeteer requires exact matches, skip failing ones
      try { await page.setCookie(c); } catch(e) { }
    }
    
    console.log('Navigating to UserInformation...');
    await page.goto(`${UMS_BASE}/UserInformation`, { waitUntil: 'networkidle2', timeout: 30000 });
    const profileHtml = await page.content();
    require('fs').writeFileSync('profile_debug.html', profileHtml);
    console.log('Saved profile_debug.html');

    console.log('Navigating to advisor page...');
    await page.goto(`${UMS_BASE}/RegisterElectiveCourse/Registration`, { waitUntil: 'networkidle2', timeout: 30000 });
    const advisorHtml = await page.content();
    require('fs').writeFileSync('advisor_page_real.html', advisorHtml);
    console.log('Saved advisor_page_real.html');

    await browser.close();
  }
}

main().finally(() => prisma.$disconnect());
