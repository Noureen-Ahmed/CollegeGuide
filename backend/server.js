const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const nodemailer = require('nodemailer');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// MySQL Connection Pool - Aiven Cloud Database
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: {
        rejectUnauthorized: false
    },
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Initialize database tables
async function initDatabase() {
    try {
        const connection = await pool.getConnection();
        console.log('🔌 Connected to database');

        // Create users table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(50) PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(100) NOT NULL,
        avatar VARCHAR(255),
        student_id VARCHAR(50),
        major VARCHAR(100),
        department VARCHAR(100),
        program VARCHAR(100),
        gpa DECIMAL(3,2),
        level INT,
        mode VARCHAR(20) DEFAULT 'student',
        is_verified BOOLEAN DEFAULT FALSE,
        is_onboarding_complete BOOLEAN DEFAULT FALSE,
        enrolled_courses TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      )
    `);

        // Create doctor_courses linking table (professors to their courses)
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS doctor_courses (
        id INT AUTO_INCREMENT PRIMARY KEY,
        doctor_email VARCHAR(100) NOT NULL,
        course_id VARCHAR(50) NOT NULL,
        is_primary BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_doctor_course (doctor_email, course_id),
        INDEX idx_doctor (doctor_email),
        INDEX idx_course (course_id)
      )
    `);

        // Create courses table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS courses (
        id VARCHAR(50) PRIMARY KEY,
        code VARCHAR(20) NOT NULL,
        name VARCHAR(100) NOT NULL,
        category VARCHAR(50),
        credit_hours INT,
        professors JSON,
        description TEXT,
        schedule JSON,
        content JSON,
        assignments JSON,
        exams JSON
      )
    `);

        // Create tasks table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS tasks (
        id VARCHAR(50) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        course_id VARCHAR(50),
        course_name VARCHAR(100),
        priority VARCHAR(20) DEFAULT 'low',
        completed BOOLEAN DEFAULT FALSE,
        description TEXT,
        user_id VARCHAR(50),
        due_date DATETIME,
        points INT DEFAULT 100,
        notification_id INT,
        created_by VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_user (user_id),
        INDEX idx_course (course_id)
      )
    `);

        // Create announcements table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS announcements (
        id VARCHAR(50) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        message TEXT,
        date DATETIME DEFAULT CURRENT_TIMESTAMP,
        type VARCHAR(30) DEFAULT 'general',
        is_read BOOLEAN DEFAULT FALSE,
        course_id VARCHAR(50),
        created_by VARCHAR(100),
        target_audience VARCHAR(20) DEFAULT 'all',
        INDEX idx_course (course_id),
        INDEX idx_date (date)
      )
    `);

        // Create notifications table for student notifications
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS notifications (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_email VARCHAR(100) NOT NULL,
        title VARCHAR(255) NOT NULL,
        message TEXT,
        type VARCHAR(30) DEFAULT 'general',
        reference_type VARCHAR(30),
        reference_id VARCHAR(50),
        is_read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_user (user_email),
        INDEX idx_read (is_read),
        INDEX idx_created (created_at)
      )
    `);

        // Create course_content table for lectures, materials, etc.
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS course_content (
        id VARCHAR(50) PRIMARY KEY,
        course_id VARCHAR(50) NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        content_type VARCHAR(30) NOT NULL,
        file_url VARCHAR(500),
        week_number INT,
        order_index INT DEFAULT 0,
        created_by VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_course (course_id),
        INDEX idx_type (content_type)
      )
    `);

        // Create verification codes table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS verification_codes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(100) NOT NULL,
        code VARCHAR(10) NOT NULL,
        type VARCHAR(20) NOT NULL,
        expires_at DATETIME NOT NULL,
        used BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_email (email),
        INDEX idx_code (code)
      )
    `);

        // Create schedule_events table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS schedule_events (
        id VARCHAR(50) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        start_time DATETIME NOT NULL,
        end_time DATETIME NOT NULL,
        location VARCHAR(100),
        instructor VARCHAR(100),
        course_id VARCHAR(50),
        description TEXT,
        type VARCHAR(20) DEFAULT 'lecture',
        user_email VARCHAR(100),
        INDEX idx_course (course_id),
        INDEX idx_user (user_email)
      )
    `);

        // Create academic_advising table (links students to advisors)
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS academic_advising (
        id INT AUTO_INCREMENT PRIMARY KEY,
        advisor_email VARCHAR(100) NOT NULL,
        student_email VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_advising (advisor_email, student_email),
        INDEX idx_advisor (advisor_email),
        INDEX idx_student (student_email)
      )
    `);

        // Create advising_messages table
        await connection.execute(`
      CREATE TABLE IF NOT EXISTS advising_messages (
        id INT AUTO_INCREMENT PRIMARY KEY,
        sender_email VARCHAR(100) NOT NULL,
        receiver_email VARCHAR(100), -- Null for broadcast
        message TEXT NOT NULL,
        is_broadcast BOOLEAN DEFAULT FALSE,
        is_read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_sender (sender_email),
        INDEX idx_receiver (receiver_email),
        INDEX idx_broadcast (is_broadcast)
      )
    `);

        connection.release();
        console.log('✅ Database tables initialized');
    } catch (error) {
        console.error('❌ Database initialization error:', error);
    }
}

