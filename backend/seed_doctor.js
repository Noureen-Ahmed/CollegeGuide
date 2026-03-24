const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
require('dotenv').config();

async function seed() {
    const db = await mysql.createConnection({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        ssl: { rejectUnauthorized: false }
    });

    const doctorEmail = 'doctor@college.edu';

    // 1. Ensure doctor user exists
    const [existing] = await db.query('SELECT id FROM users WHERE email = ?', [doctorEmail]);
    if (existing.length === 0) {
        const hashedPass = await bcrypt.hash('doctor123', 10);
        await db.execute(`
            INSERT INTO users (id, name, email, password, mode, is_verified, is_onboarding_complete, faculty, department)
            VALUES ('dr_college_001', 'Dr. Mohamed Hashem', ?, ?, 'professor', true, true, 'Faculty of Science', 'Computer Science')
        `, [doctorEmail, hashedPass]);
        console.log('Created doctor user');
    } else {
        console.log('Doctor user exists, id:', existing[0].id);
    }

    // 2. Seed courses into the courses table
    const courses = [
        {
            id: 'comp402', code: 'COMP 402', name: 'Bioinformatics', category: 'comp', creditHours: 3,
            description: 'Introduction to Bioinformatics - sequence analysis, alignment algorithms, and biological databases.',
            professors: JSON.stringify(['Dr. Mohamed Hashem']),
            content: JSON.stringify([
                { id: 'c1', title: 'Introduction to Bioinformatics', type: 'lecture', description: 'Overview of bioinformatics field' },
                { id: 'c2', title: 'Sequence Alignment', type: 'lecture', description: 'BLAST and sequence alignment algorithms' },
                { id: 'c3', title: 'Biological Databases', type: 'lecture', description: 'Major biological databases and data formats' }
            ]),
            assignments: JSON.stringify([
                { id: 'a1', title: 'Sequence Analysis Report', dueDate: '2026-04-15', description: 'Analyze a given protein sequence using BLAST.', points: 100 }
            ]),
            exams: JSON.stringify([
                { id: 'e1', title: 'Midterm Exam', date: '2026-04-01', duration: 120, totalPoints: 50 },
                { id: 'e2', title: 'Final Exam', date: '2026-06-15', duration: 180, totalPoints: 100 }
            ])
        },
        {
            id: 'comp404', code: 'COMP 404', name: 'Software Engineering', category: 'comp', creditHours: 3,
            description: 'Software development lifecycle, design patterns, testing, and project management.',
            professors: JSON.stringify(['Dr. Mohamed Hashem']),
            content: JSON.stringify([
                { id: 'c1', title: 'Software Development Life Cycle', type: 'lecture', description: 'SDLC models and methodologies' },
                { id: 'c2', title: 'Design Patterns', type: 'lecture', description: 'Creational, structural, and behavioral patterns' },
                { id: 'c3', title: 'Software Testing', type: 'lecture', description: 'Unit testing, integration testing, and TDD' },
                { id: 'c4', title: 'Agile Methodology', type: 'lecture', description: 'Scrum, Kanban, and agile practices' }
            ]),
            assignments: JSON.stringify([
                { id: 'a1', title: 'UML Diagrams', dueDate: '2026-04-10', description: 'Create UML class and sequence diagrams for a library system.', points: 50 },
                { id: 'a2', title: 'Software Project', dueDate: '2026-05-20', description: 'Build a complete software project using agile methodology.', points: 100 }
            ]),
            exams: JSON.stringify([
                { id: 'e1', title: 'Midterm Exam', date: '2026-04-05', duration: 120, totalPoints: 50 },
                { id: 'e2', title: 'Final Exam', date: '2026-06-10', duration: 180, totalPoints: 100 }
            ])
        },
        {
            id: 'comp406', code: 'COMP 406', name: 'Computer Project (B)', category: 'comp', creditHours: 3,
            description: 'Individual graduation project in computer science.',
            professors: JSON.stringify(['Dr. Mohamed Hashem']),
            content: JSON.stringify([
                { id: 'c1', title: 'Project Proposal Guidelines', type: 'document', description: 'How to write your project proposal' },
                { id: 'c2', title: 'Literature Review Template', type: 'document', description: 'Template for the literature review chapter' }
            ]),
            assignments: JSON.stringify([
                { id: 'a1', title: 'Progress Report 1', dueDate: '2026-04-01', description: 'Submit your first progress report.', points: 30 },
                { id: 'a2', title: 'Final Project Submission', dueDate: '2026-06-01', description: 'Submit the final project report and code.', points: 100 }
            ]),
            exams: JSON.stringify([
                { id: 'e1', title: 'Project Defense', date: '2026-06-20', duration: 30, totalPoints: 100 }
            ])
        },
        {
            id: 'comp408', code: 'COMP 408', name: 'Advanced AI Topics', category: 'comp', creditHours: 3,
            description: 'Deep learning, NLP, computer vision, and reinforcement learning.',
            professors: JSON.stringify(['Dr. Mohamed Hashem']),
            content: JSON.stringify([
                { id: 'c1', title: 'Neural Networks Review', type: 'lecture', description: 'Deep neural network architectures' },
                { id: 'c2', title: 'Convolutional Neural Networks', type: 'lecture', description: 'CNN architectures for image recognition' },
                { id: 'c3', title: 'Natural Language Processing', type: 'lecture', description: 'Transformers and language models' },
                { id: 'c4', title: 'Reinforcement Learning', type: 'lecture', description: 'Q-learning and policy gradient methods' }
            ]),
            assignments: JSON.stringify([
                { id: 'a1', title: 'CNN Image Classifier', dueDate: '2026-04-20', description: 'Build an image classifier using CNN.', points: 80 },
                { id: 'a2', title: 'NLP Sentiment Analysis', dueDate: '2026-05-15', description: 'Implement a sentiment analysis model.', points: 80 }
            ]),
            exams: JSON.stringify([
                { id: 'e1', title: 'Midterm Exam', date: '2026-04-08', duration: 120, totalPoints: 50 },
                { id: 'e2', title: 'Final Exam', date: '2026-06-12', duration: 180, totalPoints: 100 }
            ])
        },
        {
            id: 'comp416', code: 'COMP 416', name: 'Data & Web Mining', category: 'comp', creditHours: 3,
            description: 'Data mining techniques, web scraping, clustering, and classification.',
            professors: JSON.stringify(['Dr. Mohamed Hashem']),
            content: JSON.stringify([
                { id: 'c1', title: 'Introduction to Data Mining', type: 'lecture', description: 'Data preprocessing and exploration' },
                { id: 'c2', title: 'Classification Algorithms', type: 'lecture', description: 'Decision trees, SVM, and random forests' },
                { id: 'c3', title: 'Clustering Techniques', type: 'lecture', description: 'K-means, hierarchical, and DBSCAN' },
                { id: 'c4', title: 'Web Mining and Scraping', type: 'lecture', description: 'Web structure analysis and content extraction' }
            ]),
            assignments: JSON.stringify([
                { id: 'a1', title: 'K-Means Clustering', dueDate: '2026-04-12', description: 'Implement K-means clustering on a dataset.', points: 70 },
                { id: 'a2', title: 'Web Scraping Project', dueDate: '2026-05-10', description: 'Build a web scraper and analyze the data.', points: 80 }
            ]),
            exams: JSON.stringify([
                { id: 'e1', title: 'Midterm Exam', date: '2026-04-03', duration: 120, totalPoints: 50 },
                { id: 'e2', title: 'Final Exam', date: '2026-06-08', duration: 180, totalPoints: 100 }
            ])
        }
    ];

    for (const c of courses) {
        await db.execute(`
            INSERT INTO courses (id, code, name, category, credit_hours, professors, description, content, assignments, exams)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                name=VALUES(name), professors=VALUES(professors), description=VALUES(description),
                content=VALUES(content), assignments=VALUES(assignments), exams=VALUES(exams)
        `, [c.id, c.code, c.name, c.category, c.creditHours, c.professors, c.description, c.content, c.assignments, c.exams]);
        console.log('Seeded course:', c.code);
    }

    // 3. Link doctor to courses via doctor_courses table (uses doctor_email + course_id)
    for (const c of courses) {
        await db.execute(`
            INSERT INTO doctor_courses (doctor_email, course_id, is_primary)
            VALUES (?, ?, true)
            ON DUPLICATE KEY UPDATE is_primary=true
        `, [doctorEmail, c.id]);
        console.log('Linked:', doctorEmail, '->', c.code);
    }

    // 4. Verify
    const [result] = await db.query(`
        SELECT c.code, c.name FROM doctor_courses dc
        JOIN courses c ON dc.course_id = c.id
        WHERE dc.doctor_email = ?
    `, [doctorEmail]);
    console.log('Doctor courses:', result.map(r => r.code).join(', '));

    await db.end();
    console.log('Done!');
}
seed().catch(e => console.error('SEED ERROR:', e));
