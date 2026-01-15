/**
 * Course Routes
 */
const express = require('express');
const { body, param, query } = require('express-validator');

const router = express.Router();
const { prisma } = require('../utils/database');
const { validate } = require('../middleware/validate');
const { authenticate, optionalAuth, requireProfessor } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const logger = require('../utils/logger');

/**
 * Format course for response
 */
const formatCourse = (course, studentId = null) => {
  // Separate tasks into assignments and exams
  const tasks = course.tasks || [];

  const assignments = tasks.filter(t => t.taskType === 'ASSIGNMENT' || t.taskType === 'LAB').map(t => {
    // Find submission for this student if studentId is provided
    const submission = studentId && t.submissions ? t.submissions.find(s => s.studentId === studentId) : null;

    return {
      id: t.id,
      title: t.title,
      description: t.description || '',
      dueDate: t.dueDate,
      maxScore: t.maxPoints || 100,
      isSubmitted: !!submission && submission.status !== 'PENDING',
      attachments: t.attachments || [],
      // Add grade and status info if available
      grade: submission ? (submission.grade || submission.points) : null,
      status: submission ? submission.status : 'PENDING'
    };
  });

  const exams = tasks.filter(t => t.taskType === 'EXAM' || t.taskType === 'QUIZ').map(t => {
    const submission = studentId && t.submissions ? t.submissions.find(s => s.studentId === studentId) : null;
    return {
      id: t.id,
      title: t.title,
      date: t.dueDate || t.startDate,
      format: t.taskType === 'QUIZ' ? 'Quiz' : 'Exam',
      gradingBreakdown: `${t.maxPoints} points`,
      attachments: t.attachments || [],
      // Add status info
      isSubmitted: !!submission && submission.status !== 'PENDING',
      status: submission ? submission.status : 'PENDING'
    };
  });

  return {
    id: course.id,
    code: course.code,
    name: course.name,
    description: course.description,
    category: course.category.toLowerCase(),
    creditHours: course.creditHours,
    semester: course.semester,
    year: course.year,
    isActive: course.isActive,
    professors: course.instructors?.map(i => ({
      name: i.user.name,
      email: i.user.email,
      isPrimary: i.isPrimary
    })) || [],
    schedule: course.scheduleSlots?.map(s => ({
      day: s.dayOfWeek,
      time: `${s.startTime} - ${s.endTime}`,
      location: s.location,
      attachments: s.attachments || []
    })) || [],
    content: (course.content || []).map(c => ({
      week: c.weekNumber || 0,
      topic: c.title,
      description: c.description || '',
      attachments: c.attachments || []
    })),
    assignments: assignments,
    exams: exams,
    enrollmentCount: course._count?.enrollments || 0
  };
};


// ============ GET ALL COURSES ============

router.get('/', optionalAuth, async (req, res, next) => {
  try {
    const { category, search, active } = req.query;

    const where = {
      ...(active !== undefined && { isActive: active === 'true' }),
      ...(category && { category: category.toUpperCase() }),
      ...(search && {
        OR: [
          { name: { contains: search } },
          { code: { contains: search } },
          { description: { contains: search } }
        ]
      })
    };

    const courses = await prisma.course.findMany({
      where,
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
      },
      orderBy: { code: 'asc' }
    });

    res.json({
      success: true,
      courses: courses.map(formatCourse)
    });
  } catch (error) {
    next(error);
  }
});

// ============ GET COURSE BY ID ============

