/**
 * User Routes
 */
const express = require('express');
const { body, param } = require('express-validator');

const router = express.Router();
const { prisma } = require('../utils/database');
const { validate } = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const logger = require('../utils/logger');

/**
 * Format user for response
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
  department: user.department?.name,
  departmentId: user.departmentId,
  program: user.program?.name,
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

// ============ GET DEPARTMENTS (METADATA) ============

router.get('/metadata/departments',
  async (req, res, next) => {
    try {
      const departments = await prisma.department.findMany({
        include: {
          programs: {
            orderBy: { name: 'asc' }
          }
        },
        orderBy: { name: 'asc' }
      });

      res.json({
        success: true,
        departments: departments.map(d => ({
          id: d.id,
          name: d.name,
          programs: d.programs.map(p => ({
            id: p.id,
            name: p.name
          }))
        })),
        levels: [
          { id: 1, name: 'Level 1 (Freshman)' },
          { id: 2, name: 'Level 2 (Sophomore)' },
          { id: 3, name: 'Level 3 (Junior)' },
          { id: 4, name: 'Level 4 (Senior)' }
        ]
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET PROFESSOR COURSES ============

router.get('/professor/courses',
  authenticate,
  async (req, res, next) => {
    try {
      const { email } = req.query;

      // Ensure user is requesting their own courses or is admin
      if (req.user.email !== email && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'Access denied');
      }

      // Verify user is a professor
      const user = await prisma.user.findUnique({
        where: { email },
        select: { role: true, id: true }
      });

      if (!user || user.role !== 'PROFESSOR') {
        throw new ApiError(403, 'User is not a professor');
      }

      // Get courses where user is an instructor
      const instructorCourses = await prisma.courseInstructor.findMany({
        where: { userId: user.id },
        include: {
          course: {
            include: {
              instructors: {
                include: {
                  user: {
                    select: { name: true, email: true }
                  }
                }
              },
              scheduleSlots: true,
              _count: {
                select: { enrollments: true }
              }
            }
          }
        }
      });

      const courses = instructorCourses.map(ic => ({
        ...ic.course,
        isPrimary: ic.isPrimary
      }));

      // Reuse formatCourse if available, or just map needed fields.
      // Since formatCourse is in course.routes.js and not exported, we duplicate logic or simple mapping.
      // AddContentScreen expects: id, code, name.
      
      res.json({
        success: true,
        courses: courses.map(c => ({
          id: c.id,
          code: c.code,
          name: c.name,
          category: c.category,
          isPrimary: c.isPrimary,
          enrollmentCount: c._count?.enrollments || 0
        }))
      });

    } catch (error) {
      next(error);
    }
  }
);

// ============ GET USER BY EMAIL ============

router.get('/:email',
  authenticate,
  [
    param('email').isEmail(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { email } = req.params;

      // Users can only view their own profile (unless admin)
      if (req.user.email !== email && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'Access denied');
      }

      const user = await prisma.user.findUnique({
        where: { email },
        include: {
          enrollments: {
            include: {
              course: {
                select: { id: true, code: true, name: true }
              }
            }
          },
          department: true,
          program: true
        }
      });

      if (!user) {
        throw new ApiError(404, 'User not found');
      }

      res.json({
        success: true,
        user: formatUserResponse(user)
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ UPDATE USER PROFILE ============

router.put('/:email',
  authenticate,
  [
    param('email').isEmail().normalizeEmail(),
    body('name').optional(),
    body('avatar').optional(),
    body('major').optional(),
    body('department').optional(),
    body('program').optional(),
    body('gpa').optional(),
    body('level').optional(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { email } = req.params;

      // Users can only update their own profile
      if (req.user.email !== email && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'Access denied');
      }

      const { 
        name, 
        nameAr,
        phone,
        studentId,
        avatar, 
        departmentId, // Use IDs for relations
        programId, 
        gpa, 
        level, 
        isOnboardingComplete, 
        enrolledCourses 
      } = req.body;

      // Update user
      const updatedUser = await prisma.user.update({
        where: { email },
        data: {
          ...(name && { name }),
          ...(nameAr !== undefined && { nameAr }),
          ...(phone !== undefined && { phone }),
          ...(studentId && { studentId }),
          ...(avatar !== undefined && { avatar }),
          // Update relations using IDs
          ...(departmentId && { departmentId }), 
          ...(programId && { programId }),
          ...(gpa !== undefined && { gpa }),
          ...(level !== undefined && { level }),
          ...(isOnboardingComplete !== undefined && { isOnboardingComplete })
        },
        include: {
          enrollments: {
            select: { courseId: true }
          }
        }
      });

      // Handle course enrollment if provided
      if (enrolledCourses && Array.isArray(enrolledCourses)) {
        // Get current enrollments
        const currentEnrollments = await prisma.enrollment.findMany({
          where: { userId: updatedUser.id },
          select: { courseId: true }
        });

        const currentCourseIds = currentEnrollments.map(e => e.courseId);
        const newCourseIds = enrolledCourses;

        // Courses to add
        const toAdd = newCourseIds.filter(id => !currentCourseIds.includes(id));
        // Courses to remove
        const toRemove = currentCourseIds.filter(id => !newCourseIds.includes(id));

        // Add new enrollments
        if (toAdd.length > 0) {
          await prisma.enrollment.createMany({
            data: toAdd.map(courseId => ({
              userId: updatedUser.id,
              courseId,
              status: 'ENROLLED'
            })),
            skipDuplicates: true
          });
        }

        // Remove old enrollments
        if (toRemove.length > 0) {
          await prisma.enrollment.deleteMany({
            where: {
              userId: updatedUser.id,
              courseId: { in: toRemove }
            }
          });
        }
      }

      // Fetch updated user with enrollments
      const finalUser = await prisma.user.findUnique({
        where: { id: updatedUser.id },
        include: {
          enrollments: {
            select: { courseId: true }
          },
          department: true,
          program: true
        }
      });

      logger.info(`✅ User updated: ${email}`);

      res.json({
        success: true,
        user: formatUserResponse(finalUser)
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ COMPLETE ONBOARDING ============

router.post('/complete-onboarding',
  authenticate,
  [
    body('enrolledCourses').isArray({ min: 1 }).withMessage('At least one course required'),
    validate
  ],
  async (req, res, next) => {
    try {
      const { enrolledCourses } = req.body;

      // Verify courses exist
      const courses = await prisma.course.findMany({
        where: { id: { in: enrolledCourses } }
      });

      if (courses.length !== enrolledCourses.length) {
        throw new ApiError(400, 'Some courses are invalid');
      }

      // Create enrollments
      await prisma.enrollment.createMany({
        data: enrolledCourses.map(courseId => ({
          userId: req.user.id,
          courseId,
          status: 'ENROLLED'
        })),
        skipDuplicates: true
      });

      // Mark onboarding as complete
      const updatedUser = await prisma.user.update({
        where: { id: req.user.id },
        data: { isOnboardingComplete: true },
        include: {
          enrollments: {
            select: { courseId: true }
          }
        }
      });

      logger.info(`✅ Onboarding completed: ${req.user.email}`);

      res.json({
        success: true,
        user: formatUserResponse(updatedUser)
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET USER ENROLLMENTS ============

router.get('/:email/enrollments',
  authenticate,
  async (req, res, next) => {
    try {
      const { email } = req.params;

      if (req.user.email !== email && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'Access denied');
      }

      const user = await prisma.user.findUnique({
        where: { email },
        select: { id: true }
      });

      if (!user) {
        throw new ApiError(404, 'User not found');
      }

      const enrollments = await prisma.enrollment.findMany({
        where: { userId: user.id },
        include: {
          course: {
            include: {
              instructors: {
                include: {
                  user: {
                    select: { name: true, email: true }
                  }
                }
              }
            }
          }
        }
      });

      res.json({
        success: true,
        enrollments: enrollments.map(e => ({
          id: e.id,
          status: e.status,
          enrolledAt: e.enrolledAt,
          grade: e.grade,
          course: {
            id: e.course.id,
            code: e.course.code,
            name: e.course.name,
            category: e.course.category,
            creditHours: e.course.creditHours,
            professors: e.course.instructors.map(i => i.user.name)
          }
        }))
      });
    } catch (error) {
      next(error);
    }
  }
);

module.exports = router;