// Email transporter (configure with actual SMTP settings)
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER || 'noreply@example.com',
        pass: process.env.EMAIL_PASS || 'password'
    }
});

// ============ HELPER FUNCTIONS ============

function formatUser(row) {
    const coursesStr = row.enrolled_courses || '';
    const courses = coursesStr ? coursesStr.split(',').filter(s => s) : [];

    return {
        id: row.id,
        name: row.name,
        email: row.email,
        avatar: row.avatar,
        studentId: row.student_id,
        major: row.major,
        department: row.department,
        gpa: row.gpa ? parseFloat(row.gpa) : null,
        level: row.level,
        mode: row.mode || 'student',
        isOnboardingComplete: !!row.is_onboarding_complete,
        isVerified: !!row.is_verified,
        enrolledCourses: courses
    };
}

function generateId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

// Safe JSON parsing helper
function parseJson(field) {
    if (!field) return [];
    if (typeof field === 'object') return field;
    try {
        return JSON.parse(field);
    } catch (e) {
        return [];
    }
}

// Send notification to students enrolled in a course
async function notifyStudentsInCourse(courseId, notification) {
    try {
        // Get all students enrolled in this course
        const [users] = await pool.execute(`
            SELECT email, enrolled_courses FROM users 
            WHERE mode = 'student' AND enrolled_courses LIKE ?
        `, [`%${courseId}%`]);

        for (const user of users) {
            // Insert notification for each student
            await pool.execute(`
                INSERT INTO notifications (user_email, title, message, type, reference_type, reference_id)
                VALUES (?, ?, ?, ?, ?, ?)
            `, [
                user.email,
                notification.title,
                notification.message,
                notification.type || 'general',
                notification.referenceType || 'announcement',
                notification.referenceId || null
            ]);
        }

        console.log(`📢 Notified ${users.length} students about: ${notification.title}`);
        return users.length;
    } catch (error) {
        console.error('Error sending notifications:', error);
        return 0;
    }
}

// ============ AUTH ENDPOINTS ============

