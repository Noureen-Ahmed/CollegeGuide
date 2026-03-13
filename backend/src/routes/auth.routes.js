/**
 * Authentication Routes
 */
const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body } = require('express-validator');
const { v4: uuidv4 } = require('uuid');

const router = express.Router();
const { prisma } = require('../utils/database');
const { validate } = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const { sendVerificationEmail, sendWelcomeEmail } = require('../services/email.service');
const { updateUserToken } = require('../services/notification.service');
const logger = require('../utils/logger');

/**
 * Generate JWT token
 */
const generateToken = (userId) => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
  );
};

/**
 * Generate verification code
 */
const generateCode = () => {
  return Math.floor(1000 + Math.random() * 9000).toString();
};

/**
 * Format user response (exclude sensitive fields)
 */
const formatUserResponse = (user) => ({
  id: user.id,
  email: user.email,
  name: user.name,
  nameAr: user.nameAr,
  phone: user.phone,
  avatar: user.avatar,
  role: user.role.toLowerCase(),
  studentId: user.studentId,
  faculty: user.faculty,
  major: user.major,
  department: user.department?.name || null,
  departmentId: user.departmentId,
  program: user.program?.name || null,
  programId: user.programId,
  semester: user.semester,
  academicYear: user.academicYear,
  gpa: user.gpa,
  level: user.level,
  isVerified: user.isVerified,
  isOnboardingComplete: user.isOnboardingComplete,
  advisorName: user.advisorName || null,
  advisorEmail: user.advisorEmail || null,
  enrolledCourses: user.enrollments?.map(e => e.courseId) || [],
  mode: user.role === 'PROFESSOR' ? 'professor' : 'student'
});

// ============ REGISTER ============

