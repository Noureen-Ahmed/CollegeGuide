const axios = require('axios');

async function debugSync() {
    try {
        const res = await axios.post('http://localhost:5000/scrape/all', {
            username: '30410030100903@sci.asu.edu.eg',
            password: 'Top1@Hacking'
        }, { timeout: 90000 });
        
        console.log('SUCCESS:', JSON.stringify(res.data, null, 2));
    } catch (e) {
        if (e.response) {
            console.error('PYTHON ERROR (full):', JSON.stringify(e.response.data, null, 2));
            console.error('Status:', e.response.status);
        } else {
            console.error('Network error:', e.message);
        }
    }
}
debugSync();
