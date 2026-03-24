const mysql = require('mysql2/promise');
require('dotenv').config();

async function testConnection() {
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
        console.log('✅ CONNECTED to Railway MySQL!');
        conn.release();
        process.exit(0);
    } catch (e) {
        console.log('❌ ERROR:', e.message);
        process.exit(1);
    }
}
testConnection();
