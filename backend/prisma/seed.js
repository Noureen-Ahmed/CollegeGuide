/**
 * Database Seed Script - Real Egyptian Science Faculty Data
 * Run with: npm run prisma:seed
 */
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

// Load real course data from courses.json
const coursesData = JSON.parse(
  fs.readFileSync(path.join(__dirname, '../../courses.json'), 'utf8')
);

async function main() {
  console.log('🌱 Starting database seed with REAL course data...\n');

  // ============ CLEAN OLD DATA ============
  console.log('🧹 Cleaning old data...');
  
  await prisma.taskSubmission.deleteMany({});
  await prisma.task.deleteMany({});
  await prisma.courseContent.deleteMany({});
  await prisma.courseSchedule.deleteMany({});
  await prisma.enrollment.deleteMany({});
  await prisma.courseInstructor.deleteMany({});
  await prisma.announcement.deleteMany({});
  await prisma.scheduleEvent.deleteMany({});
  await prisma.course.deleteMany({});
  await prisma.programInstructor.deleteMany({});
  await prisma.program.deleteMany({});
  await prisma.user.deleteMany({});
  await prisma.department.deleteMany({});
  await prisma.faculty.deleteMany({});
  
  console.log('✅ Old data cleaned');

  // ============ CREATE FACULTY ============
  console.log('📁 Creating faculty...');
  
  const scienceFaculty = await prisma.faculty.create({
    data: {
      code: 'SCI',
      name: 'Faculty of Science',
      nameAr: 'كلية العلوم',
      description: 'Faculty of Science at Egyptian University'
    }
  });

  console.log('✅ Faculty created');

  // ============ CREATE DEPARTMENTS ============
  console.log('🏢 Creating departments...');

  const departments = await prisma.$transaction([
    prisma.department.create({
      data: {
        code: 'MATH', name: 'Mathematics Department',
        nameAr: 'قسم الرياضيات', facultyId: scienceFaculty.id
      }
    }),
    prisma.department.create({
      data: {
        code: 'PHYS', name: 'Physics Department',
        nameAr: 'قسم الفيزياء', facultyId: scienceFaculty.id
      }
    }),
    prisma.department.create({
      data: {
        code: 'CHEM', name: 'Chemistry Department',
        nameAr: 'قسم الكيمياء', facultyId: scienceFaculty.id
      }
    }),
    prisma.department.create({
      data: {
        code: 'BIO', name: 'Biology Department',
        nameAr: 'قسم الأحياء', facultyId: scienceFaculty.id
      }
    }),
    prisma.department.create({
      data: {
        code: 'GEOL', name: 'Geology Department',
        nameAr: 'قسم الجيولوجيا', facultyId: scienceFaculty.id
      }
    }),
    prisma.department.create({
      data: {
        code: 'UNIV', name: 'University Requirements',
        nameAr: 'متطلبات الجامعة', facultyId: scienceFaculty.id
      }
    })
  ]);

  const deptMap = {};
  departments.forEach(d => deptMap[d.code] = d);

  console.log('✅ Departments created');

  // ============ CREATE PROGRAMS ============
  console.log('📚 Creating programs...');

  const programs = await prisma.$transaction([
    prisma.program.create({ data: { code: 'CS', name: 'Computer Science', nameAr: 'علوم الحاسب', creditHours: 136, departmentId: deptMap['MATH'].id } }),
    prisma.program.create({ data: { code: 'STAT', name: 'Statistics', nameAr: 'الإحصاء', creditHours: 132, departmentId: deptMap['MATH'].id } }),
    prisma.program.create({ data: { code: 'PMATH', name: 'Pure Mathematics', nameAr: 'الرياضيات البحتة', creditHours: 132, departmentId: deptMap['MATH'].id } }),
    prisma.program.create({ data: { code: 'PHYS', name: 'Physics', nameAr: 'الفيزياء', creditHours: 136, departmentId: deptMap['PHYS'].id } }),
    prisma.program.create({ data: { code: 'CHEM', name: 'Chemistry', nameAr: 'الكيمياء', creditHours: 132, departmentId: deptMap['CHEM'].id } }),
    prisma.program.create({ data: { code: 'BOTA', name: 'Botany', nameAr: 'النبات', creditHours: 128, departmentId: deptMap['BIO'].id } }),
    prisma.program.create({ data: { code: 'ZOOL', name: 'Zoology', nameAr: 'الحيوان', creditHours: 128, departmentId: deptMap['BIO'].id } }),
    prisma.program.create({ data: { code: 'MICR', name: 'Microbiology', nameAr: 'الميكروبيولوجي', creditHours: 128, departmentId: deptMap['BIO'].id } }),
    prisma.program.create({ data: { code: 'GEOL', name: 'Geology', nameAr: 'الجيولوجيا', creditHours: 132, departmentId: deptMap['GEOL'].id } })
  ]);

  const progMap = {};
  programs.forEach(p => progMap[p.code] = p);

  console.log('✅ Programs created');

  // ============ CREATE USERS ============
  console.log('👥 Creating users...');
  
  const hashedPassword = await bcrypt.hash('password123', 10);
  
  // Admin
  const admin = await prisma.user.create({
    data: {
      email: 'admin@college.edu',
      password: hashedPassword,
      name: 'System Admin',
      role: 'ADMIN',
      isVerified: true, isOnboardingComplete: true
    }
  });

  // Professors
  const professors = await prisma.$transaction([
    prisma.user.create({
      data: {
        email: 'doctor@college.edu', password: hashedPassword, name: 'Dr. Smith',
        role: 'PROFESSOR', departmentId: deptMap['MATH'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'dr.ahmed@college.edu', password: hashedPassword, name: 'د. أحمد حسن',
        role: 'PROFESSOR', departmentId: deptMap['MATH'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'dr.mohamed@college.edu', password: hashedPassword, name: 'د. محمد علي',
        role: 'PROFESSOR', departmentId: deptMap['MATH'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'dr.fatma@college.edu', password: hashedPassword, name: 'د. فاطمة سالم',
        role: 'PROFESSOR', departmentId: deptMap['PHYS'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'dr.khaled@college.edu', password: hashedPassword, name: 'د. خالد مصطفى',
        role: 'PROFESSOR', departmentId: deptMap['CHEM'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'dr.rania@college.edu', password: hashedPassword, name: 'د. رانيا حسن',
        role: 'PROFESSOR', departmentId: deptMap['BIO'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'dr.sami@college.edu', password: hashedPassword, name: 'د. سامي عثمان',
        role: 'PROFESSOR', departmentId: deptMap['GEOL'].id, isVerified: true, isOnboardingComplete: true
      }
    })
  ]);

  const profMap = {};
  professors.forEach(p => profMap[p.email] = p);

  // Students
  const students = await prisma.$transaction([
    prisma.user.create({
      data: {
        email: 'student@college.edu', password: hashedPassword, name: 'أحمد محمد',
        role: 'STUDENT', studentId: '2024001', level: 2,
        programId: progMap['CS'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'sara@college.edu', password: hashedPassword, name: 'سارة أحمد',
        role: 'STUDENT', studentId: '2024002', level: 3,
        programId: progMap['STAT'].id, isVerified: true, isOnboardingComplete: true
      }
    }),
    prisma.user.create({
      data: {
        email: 'omar@college.edu', password: hashedPassword, name: 'عمر حسن',
        role: 'STUDENT', studentId: '2024003', level: 1,
        programId: progMap['PHYS'].id, isVerified: true, isOnboardingComplete: true
      }
    })
  ]);

  const studentMap = {};
  students.forEach(s => studentMap[s.email] = s);

  console.log('✅ Users created');

  // ============ CREATE COURSES FROM courses.json ============
  console.log('📚 Creating courses from courses.json...');

  function mapDepartment(deptName) {
    if (deptName === 'Mathematics') return deptMap['MATH'].id;
    if (deptName === 'Physics') return deptMap['PHYS'].id;
    if (deptName === 'Chemistry') return deptMap['CHEM'].id;
    if (deptName === 'Botany' || deptName === 'Zoology' || deptName === 'Microbiology') return deptMap['BIO'].id;
    if (deptName === 'Geology') return deptMap['GEOL'].id;
    return deptMap['UNIV'].id;
  }

  function mapCategory(code) {
    if (code.startsWith('COMP')) return 'COMP';
    if (code.startsWith('MATH')) return 'MATH';
    if (code.startsWith('STAT')) return 'MATH';
    if (code.startsWith('PHYS')) return 'PHYS';
    if (code.startsWith('CHEM')) return 'CHEM';
    if (code.startsWith('BIO') || code.startsWith('ZOOL') || code.startsWith('BOTA') || code.startsWith('MICR')) return 'BIO';
    if (code.startsWith('GEOL')) return 'GENERAL';
    return 'GENERAL';
  }

  // Create all courses
  const createdCourses = [];
  for (const c of coursesData.courses) {
    const course = await prisma.course.create({
      data: {
        code: c.course_code.replace(' ', ''),
        name: c.course_title.split('(')[1]?.replace(')', '').trim() || c.course_title,
        nameAr: c.course_title.split('(')[0].trim(),
        description: `${c.course_title} - ${c.credit_hours} credit hours`,
        category: mapCategory(c.course_code),
        creditHours: c.credit_hours,
        semester: 'FALL',
        academicYear: '2024-2025',
        isActive: true,
        departmentId: mapDepartment(c.department)
      }
    });
    createdCourses.push(course);
  }

  console.log(`✅ Created ${createdCourses.length} courses`);

  // ============ ASSIGN PROFESSORS TO COURSES ============
  console.log('👨‍🏫 Assigning professors to courses...');

  // Assign CS & COMP courses to Dr. Ahmed
  const csCourses = createdCourses.filter(c => c.code.startsWith('COMP') || c.code.startsWith('MATH'));
  for (let i = 0; i < Math.min(10, csCourses.length); i++) {
    await prisma.courseInstructor.create({
      data: {
        userId: professors[i % 2 === 0 ? 0 : 1].id,
        courseId: csCourses[i].id,
        isPrimary: true
      }
    });
  }

  // Assign STAT courses to Dr. Mohamed
  const statCourses = createdCourses.filter(c => c.code.startsWith('STAT'));
  for (const course of statCourses) {
    await prisma.courseInstructor.create({
      data: { userId: professors[1].id, courseId: course.id, isPrimary: true }
    });
  }

  // Assign PHYS courses to Dr. Fatma
  const physCourses = createdCourses.filter(c => c.code.startsWith('PHYS'));
  for (const course of physCourses) {
    await prisma.courseInstructor.create({
      data: { userId: professors[2].id, courseId: course.id, isPrimary: true }
    });
  }

  // Assign CHEM courses to Dr. Khaled
  const chemCourses = createdCourses.filter(c => c.code.startsWith('CHEM'));
  for (const course of chemCourses) {
    await prisma.courseInstructor.create({
      data: { userId: professors[3].id, courseId: course.id, isPrimary: true }
    });
  }

  // Assign BIO courses to Dr. Rania (professors[4])
  const bioCourses = createdCourses.filter(c => c.category === 'BIO');
  for (const course of bioCourses) {
    await prisma.courseInstructor.create({
      data: { userId: professors[4].id, courseId: course.id, isPrimary: true }
    });
  }

  // Assign GEOL courses to Dr. Sami (professors[5])
  const geolCourses = createdCourses.filter(c => c.code.startsWith('GEOL'));
  for (const course of geolCourses) {
    await prisma.courseInstructor.create({
      data: { userId: professors[5].id, courseId: course.id, isPrimary: true }
    });
  }

  console.log('✅ Professors assigned to courses');

  // ============ ENROLL STUDENTS ============
  console.log('📝 Enrolling students in courses...');

  // Student 1: CS student - enroll in COMP and MATH courses
  const student1Courses = createdCourses.filter(c => 
    c.code.startsWith('COMP') || c.code === 'MATH101' || c.code === 'MATH102' || c.code === 'STAT101'
  ).slice(0, 6);
  
  for (const course of student1Courses) {
    await prisma.enrollment.create({
      data: { userId: students[0].id, courseId: course.id, status: 'ENROLLED' }
    });
    
    // Assign these specific courses to doctor@college.edu
    const doctorUser = professors.find(p => p.email === 'doctor@college.edu');
    if (doctorUser) {
      try {
        await prisma.courseInstructor.create({
          data: { userId: doctorUser.id, courseId: course.id, isPrimary: true }
        });
      } catch (e) {
        // Already assigned, which is fine
      }
    }
  }

  // Student 2: Stats student
  const student2Courses = createdCourses.filter(c => 
    c.code.startsWith('STAT') || c.code === 'MATH101' || c.code === 'MATH203'
  ).slice(0, 5);
  
  for (const course of student2Courses) {
    await prisma.enrollment.create({
      data: { userId: students[1].id, courseId: course.id, status: 'ENROLLED' }
    });
  }

  // Student 3: Physics student
  const student3Courses = createdCourses.filter(c => 
    c.code.startsWith('PHYS') || c.code === 'MATH101' || c.code === 'CHEM101'
  ).slice(0, 5);
  
  for (const course of student3Courses) {
    await prisma.enrollment.create({
      data: { userId: students[2].id, courseId: course.id, status: 'ENROLLED' }
    });
  }

  console.log('✅ Students enrolled');

  // ============ CREATE COURSE SCHEDULES ============
  console.log('📅 Creating course schedules...');

  const days = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY'];
  const times = [
    { start: '08:00', end: '09:30' },
    { start: '09:45', end: '11:15' },
    { start: '11:30', end: '13:00' },
    { start: '14:00', end: '15:30' },
    { start: '15:45', end: '17:15' }
  ];
  const locations = ['Building A', 'Building B', 'Labs Building', 'Main Hall'];

  // Create schedules for enrolled courses
  const enrolledCourseIds = [...student1Courses, ...student2Courses, ...student3Courses]
    .map(c => c.id)
    .filter((v, i, a) => a.indexOf(v) === i);

  for (let i = 0; i < enrolledCourseIds.length; i++) {
    const course = createdCourses.find(c => c.id === enrolledCourseIds[i]);
    if (!course) continue;

    // 2 sessions per course
    await prisma.courseSchedule.create({
      data: {
        courseId: course.id,
        dayOfWeek: days[i % days.length],
        startTime: times[i % times.length].start,
        endTime: times[i % times.length].end,
        location: locations[i % locations.length],
        room: `Room ${100 + i}`
      }
    });

    await prisma.courseSchedule.create({
      data: {
        courseId: course.id,
        dayOfWeek: days[(i + 2) % days.length],
        startTime: times[(i + 1) % times.length].start,
        endTime: times[(i + 1) % times.length].end,
        location: locations[i % locations.length],
        room: `Room ${100 + i}`
      }
    });
  }

  console.log('✅ Course schedules created');

  // ============ CREATE TASKS ============
  console.log('📋 Creating tasks...');

  const nextWeek = new Date();
  nextWeek.setDate(nextWeek.getDate() + 7);

  const twoWeeks = new Date();
  twoWeeks.setDate(twoWeeks.getDate() + 14);

  const threeWeeks = new Date();
  threeWeeks.setDate(threeWeeks.getDate() + 21);

  // Get first few courses with instructors
  const comp102 = createdCourses.find(c => c.code === 'COMP102');
  const comp104 = createdCourses.find(c => c.code === 'COMP104');
  const math101 = createdCourses.find(c => c.code === 'MATH101');
  const stat101 = createdCourses.find(c => c.code === 'STAT101');

  if (comp102) {
    await prisma.task.create({
      data: {
        title: 'Python Programming Lab',
        description: 'Complete exercises 1-5 from Chapter 3',
        taskType: 'LAB',
        priority: 'MEDIUM',
        dueDate: nextWeek,
        maxPoints: 20,
        courseId: comp102.id,
        createdById: professors[0].id
      }
    });
  }

  if (comp104) {
    await prisma.task.create({
      data: {
        title: 'Midterm Exam - Programming 1',
        description: 'Covers: Variables, Loops, Functions, Arrays',
        taskType: 'EXAM',
        priority: 'HIGH',
        dueDate: twoWeeks,
        startDate: twoWeeks,
        maxPoints: 100,
        courseId: comp104.id,
        createdById: professors[0].id
      }
    });

    await prisma.task.create({
      data: {
        title: 'Assignment 1: Calculator Program',
        description: 'Build a simple calculator using Python',
        taskType: 'ASSIGNMENT',
        priority: 'MEDIUM',
        dueDate: nextWeek,
        maxPoints: 30,
        courseId: comp104.id,
        createdById: professors[0].id
      }
    });
  }

  if (math101) {
    await prisma.task.create({
      data: {
        title: 'Calculus Problem Set 1',
        description: 'Problems from Chapter 2: Derivatives',
        taskType: 'ASSIGNMENT',
        priority: 'MEDIUM',
        dueDate: nextWeek,
        maxPoints: 25,
        courseId: math101.id,
        createdById: professors[1].id
      }
    });

    await prisma.task.create({
      data: {
        title: 'Quiz 1: Limits',
        description: 'Short quiz on limits and continuity',
        taskType: 'QUIZ',
        priority: 'MEDIUM',
        dueDate: threeWeeks,
        maxPoints: 15,
        courseId: math101.id,
        createdById: professors[1].id
      }
    });
  }

  if (stat101) {
    await prisma.task.create({
      data: {
        title: 'Statistics Lab Report',
        description: 'Data analysis using SPSS or R',
        taskType: 'LAB',
        priority: 'MEDIUM',
        dueDate: twoWeeks,
        maxPoints: 40,
        courseId: stat101.id,
        createdById: professors[1].id
      }
    });
  }

  console.log('✅ Tasks created');

  // ============ CREATE ANNOUNCEMENTS ============
  console.log('📢 Creating announcements...');

  await prisma.announcement.create({
    data: {
      title: 'مرحباً بكم في الفصل الدراسي الجديد',
      message: 'نتمنى لكم فصلاً دراسياً موفقاً. يرجى مراجعة الجداول الدراسية.',
      type: 'GENERAL',
      isPinned: true,
      createdById: admin.id
    }
  });

  console.log('✅ Announcements created');

  // ============ SUMMARY ============
  console.log('\n========================================');
  console.log('🎉 Database seeded successfully!');
  console.log('========================================\n');
  console.log('📊 Summary:');
  console.log(`   • Courses: ${createdCourses.length}`);
  console.log(`   • Professors: ${professors.length}`);
  console.log(`   • Students: ${students.length}`);
  console.log('\n👤 Test Accounts (password: password123):');
  console.log('   Students:');
  console.log('   • student@college.edu (CS student)');
  console.log('   • sara@college.edu (Stats student)');
  console.log('   • omar@college.edu (Physics student)');
  console.log('   Professors:');
  console.log('   • doctor@college.edu (Dr. Smith)');
  console.log('   • dr.ahmed@college.edu (Math/CS)');
  console.log('   • dr.mohamed@college.edu (Math/Stats)');
  console.log('   • dr.fatma@college.edu (Physics)');
  console.log('   • dr.khaled@college.edu (Chemistry)');
  console.log('   Admin:');
  console.log('   • admin@college.edu');
  console.log('========================================\n');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('❌ Seed error:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