router.post('/register',
  [
    body('name').trim().notEmpty().withMessage('Name is required'),
    body('email').isEmail().normalizeEmail().withMessage('Valid email is required'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
    validate
  ],
  async (req, res, next) => {
    try {
      const { name, email, password } = req.body;

      // Check existing user
      const existingUser = await prisma.user.findUnique({
        where: { email }
      });

      if (existingUser) {
        throw new ApiError(409, 'An account with this email already exists');
      }

      // Determine role based on email
      let role = 'STUDENT';
      if (email.includes('doctor') || email.includes('professor') || email.includes('dr.')) {
        role = 'PROFESSOR';
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 12);

      // Generate student ID for students
      const studentId = role === 'STUDENT'
        ? `STU${Date.now().toString().slice(-8)}`
        : null;

      // Create user
      const user = await prisma.user.create({
        data: {
          email,
          password: hashedPassword,
          name,
          role,
          studentId,
          isVerified: false,
          isOnboardingComplete: false
        },
        include: {
          enrollments: true
        }
      });

      // Generate verification code
      const code = generateCode();
      await prisma.verificationCode.create({
        data: {
          userId: user.id,
          code,
          type: 'REGISTRATION',
          expiresAt: new Date(Date.now() + 15 * 60 * 1000) // 15 minutes
        }
      });

      // Send verification email
      const emailResult = await sendVerificationEmail(email, code, 'registration');

      if (!emailResult.success) {
        // Rollback: Delete the user if email failed
        await prisma.verificationCode.deleteMany({ where: { userId: user.id } });
        await prisma.user.delete({ where: { id: user.id } });

        // Log the specific error for debugging
        logger.error(`Registration failed: Email not sent. ${emailResult.error}`);
        throw new ApiError(500, `Failed to send verification email: ${emailResult.error || 'Check backend logs'}`);
      }

      // Generate token
      const token = generateToken(user.id);

      logger.info(`✅ User registered and email sent: ${email} (${role})`);

      res.status(201).json({
        success: true,
        message: 'Registration successful. Please verify your email.',
        user: formatUserResponse(user),
        token
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ LOGIN ============

router.post('/login',
  [
    body('email').isEmail().normalizeEmail().withMessage('Valid email is required'),
    body('password').notEmpty().withMessage('Password is required'),
    validate
  ],
  async (req, res, next) => {
    try {
      const { email, password, fcmToken } = req.body;

      // Find user
      const user = await prisma.user.findUnique({
        where: { email },
        include: {
          department: { select: { id: true, name: true, code: true } },
          program: { select: { id: true, name: true, code: true } },
          enrollments: {
            select: { courseId: true }
          }
        }
      });

      if (!user) {
        throw new ApiError(401, 'Invalid email or password');
      }

      if (!user.isActive) {
        throw new ApiError(403, 'Your account has been deactivated');
      }

      // Verify password
      const isValidPassword = await bcrypt.compare(password, user.password);
      if (!isValidPassword) {
        throw new ApiError(401, 'Invalid email or password');
      }

      // Update FCM token if provided
      if (fcmToken) {
        await updateUserToken(user.id, fcmToken);
      }

      // Update last login
      const updateData = { lastLoginAt: new Date() };

      // PATCH FIX: Ensure seeded users bypass onboarding if not set
      // AND regular users bypass it for now as requested
      if (!user.isOnboardingComplete) {
        updateData.isOnboardingComplete = true;
        user.isOnboardingComplete = true; // Update local obj for response
      }

      await prisma.user.update({
        where: { id: user.id },
        data: updateData
      });

      // Generate token
      const token = generateToken(user.id);

      logger.info(`✅ User logged in: ${email}`);

      res.json({
        success: true,
        user: formatUserResponse(user),
        token
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ VERIFY EMAIL ============

router.post('/verify',
  [
    body('email').isEmail().normalizeEmail(),
    body('code').isLength({ min: 4, max: 6 }),
    validate
  ],
  async (req, res, next) => {
    try {
      const { email, code } = req.body;

      // Find user
      const user = await prisma.user.findUnique({
        where: { email }
      });

      if (!user) {
        throw new ApiError(404, 'User not found');
      }

      // Find valid verification code
      const verification = await prisma.verificationCode.findFirst({
        where: {
          userId: user.id,
          code,
          type: 'REGISTRATION',
          used: false,
          expiresAt: { gt: new Date() }
        },
        orderBy: { createdAt: 'desc' }
      });

      if (!verification) {
        throw new ApiError(400, 'Invalid or expired verification code');
      }

      // Mark code as used and verify user
      await prisma.$transaction([
        prisma.verificationCode.update({
          where: { id: verification.id },
          data: { used: true }
        }),
        prisma.user.update({
          where: { id: user.id },
          data: { isVerified: true }
        })
      ]);

      // Send welcome email
      await sendWelcomeEmail(email, user.name);

      logger.info(`✅ Email verified: ${email}`);

      res.json({
        success: true,
        message: 'Email verified successfully'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ RESEND CODE ============

router.post('/resend-code',
  [
    body('email').isEmail().normalizeEmail(),
    body('type').isIn(['REGISTRATION', 'PASSWORD_RESET']).optional(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { email, type = 'REGISTRATION' } = req.body;

      const user = await prisma.user.findUnique({
        where: { email }
      });

      if (!user) {
        // Don't reveal if email exists
        return res.json({ success: true, message: 'If this email exists, a code has been sent' });
      }

      // Delete old codes
      await prisma.verificationCode.deleteMany({
        where: { userId: user.id, type }
      });

      // Generate new code
      const code = generateCode();
      await prisma.verificationCode.create({
        data: {
          userId: user.id,
          code,
          type,
          expiresAt: new Date(Date.now() + 15 * 60 * 1000)
        }
      });

      // Send email
      await sendVerificationEmail(email, code, type.toLowerCase());

      res.json({
        success: true,
        message: 'Verification code sent'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ FORGOT PASSWORD ============

router.post('/forgot-password',
  [
    body('email').isEmail().normalizeEmail(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { email } = req.body;

      const user = await prisma.user.findUnique({
        where: { email }
      });

      if (!user) {
        // Don't reveal if email exists
        return res.json({ success: true, message: 'If this email exists, a reset code has been sent' });
      }

      // Delete old codes
      await prisma.verificationCode.deleteMany({
        where: { userId: user.id, type: 'PASSWORD_RESET' }
      });

      // Generate code
      const code = generateCode();
      await prisma.verificationCode.create({
        data: {
          userId: user.id,
          code,
          type: 'PASSWORD_RESET',
          expiresAt: new Date(Date.now() + 15 * 60 * 1000)
        }
      });

      await sendVerificationEmail(email, code, 'password_reset');

      res.json({
        success: true,
        message: 'Password reset code sent'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ RESET PASSWORD ============

router.post('/reset-password',
  [
    body('email').isEmail().normalizeEmail(),
    body('code').isLength({ min: 4, max: 6 }),
    body('newPassword').isLength({ min: 6 }),
    validate
  ],
  async (req, res, next) => {
    try {
      const { email, code, newPassword } = req.body;

      const user = await prisma.user.findUnique({
        where: { email }
      });

      if (!user) {
        throw new ApiError(404, 'User not found');
      }

      // Verify code
      const verification = await prisma.verificationCode.findFirst({
        where: {
          userId: user.id,
          code,
          type: 'PASSWORD_RESET',
          used: false,
          expiresAt: { gt: new Date() }
        }
      });

      if (!verification) {
        throw new ApiError(400, 'Invalid or expired reset code');
      }

      // Hash new password
      const hashedPassword = await bcrypt.hash(newPassword, 12);

      // Update password and mark code as used
      await prisma.$transaction([
        prisma.verificationCode.update({
          where: { id: verification.id },
          data: { used: true }
        }),
        prisma.user.update({
          where: { id: user.id },
          data: { password: hashedPassword }
        })
      ]);

      logger.info(`✅ Password reset: ${email}`);

      res.json({
        success: true,
        message: 'Password reset successfully'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ CHANGE PASSWORD ============

router.post('/change-password',
  authenticate,
  [
    body('currentPassword').notEmpty(),
    body('newPassword').isLength({ min: 6 }),
    validate
  ],
  async (req, res, next) => {
    try {
      const { currentPassword, newPassword } = req.body;

      const user = await prisma.user.findUnique({
        where: { id: req.user.id }
      });

      // Verify current password
      const isValid = await bcrypt.compare(currentPassword, user.password);
      if (!isValid) {
        throw new ApiError(400, 'Current password is incorrect');
      }

      // Hash and update
      const hashedPassword = await bcrypt.hash(newPassword, 12);
      await prisma.user.update({
        where: { id: user.id },
        data: { password: hashedPassword }
      });

      res.json({
        success: true,
        message: 'Password changed successfully'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET CURRENT USER ============

router.get('/me', authenticate, async (req, res, next) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: {
        enrollments: {
          select: { courseId: true }
        }
      }
    });

    res.json({
      success: true,
      user: formatUserResponse(user)
    });
  } catch (error) {
    next(error);
  }
});

// ============ UPDATE FCM TOKEN ============

router.post('/fcm-token',
  authenticate,
  [
    body('fcmToken').notEmpty(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { fcmToken } = req.body;
      await updateUserToken(req.user.id, fcmToken);

      res.json({
        success: true,
        message: 'FCM token updated'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ LOGOUT ============

router.post('/logout', authenticate, async (req, res, next) => {
  try {
    // Clear FCM token
    await prisma.user.update({
      where: { id: req.user.id },
      data: { fcmToken: null }
    });

    res.json({
      success: true,
      message: 'Logged out successfully'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
