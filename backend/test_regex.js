const fs = require('fs');
const html = fs.readFileSync('advisor_page_real.html', 'utf8');
const nameMatch = html.match(/للمرشد الأكاديمى\s*:\s*([^<]+)/);
const emailMatch = html.match(/mailto:([^"]+)/);
console.log('Name:', nameMatch ? nameMatch[1].trim() : null);
console.log('Email:', emailMatch ? emailMatch[1].trim() : null);