app.post('/api/auth/register', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Check if user exists
        const [existing] = await pool.execute('SELECT id FROM users WHERE email = ?', [email]);
        if (existing.length > 0) {
            return res.status(409).json({ error: 'User already exists' });
        }

        const id = generateId();
        const mode = email.includes('doctor') || email.includes('professor') || email.includes('dr.') ? 'professor' : 'student';
        const studentId = mode === 'student' ? `STU${Date.now().toString().slice(-8)}` : null;

        await pool.execute(`
            INSERT INTO users (id, name, email, password, student_id, mode, is_onboarding_complete)
            VALUES (?, ?, ?, ?, ?, ?, FALSE)
        `, [id, name, email, password, studentId, mode]);

        // Generate verification code
        const code = Math.floor(1000 + Math.random() * 9000).toString();
        const expiresAt = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes

        await pool.execute(`
            INSERT INTO verification_codes (email, code, type, expires_at)
            VALUES (?, ?, 'registration', ?)
        `, [email, code, expiresAt]);

        // Try to send email
        try {
            await transporter.sendMail({
                from: process.env.EMAIL_USER,
                to: email,
                subject: 'Verify Your Account',
                text: `Your verification code is: ${code}`,
                html: `<p>Your verification code is: <strong>${code}</strong></p>`
            });
            console.log(`📧 Verification email sent to ${email} with code ${code}`);
        } catch (emailError) {
            console.log(`📧 Email not configured. Code for ${email}: ${code}`);
        }

        const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [email]);
        const user = formatUser(rows[0]);

        console.log(`✅ User registered: ${email} (${mode})`);
        res.json({ success: true, user });
    } catch (error) {
        console.error('Register error:', error);
        res.status(500).json({ error: 'Registration failed' });
    }
});

app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const [rows] = await pool.execute(
            'SELECT * FROM users WHERE email = ? AND password = ?',
            [email, password]
        );

        if (rows.length === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const user = formatUser(rows[0]);
        console.log(`✅ User logged in: ${email}`);
        res.json({ success: true, user });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Login failed' });
    }
});

app.post('/api/auth/send-code', async (req, res) => {
    try {
        const { email, type } = req.body;
        const code = Math.floor(1000 + Math.random() * 9000).toString();
        const expiresAt = new Date(Date.now() + 15 * 60 * 1000);

        // Delete old codes
        await pool.execute('DELETE FROM verification_codes WHERE email = ? AND type = ?', [email, type]);

        await pool.execute(`
            INSERT INTO verification_codes (email, code, type, expires_at)
            VALUES (?, ?, ?, ?)
        `, [email, code, type, expiresAt]);

        try {
            await transporter.sendMail({
                from: process.env.EMAIL_USER,
                to: email,
                subject: 'Verification Code',
                text: `Your verification code is: ${code}`,
                html: `<p>Your verification code is: <strong>${code}</strong></p>`
            });
        } catch (emailError) {
            console.log(`📧 Email not configured. Code for ${email}: ${code}`);
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Send code error:', error);
        res.status(500).json({ error: 'Failed to send code' });
    }
});

app.post('/api/auth/verify-code', async (req, res) => {
    try {
        const { email, code, type } = req.body;
        const [rows] = await pool.execute(`
            SELECT * FROM verification_codes 
            WHERE email = ? AND code = ? AND type = ? AND used = FALSE AND expires_at > NOW()
            ORDER BY created_at DESC LIMIT 1
        `, [email, code, type]);

        if (rows.length === 0) {
            return res.status(400).json({ error: 'Invalid or expired code' });
        }

        // Mark code as used
        await pool.execute('UPDATE verification_codes SET used = TRUE WHERE id = ?', [rows[0].id]);

        // Update user as verified
        await pool.execute('UPDATE users SET is_verified = TRUE WHERE email = ?', [email]);

        res.json({ success: true });
    } catch (error) {
        console.error('Verify code error:', error);
        res.status(500).json({ error: 'Verification failed' });
    }
});

app.post('/api/auth/reset-password', async (req, res) => {
    try {
        const { email, newPassword } = req.body;
        await pool.execute('UPDATE users SET password = ? WHERE email = ?', [newPassword, email]);
        res.json({ success: true });
    } catch (error) {
        console.error('Reset password error:', error);
        res.status(500).json({ error: 'Password reset failed' });
    }
});

// ============ USER ENDPOINTS ============

app.get('/api/users/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [email]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json({ success: true, user: formatUser(rows[0]) });
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({ error: 'Failed to get user' });
    }
});

