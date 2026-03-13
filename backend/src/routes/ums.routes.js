/**
 * UMS (University Management System) Integration Routes
 * Endpoints for ASU portal login, data sync, and retrieval
 * 
 * The /login endpoint is PUBLIC (no JWT) — it authenticates via UMS portal,
 * creates/updates the local user, and returns a JWT token.
 * All other endpoints require JWT authentication.
 */
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { prisma } = require('../utils/database');
const {
  loginToUMS,
  syncStudentData
} = require('../services/ums.service');
const logger = require('../utils/logger');

/**
 * Generate JWT token (same as auth.routes.js)
 */
const generateToken = (userId) => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
  );
};

/**
 * Format user response (same shape as auth.routes.js + UMS extras)
 */
const formatUserResponse = (user, umsProfile = {}) => ({
  id: user.id,
  email: user.email,
  name: user.name,
  nameAr: user.nameAr || umsProfile.nameAr || null,
  avatar: user.avatar,
  role: (user.role || 'STUDENT').toLowerCase(),
  studentId: user.studentId,
  phone: user.phone || umsProfile.phone || null,
  gpa: user.gpa,
  level: user.level,
  department: user.department?.name || null,
  departmentId: user.departmentId,
  program: user.program?.name || umsProfile.program || user.program || null,
  programId: user.programId,
  faculty: user.faculty || umsProfile.faculty || null,
  major: user.major || umsProfile.major || null,
  semester: user.semester || umsProfile.semester || null,
  academicYear: user.academicYear || umsProfile.academicYear || null,
  advisorName: umsProfile.advisorName || null,
  advisorEmail: umsProfile.advisorEmail || null,
  isVerified: user.isVerified,
  isOnboardingComplete: user.isOnboardingComplete,
  enrolledCourses: user.enrollments?.map(e => e.courseId) || [],
  mode: user.role === 'PROFESSOR' ? 'professor' : 'student'
});

// ============ POST /api/ums/login (PUBLIC — no JWT needed) ============
// Login to UMS with portal credentials, create/update local user, sync data, return JWT
router.post('/login', async (req, res, next) => {
  try {
    const { loginName, password } = req.body;

    if (!loginName || !password) {
      return res.status(400).json({
        error: 'loginName and password are required'
      });
    }

    // Step 1: Login via Puppeteer + fetch all data in one shot
    let umsResult;
    try {
      umsResult = await loginToUMS(loginName, password);
    } catch (err) {
      if (err.message.includes('invalid credentials') || err.message.includes('Login failed')) {
        return res.status(401).json({ error: 'Invalid UMS credentials' });
      }
      throw err;
    }

    const umsProfile = umsResult.profile || {};

    // Step 2: Map profile fields
    const email = umsProfile.email || (loginName.includes('@') ? loginName : `${loginName}@asu.edu.eg`);
    const name = umsProfile.nameEn || umsProfile.nameAr || loginName;
    const nameAr = umsProfile.nameAr || null;
    
    let studentId = umsProfile.ssn || loginName;
    if (studentId.includes('@')) {
      studentId = studentId.split('@')[0];
    }
    
    const phone = umsProfile.phone || null;

    let user = await prisma.user.findFirst({
      where: {
        OR: [
          { email: email },
          { studentId: studentId }
        ]
      },
      include: {
        department: { select: { id: true, name: true, code: true } },
        program: { select: { id: true, name: true, code: true } },
        enrollments: { select: { courseId: true } }
      }
    });

    const hashedPassword = await bcrypt.hash(password, 12);

    if (user) {
      // Update existing user with latest UMS data
      user = await prisma.user.update({
        where: { id: user.id },
        data: {
          name: name,
          nameAr: nameAr,
          email: email,
          phone: phone,
          studentId: studentId,
          password: hashedPassword,
          level: umsProfile.levelNum || user.level,
          faculty: umsProfile.faculty || user.faculty,
          major: umsProfile.major || user.major,
          semester: umsProfile.semester || user.semester,
          academicYear: umsProfile.academicYear || user.academicYear,
          advisorName: umsProfile.advisorName || user.advisorName,
          advisorEmail: umsProfile.advisorEmail || user.advisorEmail,
          isVerified: true,
          isOnboardingComplete: true,
          isActive: true,
          lastLoginAt: new Date()
        },
        include: {
          department: { select: { id: true, name: true, code: true } },
          program: { select: { id: true, name: true, code: true } },
          enrollments: { select: { courseId: true } }
        }
      });
    } else {
      // Create new user from UMS data
      user = await prisma.user.create({
        data: {
          email: email,
          password: hashedPassword,
          name: name,
          nameAr: nameAr,
          phone: phone,
          role: 'STUDENT',
          studentId: studentId,
          level: umsProfile.levelNum || null,
          faculty: umsProfile.faculty || null,
          major: umsProfile.major || null,
          semester: umsProfile.semester || null,
          academicYear: umsProfile.academicYear || null,
          advisorName: umsProfile.advisorName || null,
          advisorEmail: umsProfile.advisorEmail || null,
          isVerified: true,
          isOnboardingComplete: true,
          isActive: true,
          lastLoginAt: new Date()
        },
        include: {
          department: { select: { id: true, name: true, code: true } },
          program: { select: { id: true, name: true, code: true } },
          enrollments: { select: { courseId: true } }
        }
      });
    }

    // Step 4: Save UMS session cookies
    await prisma.umsSession.upsert({
      where: { userId: user.id },
      update: {
        cookies: umsResult.cookies || [],
        lastSyncAt: new Date(),
        isActive: true
      },
      create: {
        userId: user.id,
        cookies: umsResult.cookies || [],
        lastSyncAt: new Date(),
        isActive: true
      }
    });

    // Step 5: Sync courses & grades from the Puppeteer scrape result
    const syncResults = await syncStudentData(user.id, umsResult);

    // Step 6: Generate JWT token
    const token = generateToken(user.id);

    logger.info(`✅ UMS login successful: ${email} (synced ${syncResults.courses} courses, ${syncResults.grades} grades)`);

    res.json({
      success: true,
      message: 'UMS login and sync completed',
      user: formatUserResponse(user, umsProfile),
      token,
      sync: syncResults
    });
  } catch (error) {
    logger.error('[UMS Route] Login error:', error.message);
    if (error.message.includes('timeout') || error.message.includes('connection')) {
      return res.status(502).json({ error: 'Cannot reach UMS portal. Try again later.' });
    }
    next(error);
  }
});

