/**
 * Test Puppeteer-based UMS login
 * Run: node test-ums.js
 */
const { loginToUMS } = require('./src/services/ums.service');

async function test() {
  console.log('=== Testing Puppeteer UMS Login ===\n');

  try {
    const result = await loginToUMS('30410030100903', 'Noureen@1610');
    
    console.log('\n--- PROFILE ---');
    console.log(JSON.stringify(result.profile, null, 2));
    
    console.log('\n--- COURSES ---');
    console.log(`Count: ${result.courses.length}`);
    result.courses.forEach(c => console.log(`  ${c.courseCode}: ${c.courseName}`));
    
    console.log('\n--- GRADES ---');
    console.log(`Count: ${result.grades.length}`);
    result.grades.forEach(g => console.log(`  ${g.courseCode}: ${g.grade}`));
    
    console.log('\n--- COOKIES ---');
    console.log(`Count: ${result.cookies.length}`);

  } catch (err) {
    console.error('❌ Error:', err.message);
  }

  console.log('\n=== DONE ===');
}

test();