app.put('/api/users/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const { name, avatar, major, department, gpa, level, mode, isOnboardingComplete, enrolledCourses } = req.body;

        const coursesStr = Array.isArray(enrolledCourses) ? enrolledCourses.join(',') : '';

        await pool.execute(`
            UPDATE users SET
                name = ?,
                avatar = ?,
                major = ?,
                department = ?,
                gpa = ?,
                level = ?,
                mode = ?,
                is_onboarding_complete = ?,
                enrolled_courses = ?
            WHERE email = ?
        `, [name, avatar, major, department, gpa, level, mode, isOnboardingComplete ? 1 : 0, coursesStr, email]);

        const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [email]);
        const user = rows.length > 0 ? formatUser(rows[0]) : null;

        console.log(`✅ User updated: ${email}`);
        res.json({ success: true, user });
    } catch (error) {
        console.error('Update user error:', error);
        res.status(500).json({ error: 'Failed to update user' });
    }
});

// ============ DOCTOR COURSES ENDPOINTS ============

// Get courses for a specific doctor
app.get('/api/doctor-courses/:email', async (req, res) => {
    try {
        const { email } = req.params;

        // Get course IDs for this doctor
        const [doctorCourses] = await pool.execute(`
            SELECT course_id, is_primary FROM doctor_courses WHERE doctor_email = ?
        `, [email]);

        if (doctorCourses.length === 0) {
            return res.json({ success: true, courses: [] });
        }

        // Get full course details
        const courseIds = doctorCourses.map(dc => dc.course_id);
        const placeholders = courseIds.map(() => '?').join(',');
        const [courses] = await pool.execute(`
            SELECT * FROM courses WHERE id IN (${placeholders})
        `, courseIds);

        // Parse JSON fields
        const formattedCourses = courses.map(course => ({
            ...course,
            professors: parseJson(course.professors),
            schedule: parseJson(course.schedule),
            content: parseJson(course.content),
            assignments: parseJson(course.assignments),
            exams: parseJson(course.exams),
        }));

        res.json({ success: true, courses: formattedCourses });
    } catch (error) {
        console.error('Get doctor courses error:', error);
        res.status(500).json({ error: 'Failed to get doctor courses' });
    }
});

// Assign a course to a doctor
app.post('/api/doctor-courses', async (req, res) => {
    try {
        const { doctorEmail, courseId, isPrimary } = req.body;

        await pool.execute(`
            INSERT INTO doctor_courses (doctor_email, course_id, is_primary)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE is_primary = ?
        `, [doctorEmail, courseId, isPrimary || false, isPrimary || false]);

        res.json({ success: true });
    } catch (error) {
        console.error('Assign doctor course error:', error);
        res.status(500).json({ error: 'Failed to assign course' });
    }
});

// ============ CONTENT CREATION ENDPOINTS ============