// ============ ALL ROUTES BELOW REQUIRE JWT ============
router.use(authenticate);

// ============ POST /api/ums/sync ============
router.post('/sync', async (req, res, next) => {
  try {
    const { resyncWithStoredSession } = require('../services/ums.service');
    const results = await resyncWithStoredSession(req.user.id);

    res.json({
      message: 'UMS data re-synced',
      sync: results
    });
  } catch (error) {
    logger.error('[UMS Route] Sync error:', error.message);

    if (error.message.includes('expired') || error.message.includes('login again')) {
      return res.status(401).json({ error: 'UMS session expired', requiresLogin: true });
    }
    if (error.message.includes('No active UMS session')) {
      return res.status(404).json({ error: 'No UMS session found. Please login first.', requiresLogin: true });
    }
    next(error);
  }
});

// ============ GET /api/ums/courses ============
router.get('/courses', async (req, res, next) => {
  try {
    const courses = await prisma.umsCourse.findMany({
      where: { userId: req.user.id },
      orderBy: [{ academicYear: 'desc' }, { semester: 'desc' }, { courseCode: 'asc' }]
    });

    res.json({ count: courses.length, courses });
  } catch (error) {
    next(error);
  }
});

// ============ GET /api/ums/grades ============
router.get('/grades', async (req, res, next) => {
  try {
    const grades = await prisma.umsGrade.findMany({
      where: { userId: req.user.id },
      orderBy: [{ academicYear: 'desc' }, { semester: 'desc' }, { courseCode: 'asc' }]
    });

    const gradedEntries = grades.filter(g => g.gradePoints != null && g.creditHours != null);
    let totalPoints = 0, totalHours = 0;
    for (const g of gradedEntries) {
      totalPoints += g.gradePoints * g.creditHours;
      totalHours += g.creditHours;
    }
    const cumulativeGPA = totalHours > 0 ? parseFloat((totalPoints / totalHours).toFixed(2)) : null;

    res.json({ count: grades.length, cumulativeGPA, totalCreditHours: totalHours, grades });
  } catch (error) {
    next(error);
  }
});

// ============ GET /api/ums/profile ============
router.get('/profile', async (req, res, next) => {
  try {
    const session = await prisma.umsSession.findUnique({ where: { userId: req.user.id } });
    const [courseCount, gradeCount] = await Promise.all([
      prisma.umsCourse.count({ where: { userId: req.user.id } }),
      prisma.umsGrade.count({ where: { userId: req.user.id } })
    ]);

    res.json({
      isConnected: !!session?.isActive,
      lastSyncAt: session?.lastSyncAt || null,
      courseCount,
      gradeCount
    });
  } catch (error) {
    next(error);
  }
});

// ============ DELETE /api/ums/session ============
router.delete('/session', async (req, res, next) => {
  try {
    const { clearData } = req.query;
    await prisma.umsSession.deleteMany({ where: { userId: req.user.id } });

    if (clearData === 'true') {
      await Promise.all([
        prisma.umsCourse.deleteMany({ where: { userId: req.user.id } }),
        prisma.umsGrade.deleteMany({ where: { userId: req.user.id } })
      ]);
    }

    res.json({ message: 'UMS session disconnected', dataCleared: clearData === 'true' });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