router.get('/:id',
  optionalAuth,
  [
    param('id').notEmpty(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const course = await prisma.course.findUnique({
        where: { id },
        include: {
          instructors: {
            include: {
              user: {
                select: { id: true, name: true, email: true, avatar: true }
              }
            }
          },
          scheduleSlots: true,
          content: {
            where: { isPublished: true },
            orderBy: [{ weekNumber: 'asc' }, { orderIndex: 'asc' }]
          },
          tasks: {
            orderBy: { dueDate: 'asc' },
            include: {
              // Include submissions only for the current user if logged in
              submissions: req.user ? {
                where: { studentId: req.user.id }
              } : false
            }
          },
          _count: {
            select: {
              enrollments: true,
              tasks: true,
              announcements: true
            }
          }
        }
      });

      if (!course) {
        throw new ApiError(404, 'Course not found');
      }

      res.json({
        success: true,
        course: formatCourse(course, req.user ? req.user.id : null)
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET COURSE CONTENT ============

router.get('/:id/content',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const content = await prisma.courseContent.findMany({
        where: {
          courseId: id,
          isPublished: true
        },
        orderBy: [{ weekNumber: 'asc' }, { orderIndex: 'asc' }],
        include: {
          createdBy: {
            select: { name: true }
          }
        }
      });

      res.json({
        success: true,
        content: content.map(c => ({
          id: c.id,
          title: c.title,
          description: c.description,
          type: c.contentType,
          fileUrl: c.fileUrl,
          attachments: c.attachments,
          weekNumber: c.weekNumber,
          createdBy: c.createdBy.name,
          createdAt: c.createdAt
        }))
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET COURSE TASKS ============

router.get('/:id/tasks',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const tasks = await prisma.task.findMany({
        where: { courseId: id },
        orderBy: { dueDate: 'asc' },
        include: {
          createdBy: {
            select: { name: true }
          }
        }
      });

      res.json({
        success: true,
        tasks: tasks.map(t => ({
          id: t.id,
          title: t.title,
          description: t.description,
          type: t.taskType,
          priority: t.priority,
          status: t.status,
          dueDate: t.dueDate,
          maxPoints: t.maxPoints,
          createdBy: t.createdBy.name,
          createdAt: t.createdAt
        }))
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET ENROLLED STUDENTS (Professor only) ============

router.get('/:id/students',
  authenticate,
  requireProfessor,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      // Verify professor teaches this course
      const isInstructor = await prisma.courseInstructor.findFirst({
        where: {
          courseId: id,
          userId: req.user.id
        }
      });

      if (!isInstructor && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'You do not teach this course');
      }

      const enrollments = await prisma.enrollment.findMany({
        where: {
          courseId: id,
          status: 'ENROLLED'
        },
        include: {
          user: {
            select: {
              id: true,
              name: true,
              email: true,
              studentId: true,
              avatar: true,
              level: true
            }
          }
        },
        orderBy: {
          user: { name: 'asc' }
        }
      });

      res.json({
        success: true,
        students: enrollments.map(e => ({
          id: e.user.id,
          name: e.user.name,
          email: e.user.email,
          studentId: e.user.studentId,
          avatar: e.user.avatar,
          level: e.user.level,
          enrolledAt: e.enrolledAt,
          grade: e.grade
        })),
        count: enrollments.length
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET EXAM CONFLICTS FOR COURSE (Professor only) ============
// Returns dates where enrolled students have exams in OTHER courses

router.get('/:id/exam-conflicts',
  authenticate,
  requireProfessor,
  async (req, res, next) => {
    try {
      const { id: courseId } = req.params;

      // Verify professor teaches this course
      const isInstructor = await prisma.courseInstructor.findFirst({
        where: {
          courseId: courseId,
          userId: req.user.id
        }
      });

      if (!isInstructor && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'You do not teach this course');
      }

      // Get all enrolled student IDs for this course
      const enrollments = await prisma.enrollment.findMany({
        where: {
          courseId: courseId,
          status: 'ENROLLED'
        },
        select: { userId: true }
      });

      const studentIds = enrollments.map(e => e.userId);

      if (studentIds.length === 0) {
        return res.json({ success: true, conflicts: {} });
      }

      // Find all EXAM tasks in OTHER courses where these students are enrolled
      const examTasks = await prisma.task.findMany({
        where: {
          taskType: 'EXAM',
          dueDate: { not: null },
          courseId: { not: courseId }, // Other courses only
          course: {
            enrollments: {
              some: {
                userId: { in: studentIds },
                status: 'ENROLLED'
              }
            }
          }
        },
        select: {
          id: true,
          dueDate: true,
          course: {
            select: {
              enrollments: {
                where: {
                  userId: { in: studentIds },
                  status: 'ENROLLED'
                },
                select: { userId: true }
              }
            }
          }
        }
      });

      // Group by date and count unique students
      const conflictsByDate = {};
      for (const task of examTasks) {
        if (!task.dueDate) continue;

        // Normalize to date string (YYYY-MM-DD)
        const dateKey = task.dueDate.toISOString().split('T')[0];

        if (!conflictsByDate[dateKey]) {
          conflictsByDate[dateKey] = new Set();
        }

        // Add all students enrolled in this exam's course
        for (const enrollment of task.course.enrollments) {
          conflictsByDate[dateKey].add(enrollment.userId);
        }
      }

      // Convert sets to counts
      const conflicts = {};
      for (const [date, studentSet] of Object.entries(conflictsByDate)) {
        conflicts[date] = studentSet.size;
      }

      res.json({
        success: true,
        conflicts: conflicts
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET PROFESSOR'S COURSES ============

router.get('/professor/:email',
  authenticate,
  async (req, res, next) => {
    try {
      const { email } = req.params;

      // Find professor
      const professor = await prisma.user.findUnique({
        where: { email },
        select: { id: true, role: true }
      });

      if (!professor || professor.role !== 'PROFESSOR') {
        throw new ApiError(404, 'Professor not found');
      }

      // Get assigned courses
      const assignments = await prisma.courseInstructor.findMany({
        where: { userId: professor.id },
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
                select: {
                  enrollments: true,
                  tasks: true,
                  content: true
                }
              }
            }
          }
        }
      });

      res.json({
        success: true,
        courses: assignments.map(a => ({
          ...formatCourse(a.course),
          isPrimary: a.isPrimary,
          stats: {
            students: a.course._count.enrollments,
            tasks: a.course._count.tasks,
            content: a.course._count.content
          }
        }))
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ ENROLL IN COURSE ============

router.post('/:id/enroll',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      // Check course exists
      const course = await prisma.course.findUnique({
        where: { id }
      });

      if (!course) {
        throw new ApiError(404, 'Course not found');
      }

      if (!course.isActive) {
        throw new ApiError(400, 'Course is not available for enrollment');
      }

      // Check existing enrollment
      const existing = await prisma.enrollment.findUnique({
        where: {
          userId_courseId: {
            userId: req.user.id,
            courseId: id
          }
        }
      });

      if (existing) {
        if (existing.status === 'ENROLLED') {
          throw new ApiError(400, 'Already enrolled in this course');
        }
        // Re-enroll if previously dropped
        await prisma.enrollment.update({
          where: { id: existing.id },
          data: { status: 'ENROLLED', enrolledAt: new Date() }
        });
      } else {
        await prisma.enrollment.create({
          data: {
            userId: req.user.id,
            courseId: id,
            status: 'ENROLLED'
          }
        });
      }

      logger.info(`✅ User enrolled in course: ${req.user.email} -> ${course.code}`);

      res.json({
        success: true,
        message: 'Enrolled successfully'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ DROP COURSE ============

router.delete('/:id/enroll',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const enrollment = await prisma.enrollment.findUnique({
        where: {
          userId_courseId: {
            userId: req.user.id,
            courseId: id
          }
        }
      });

      if (!enrollment) {
        throw new ApiError(404, 'Not enrolled in this course');
      }

      await prisma.enrollment.update({
        where: { id: enrollment.id },
        data: { status: 'DROPPED' }
      });

      logger.info(`✅ User dropped course: ${req.user.email} -> ${id}`);

      res.json({
        success: true,
        message: 'Course dropped successfully'
      });
    } catch (error) {
      next(error);
    }
  }
);

module.exports = router;