// Create lecture/content for a course
app.post('/api/content', async (req, res) => {
    try {
        const { courseId, title, description, contentType, fileUrl, weekNumber, createdBy } = req.body;

        const id = generateId();

        await pool.execute(`
            INSERT INTO course_content (id, course_id, title, description, content_type, file_url, week_number, created_by)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `, [id, courseId, title, description, contentType, fileUrl, weekNumber, createdBy]);

        // Notify students
        await notifyStudentsInCourse(courseId, {
            title: `New ${contentType}: ${title}`,
            message: description,
            type: contentType,
            referenceType: 'content',
            referenceId: id
        });

        // Also create an announcement
        const announcementId = generateId();
        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by)
            VALUES (?, ?, ?, ?, ?, ?)
        `, [announcementId, `New ${contentType}: ${title}`, description, contentType, courseId, createdBy]);

        console.log(`✅ Content created: ${title} for course ${courseId}`);
        res.json({ success: true, contentId: id });
    } catch (error) {
        console.error('Create content error:', error);
        res.status(500).json({ error: 'Failed to create content' });
    }
});

// Create assignment for a course
app.post('/api/assignments', async (req, res) => {
    try {
        const { courseId, title, description, dueDate, points, createdBy } = req.body;

        const id = generateId();

        // Get course name
        const [courseRows] = await pool.execute('SELECT name FROM courses WHERE id = ?', [courseId]);
        const courseName = courseRows.length > 0 ? courseRows[0].name : 'Unknown Course';

        // Create task for the assignment
        await pool.execute(`
            INSERT INTO tasks (id, title, course_id, course_name, priority, description, due_date, points, created_by)
            VALUES (?, ?, ?, ?, 'medium', ?, ?, ?, ?)
        `, [id, title, courseId, courseName, description, dueDate, points, createdBy]);

        // Notify students
        await notifyStudentsInCourse(courseId, {
            title: `New Assignment: ${title}`,
            message: `Due: ${new Date(dueDate).toLocaleDateString()}. ${description}`,
            type: 'assignment',
            referenceType: 'task',
            referenceId: id
        });

        // Create announcement
        const announcementId = generateId();
        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by)
            VALUES (?, ?, ?, 'assignment', ?, ?)
        `, [announcementId, `New Assignment: ${title}`, `Due: ${new Date(dueDate).toLocaleDateString()}`, courseId, createdBy]);

        console.log(`✅ Assignment created: ${title} for course ${courseId}`);
        res.json({ success: true, assignmentId: id });
    } catch (error) {
        console.error('Create assignment error:', error);
        res.status(500).json({ error: 'Failed to create assignment' });
    }
});

// Create exam for a course
app.post('/api/exams', async (req, res) => {
    try {
        const { courseId, title, description, examDate, points, createdBy } = req.body;

        const id = generateId();

        // Get course name
        const [courseRows] = await pool.execute('SELECT name FROM courses WHERE id = ?', [courseId]);
        const courseName = courseRows.length > 0 ? courseRows[0].name : 'Unknown Course';

        // Create task for the exam
        await pool.execute(`
            INSERT INTO tasks (id, title, course_id, course_name, priority, description, due_date, points, created_by)
            VALUES (?, ?, ?, ?, 'high', ?, ?, ?, ?)
        `, [id, title, courseId, courseName, description, examDate, points, createdBy]);

        // Notify students
        await notifyStudentsInCourse(courseId, {
            title: `Exam Scheduled: ${title}`,
            message: `Date: ${new Date(examDate).toLocaleDateString()}. ${description}`,
            type: 'exam',
            referenceType: 'task',
            referenceId: id
        });

        // Create announcement
        const announcementId = generateId();
        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by)
            VALUES (?, ?, ?, 'exam', ?, ?)
        `, [announcementId, `Exam Scheduled: ${title}`, `Date: ${new Date(examDate).toLocaleDateString()}`, courseId, createdBy]);

        console.log(`✅ Exam created: ${title} for course ${courseId}`);
        res.json({ success: true, examId: id });
    } catch (error) {
        console.error('Create exam error:', error);
        res.status(500).json({ error: 'Failed to create exam' });
    }
});

// ============ NOTIFICATIONS ENDPOINTS ============

// Get notifications for a user
app.get('/api/notifications/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const [rows] = await pool.execute(`
            SELECT * FROM notifications 
            WHERE user_email = ? 
            ORDER BY created_at DESC 
            LIMIT 50
        `, [email]);

        res.json({ success: true, notifications: rows });
    } catch (error) {
        console.error('Get notifications error:', error);
        res.status(500).json({ error: 'Failed to get notifications' });
    }
});

// Mark notification as read
app.put('/api/notifications/:id/read', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.execute('UPDATE notifications SET is_read = TRUE WHERE id = ?', [id]);
        res.json({ success: true });
    } catch (error) {
        console.error('Mark notification read error:', error);
        res.status(500).json({ error: 'Failed to mark notification as read' });
    }
});

// Mark all notifications as read for a user
app.put('/api/notifications/read-all/:email', async (req, res) => {
    try {
        const { email } = req.params;
        await pool.execute('UPDATE notifications SET is_read = TRUE WHERE user_email = ?', [email]);
        res.json({ success: true });
    } catch (error) {
        console.error('Mark all notifications read error:', error);
        res.status(500).json({ error: 'Failed to mark notifications as read' });
    }
});

// ============ TASKS ENDPOINTS ============

app.get('/api/tasks', async (req, res) => {
    try {
        const userId = req.query.userId;
        let query = 'SELECT * FROM tasks ORDER BY due_date ASC';
        let params = [];

        if (userId) {
            query = 'SELECT * FROM tasks WHERE user_id = ? ORDER BY due_date ASC';
            params = [userId];
        }

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, tasks: rows });
    } catch (error) {
        console.error('Get tasks error:', error);
        res.status(500).json({ error: 'Failed to get tasks' });
    }
});

app.post('/api/tasks', async (req, res) => {
    try {
        const { id, title, course, priority, description, userId, dueDate } = req.body;
        const taskId = id || generateId();

        await pool.execute(`
            INSERT INTO tasks (id, title, course_name, priority, description, user_id, due_date)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [taskId, title, course, priority, description, userId, dueDate]);

        res.json({ success: true, taskId });
    } catch (error) {
        console.error('Create task error:', error);
        res.status(500).json({ error: 'Failed to create task' });
    }
});

