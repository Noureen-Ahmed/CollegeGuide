const mysql = require('mysql2/promise');
const axios = require('axios');
const jwt = require('jsonwebtoken');
require('dotenv').config();

async function run() {
    try {
        const pool = mysql.createPool({
            host: process.env.DB_HOST,
            port: process.env.DB_PORT,
            user: process.env.DB_USER,
            password: process.env.DB_PASSWORD,
            database: process.env.DB_NAME,
            ssl: { rejectUnauthorized: false }
        });
        const conn = await pool.getConnection();
        
        const [users] = await conn.query('SELECT * FROM users WHERE email LIKE "%30410030100903%"');
        if (users.length === 0) {
            console.log('User not found in DB!');
            process.exit(1);
        }
        
        const user = users[0];
        console.log('Found user:', user.email);

        // Generate token manually
        const token = jwt.sign(
            { id: user.id, email: user.email, mode: user.mode },
            process.env.JWT_SECRET || 'college-guide-super-secret-key-change-in-production',
            { expiresIn: '7d' }
        );

        console.log('Triggering UMS sync directly...');
        // Need to hit Python scraper directly, or node backend. Let's hit node backend.
        // Wait, node backend requires the password to pass to Python scraper!
        // The node backend /api/ums/sync uses the user's password to login to UMS.
        // But the password is NOT in the DB in plain text (unless it's the bug where it was).
        // Let's check server.js how it handles the password in /api/ums/sync.
    } catch (e) {
        console.log(e);
    }
}
run();
