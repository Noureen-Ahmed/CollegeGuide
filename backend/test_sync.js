const axios = require('axios');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();

async function runTest() {
    try {
        console.log('Logging in to backend...');
        const loginRes = await axios.post('http://localhost:3000/api/ums/login', {
            loginName: '30410030100903@sci.asu.edu.eg',
            password: 'N@276574458680uj'
        });
        
        const token = loginRes.data.token;
        console.log('Got JWT. Triggering /api/ums/sync...');

        const syncRes = await axios.post('http://localhost:3000/api/ums/sync', {}, {
            headers: { Authorization: `Bearer ${token}` }
        });

        console.log('Sync Response:', syncRes.data);

    } catch (e) {
        console.log('❌ ERROR:', e.response ? e.response.data : e.message);
    }
}
runTest();
