const axios = require('axios');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2/promise');
require('dotenv').config();

async function run() {
    try {
        // 1) Login via Node backend
        console.log('Step 1: Logging in via /api/ums/login...');
        const loginRes = await axios.post('http://localhost:3000/api/ums/login', {
            loginName: '30410030100903',
            password: 'Top1@Hacking'
        }, { timeout: 30000 });
        
        const { token, user } = loginRes.data;
        console.log('✅ Login OK! User ID:', user.id, 'Name:', user.name);

        // 2) Trigger UMS Sync
        console.log('\nStep 2: Triggering /api/ums/sync...');
        const syncRes = await axios.post('http://localhost:3000/api/ums/sync', {
            umsUsername: '30410030100903@sci.asu.edu.eg',
            umsPassword: 'Top1@Hacking'
        }, {
            headers: { Authorization: `Bearer ${token}` },
            timeout: 120000
        });
        
        console.log('✅ Sync result:', syncRes.data);

        // 3) Check DB
        console.log('\nStep 3: Checking database...');
        const pool = mysql.createPool({
            host: process.env.DB_HOST,
            port: process.env.DB_PORT,
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME,
            ssl: { rejectUnauthorized: false }
        });
        const conn = await pool.getConnection();

        const [courses] = await conn.query('SELECT course_code, course_name, raw_data FROM ums_courses WHERE user_id = ?', [user.id]);
        console.log(`✅ Courses in DB: ${courses.length}`);
        courses.forEach(c => console.log(`   - ${c.course_code}: ${c.course_name}`));

        const [profiles] = await conn.query('SELECT * FROM ums_profile WHERE user_id = ?', [user.id]);
        console.log(`✅ Profile in DB: ${profiles.length > 0 ? 'YES' : 'NONE'}`);
        if (profiles.length > 0) console.log('  ', profiles[0]);

        conn.release();
        process.exit(0);
    } catch (e) {
        console.error('❌ ERROR:', e.response ? JSON.stringify(e.response.data) : e.message);
        process.exit(1);
    }
}
run();