app.put('/api/tasks/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { title, completed, priority, dueDate } = req.body;

        await pool.execute(`
            UPDATE tasks SET title = ?, completed = ?, priority = ?, due_date = ?
            WHERE id = ?
        `, [title, completed, priority, dueDate, id]);

        res.json({ success: true });
    } catch (error) {
        console.error('Update task error:', error);
        res.status(500).json({ error: 'Failed to update task' });
    }
});

app.delete('/api/tasks/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.execute('DELETE FROM tasks WHERE id = ?', [id]);
        res.json({ success: true });
    } catch (error) {
        console.error('Delete task error:', error);
        res.status(500).json({ error: 'Failed to delete task' });
    }
});

// ============ ANNOUNCEMENTS ENDPOINTS ============

app.get('/api/announcements', async (req, res) => {
    try {
        const { courseId, userEmail } = req.query;

        let query = 'SELECT * FROM announcements ORDER BY date DESC LIMIT 50';
        let params = [];

        if (courseId) {
            query = 'SELECT * FROM announcements WHERE course_id = ? ORDER BY date DESC';
            params = [courseId];
        } else if (userEmail) {
            // Get announcements for courses the user is enrolled in
            const [userRows] = await pool.execute('SELECT enrolled_courses FROM users WHERE email = ?', [userEmail]);
            if (userRows.length > 0 && userRows[0].enrolled_courses) {
                const courseIds = userRows[0].enrolled_courses.split(',').filter(c => c);
                if (courseIds.length > 0) {
                    const placeholders = courseIds.map(() => '?').join(',');
                    query = `SELECT * FROM announcements WHERE course_id IN (${placeholders}) OR course_id IS NULL ORDER BY date DESC`;
                    params = courseIds;
                }
            }
        }

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, announcements: rows });
    } catch (error) {
        console.error('Get announcements error:', error);
        res.status(500).json({ error: 'Failed to get announcements' });
    }
});

app.post('/api/announcements', async (req, res) => {
    try {
        const { title, message, type, courseId, createdBy } = req.body;
        const id = generateId();

        await pool.execute(`
            INSERT INTO announcements (id, title, message, type, course_id, created_by)
            VALUES (?, ?, ?, ?, ?, ?)
        `, [id, title, message, type || 'general', courseId, createdBy]);

        // Notify students
        if (courseId) {
            await notifyStudentsInCourse(courseId, {
                title,
                message,
                type: type || 'general',
                referenceType: 'announcement',
                referenceId: id
            });
        }

        res.json({ success: true, announcementId: id });
    } catch (error) {
        console.error('Create announcement error:', error);
        res.status(500).json({ error: 'Failed to create announcement' });
    }
});

// ============ COURSES ENDPOINTS ============

app.get('/api/courses', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM courses');

        const courses = rows.map(course => ({
            ...course,
            professors: parseJson(course.professors),
            schedule: parseJson(course.schedule),
            content: parseJson(course.content),
            assignments: parseJson(course.assignments),
            exams: parseJson(course.exams),
        }));

        res.json({ success: true, courses });
    } catch (error) {
        console.error('Get courses error:', error);
        res.status(500).json({ error: 'Failed to get courses' });
    }
});

app.get('/api/courses/:id', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM courses WHERE id = ?', [req.params.id]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Course not found' });
        }

        const course = rows[0];
        res.json({
            success: true,
            course: {
                ...course,
                professors: parseJson(course.professors),
                schedule: parseJson(course.schedule),
                content: parseJson(course.content),
                assignments: parseJson(course.assignments),
                exams: parseJson(course.exams),
            }
        });
    } catch (error) {
        console.error('Get course error:', error);
        res.status(500).json({ error: 'Failed to get course' });
    }
});

// Get content for a course
app.get('/api/courses/:id/content', async (req, res) => {
    try {
        const [rows] = await pool.execute(
            'SELECT * FROM course_content WHERE course_id = ? ORDER BY week_number, order_index',
            [req.params.id]
        );
        res.json({ success: true, content: rows });
    } catch (error) {
        console.error('Get course content error:', error);
        res.status(500).json({ error: 'Failed to get course content' });
    }
});

// ============ SCHEDULE ENDPOINTS ============

app.get('/api/schedule', async (req, res) => {
    try {
        const { userEmail } = req.query;
        let query = 'SELECT * FROM schedule_events ORDER BY start_time';
        let params = [];

        if (userEmail) {
            query = 'SELECT * FROM schedule_events WHERE user_email = ? ORDER BY start_time';
            params = [userEmail];
        }

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, events: rows });
    } catch (error) {
        console.error('Get schedule error:', error);
        res.status(500).json({ error: 'Failed to get schedule' });
    }
});

app.post('/api/schedule', async (req, res) => {
    try {
        const { title, startTime, endTime, location, instructor, courseId, description, type, userEmail } = req.body;
        const id = generateId();

        await pool.execute(`
            INSERT INTO schedule_events (id, title, start_time, end_time, location, instructor, course_id, description, type, user_email)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [id, title, startTime, endTime, location, instructor, courseId, description, type || 'lecture', userEmail]);

        res.json({ success: true, eventId: id });
    } catch (error) {
        console.error('Create schedule event error:', error);
        res.status(500).json({ error: 'Failed to create event' });
    }
});

// ============ ACADEMIC ADVISING ENDPOINTS ============

// Link students to an advisor
app.post('/api/advising/link', async (req, res) => {
    try {
        const { advisorEmail, studentEmails } = req.body;
        if (!advisorEmail || !Array.isArray(studentEmails)) {
            return res.status(400).json({ error: 'Invalid data' });
        }

        const values = studentEmails.map(email => [advisorEmail, email]);
        if (values.length > 0) {
            await pool.query(
                'INSERT IGNORE INTO academic_advising (advisor_email, student_email) VALUES ?',
                [values]
            );
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Link advising error:', error);
        res.status(500).json({ error: 'Failed to link students' });
    }
});

// Get students for an advisor
app.get('/api/advising/students/:advisorEmail', async (req, res) => {
    try {
        const { advisorEmail } = req.params;
        const [rows] = await pool.execute(`
            SELECT u.* FROM users u
            JOIN academic_advising aa ON u.email = aa.student_email
            WHERE aa.advisor_email = ?
        `, [advisorEmail]);

        const students = rows.map(formatUser);
        res.json({ success: true, students });
    } catch (error) {
        console.error('Get advising students error:', error);
        res.status(500).json({ error: 'Failed to get students' });
    }
});

// Get advisor for a student
app.get('/api/advising/advisor/:studentEmail', async (req, res) => {
    try {
        const { studentEmail } = req.params;
        const [rows] = await pool.execute(`
            SELECT u.* FROM users u
            JOIN academic_advising aa ON u.email = aa.advisor_email
            WHERE aa.student_email = ?
            LIMIT 1
        `, [studentEmail]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Advisor not found' });
        }

        res.json({ success: true, advisor: formatUser(rows[0]) });
    } catch (error) {
        console.error('Get advisor error:', error);
        res.status(500).json({ error: 'Failed to get advisor' });
    }
});

// Send message
app.post('/api/advising/messages', async (req, res) => {
    try {
        const { senderEmail, receiverEmail, message, isBroadcast } = req.body;

        await pool.execute(`
            INSERT INTO advising_messages (sender_email, receiver_email, message, is_broadcast)
            VALUES (?, ?, ?, ?)
        `, [senderEmail, receiverEmail || null, message, isBroadcast ? 1 : 0]);

        // If it's a broadcast from a doctor, we might want to notify students
        if (isBroadcast) {
            const [students] = await pool.execute(
                'SELECT student_email FROM academic_advising WHERE advisor_email = ?',
                [senderEmail]
            );

            for (const student of students) {
                await pool.execute(`
                    INSERT INTO notifications (user_email, title, message, type)
                    VALUES (?, ?, ?, 'advising')
                `, [student.student_email, 'New message from advisor', message]);
            }
        } else if (receiverEmail) {
            // Notify specific receiver
            await pool.execute(`
                INSERT INTO notifications (user_email, title, message, type)
                VALUES (?, ?, ?, 'advising')
            `, [receiverEmail, 'New advising message', message]);
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Send message error:', error);
        res.status(500).json({ error: 'Failed to send message' });
    }
});

// Get messages
app.get('/api/advising/messages', async (req, res) => {
    try {
        const { user1, user2 } = req.query; // For direct chat
        const { email, broadcast } = req.query; // For student getting broadcasts or doctor getting sent broadcasts

        let query = '';
        let params = [];

        if (user1 && user2) {
            // Direct chat between two users
            query = `
                SELECT * FROM advising_messages 
                WHERE (sender_email = ? AND receiver_email = ?) 
                   OR (sender_email = ? AND receiver_email = ?)
                ORDER BY created_at ASC
            `;
            params = [user1, user2, user2, user1];
        } else if (email && broadcast === 'true') {
            // Get broadcasts for a student OR broadcasts sent by a doctor
            // This is simplified: it gets broadcasts sent by the advisor of the student
            // or broadcasts sent by the doctor themselves.
            const [advisorRow] = await pool.execute(
                'SELECT advisor_email FROM academic_advising WHERE student_email = ?',
                [email]
            );

            const advisorEmail = advisorRow.length > 0 ? advisorRow[0].advisor_email : null;

            query = `
                SELECT * FROM advising_messages 
                WHERE (is_broadcast = TRUE AND (sender_email = ? OR sender_email = ?))
                ORDER BY created_at ASC
            `;
            params = [email, advisorEmail];
        }

        if (!query) return res.status(400).json({ error: 'Invalid query parameters' });

        const [rows] = await pool.execute(query, params);
        res.json({ success: true, messages: rows });
    } catch (error) {
        console.error('Get messages error:', error);
        res.status(500).json({ error: 'Failed to get messages' });
    }
});

// ============ HEALTH CHECK ============

app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Start server
const PORT = process.env.PORT || 3000;

initDatabase().then(() => {
    app.listen(PORT, () => {
        console.log(`🚀 Server running on http://localhost:${PORT}`);
    });
}).catch(err => {
    console.error('Failed to start server:', err);
});
