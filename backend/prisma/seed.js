/**
 * Database Seed Script - Real Egyptian Science Faculty Data
 * SAFE VERSION: Uses upserts so it never overwrites existing data
 * Run with: npm run prisma:seed
 */
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

// Load real course data from courses.json
const coursesJsonRaw = JSON.parse(
  fs.readFileSync(path.join(__dirname, '../../courses.json'), 'utf8')
);
const coursesData = coursesJsonRaw.courses || coursesJsonRaw;

async function main() {
  console.log('🌱 Starting SAFE database seed with REAL course data...\n');
  console.log('ℹ️  Using upserts — existing data will NOT be deleted.\n');

  // ============ CREATE FACULTY (upsert) ============
  console.log('📁 Creating faculty...');
  
  const scienceFaculty = await prisma.faculty.upsert({
    where: { code: 'SCI' },
    update: {},
    create: {
      code: 'SCI',
      name: 'Faculty of Science',
      nameAr: 'كلية العلوم',
      description: 'Faculty of Science at Egyptian University'
    }
  });

  console.log('✅ Faculty created/verified');

  // ============ CREATE DEPARTMENTS (upsert) ============
  console.log('🏢 Creating departments...');

  const deptData = [
    { code: 'MATH', name: 'Mathematics Department', nameAr: 'قسم الرياضيات' },
    { code: 'PHYS', name: 'Physics Department', nameAr: 'قسم الفيزياء' },
    { code: 'CHEM', name: 'Chemistry Department', nameAr: 'قسم الكيمياء' },
    { code: 'BIO', name: 'Biology Department', nameAr: 'قسم الأحياء' },
    { code: 'GEOL', name: 'Geology Department', nameAr: 'قسم الجيولوجيا' },
    { code: 'UNIV', name: 'University Requirements', nameAr: 'متطلبات الجامعة' }
  ];

  const departments = [];
  for (const d of deptData) {
    const dept = await prisma.department.upsert({
      where: { code: d.code },
      update: {},
      create: { ...d, facultyId: scienceFaculty.id }
    });
    departments.push(dept);
  }

  const deptMap = {};
  departments.forEach(d => deptMap[d.code] = d);

  console.log('✅ Departments created/verified');

  // ============ CREATE PROGRAMS (upsert) ============
  console.log('📚 Creating programs...');

  const progData = [
    { code: 'CS', name: 'Computer Science', nameAr: 'علوم الحاسب', creditHours: 136, deptCode: 'MATH' },
    { code: 'STAT', name: 'Statistics', nameAr: 'الإحصاء', creditHours: 132, deptCode: 'MATH' },
    { code: 'PMATH', name: 'Pure Mathematics', nameAr: 'الرياضيات البحتة', creditHours: 132, deptCode: 'MATH' },
    { code: 'PHYS', name: 'Physics', nameAr: 'الفيزياء', creditHours: 136, deptCode: 'PHYS' },
    { code: 'CHEM', name: 'Chemistry', nameAr: 'الكيمياء', creditHours: 132, deptCode: 'CHEM' },
    { code: 'BOTA', name: 'Botany', nameAr: 'النبات', creditHours: 128, deptCode: 'BIO' },
    { code: 'ZOOL', name: 'Zoology', nameAr: 'الحيوان', creditHours: 128, deptCode: 'BIO' },
    { code: 'MICR', name: 'Microbiology', nameAr: 'الميكروبيولوجي', creditHours: 128, deptCode: 'BIO' },
    { code: 'GEOL', name: 'Geology', nameAr: 'الجيولوجيا', creditHours: 132, deptCode: 'GEOL' }
  ];

  const programs = [];
  for (const p of progData) {
    const prog = await prisma.program.upsert({
      where: { code: p.code },
      update: {},
      create: {
        code: p.code,
        name: p.name,
        nameAr: p.nameAr,
        creditHours: p.creditHours,
        departmentId: deptMap[p.deptCode].id
      }
    });
    programs.push(prog);
  }

  const progMap = {};
  programs.forEach(p => progMap[p.code] = p);

  console.log('✅ Programs created/verified');

  // ============ CREATE USERS (upsert) ============
  console.log('👥 Creating users...');
  
  const hashedPassword = await bcrypt.hash('password123', 10);
  
  // Admin
  const admin = await prisma.user.upsert({
    where: { email: 'admin@college.edu' },
    update: {},
    create: {
      email: 'admin@college.edu',
      password: hashedPassword,
      name: 'System Admin',
      role: 'ADMIN',
      isVerified: true, isOnboardingComplete: true
    }
  });

  // Professors
  const profData = [
    { email: 'doctor@college.edu', name: 'Dr. Smith', deptCode: 'MATH' },
    { email: 'dr.ahmed@college.edu', name: 'د. أحمد حسن', deptCode: 'MATH' },
    { email: 'dr.mohamed@college.edu', name: 'د. محمد علي', deptCode: 'MATH' },
    { email: 'dr.fatma@college.edu', name: 'د. فاطمة سالم', deptCode: 'PHYS' },
    { email: 'dr.khaled@college.edu', name: 'د. خالد مصطفى', deptCode: 'CHEM' },
    { email: 'dr.rania@college.edu', name: 'د. رانيا حسن', deptCode: 'BIO' },
    { email: 'dr.sami@college.edu', name: 'د. سامي عثمان', deptCode: 'GEOL' }
  ];

  const professors = [];
  for (const p of profData) {
    const prof = await prisma.user.upsert({
      where: { email: p.email },
      update: {},
      create: {
        email: p.email,
        password: hashedPassword,
        name: p.name,
        role: 'PROFESSOR',
        departmentId: deptMap[p.deptCode].id,
        isVerified: true,
        isOnboardingComplete: true
      }
    });
    professors.push(prof);
  }

  const profMap = {};
  professors.forEach(p => profMap[p.email] = p);

  // Students
  const studentData = [
    { email: 'student@college.edu', name: 'أحمد محمد', studentId: '2024001', level: 2, progCode: 'CS' },
    { email: 'sara@college.edu', name: 'سارة أحمد', studentId: '2024002', level: 3, progCode: 'STAT' },
    { email: 'omar@college.edu', name: 'عمر حسن', studentId: '2024003', level: 1, progCode: 'PHYS' }
  ];

  const students = [];
  for (const s of studentData) {
    const student = await prisma.user.upsert({
      where: { email: s.email },
      update: {},
      create: {
        email: s.email,
        password: hashedPassword,
        name: s.name,
        role: 'STUDENT',
        studentId: s.studentId,
        level: s.level,
        programId: progMap[s.progCode].id,
        isVerified: true,
        isOnboardingComplete: true
      }
    });
    students.push(student);
  }

  const studentMap = {};
  students.forEach(s => studentMap[s.email] = s);

  console.log('✅ Users created/verified');

  // ============ CREATE COURSES FROM courses.json (upsert) ============
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

  // Create all courses via upsert with chunking and transactions
  const createdCourses = [];
  const CHUNK_SIZE = 10;
  
  for (let i = 0; i < coursesData.length; i += CHUNK_SIZE) {
    const chunk = coursesData.slice(i, i + CHUNK_SIZE);
    console.log(`Processing courses ${i + 1} to ${Math.min(i + CHUNK_SIZE, coursesData.length)} of ${coursesData.length}...`);
    
    // Process chunk sequentially but internally each item uses upsert
    // We use a simple loop since bulk upsert is not natively supported in prisma
    for (const c of chunk) {
      const courseCode = c.course_code.replace(/\s+/g, '').toUpperCase();
      try {
        const course = await prisma.course.upsert({
          where: { code: courseCode },
          update: {},
          create: {
            code: courseCode,
            name: c.course_title.split('(')[1]?.replace(')', '').trim() || c.course_title,
            nameAr: c.course_title.split('(')[0].trim(),
            description: `${c.course_title} - ${c.credit_hours} credit hours`,
            category: mapCategory(courseCode),
            creditHours: c.credit_hours,
            semester: 'FALL',
            academicYear: '2024-2025',
            isActive: true,
            departmentId: mapDepartment(c.department)
          }
        });
        createdCourses.push(course);
      } catch (e) {
        console.error(`Error saving course ${courseCode}:`, e.message);
      }
    }
  }

  console.log(`✅ Created/verified ${createdCourses.length} courses`);

  // ============ ASSIGN PROFESSORS TO COURSES ============
  console.log('👨‍🏫 Assigning professors to courses...');

  async function safeAssignInstructor(userId, courseId, isPrimary = true) {
    try {
      await prisma.courseInstructor.upsert({
        where: { userId_courseId: { userId, courseId } },
        update: {},
        create: { userId, courseId, isPrimary }
      });
    } catch (e) {
      // Already assigned, skip
    }
  }

  // Assign CS & COMP courses to Dr. Smith / Dr. Ahmed
  const csCourses = createdCourses.filter(c => c.code.startsWith('COMP') || c.code.startsWith('MATH'));
  for (let i = 0; i < Math.min(10, csCourses.length); i++) {
    await safeAssignInstructor(professors[i % 2 === 0 ? 0 : 1].id, csCourses[i].id);
  }

  // Assign STAT courses to Dr. Mohamed
  const statCourses = createdCourses.filter(c => c.code.startsWith('STAT'));
  for (const course of statCourses) {
    await safeAssignInstructor(professors[1].id, course.id);
  }

  // Assign PHYS courses to Dr. Fatma
  const physCourses = createdCourses.filter(c => c.code.startsWith('PHYS'));
  for (const course of physCourses) {
    await safeAssignInstructor(professors[2].id, course.id);
  }

  // Assign CHEM courses to Dr. Khaled
  const chemCourses = createdCourses.filter(c => c.code.startsWith('CHEM'));
  for (const course of chemCourses) {
    await safeAssignInstructor(professors[3].id, course.id);
  }

  // Assign BIO courses to Dr. Rania
  const bioCourses = createdCourses.filter(c => c.category === 'BIO');
  for (const course of bioCourses) {
    await safeAssignInstructor(professors[4].id, course.id);
  }

  // Assign GEOL courses to Dr. Sami
  const geolCourses = createdCourses.filter(c => c.code.startsWith('GEOL'));
  for (const course of geolCourses) {
    await safeAssignInstructor(professors[5].id, course.id);
  }

  console.log('✅ Professors assigned to courses');

  // ============ ENROLL STUDENTS (safe — skip if already enrolled) ============
  console.log('📝 Enrolling students in courses...');

  async function safeEnroll(userId, courseId) {
    try {
      await prisma.enrollment.upsert({
        where: { userId_courseId: { userId, courseId } },
        update: {},
        create: { userId, courseId, status: 'ENROLLED' }
      });
    } catch (e) {
      // Already enrolled, skip
    }
  }

  // Student 1: CS student
  const student1Courses = createdCourses.filter(c =>
    c.code.startsWith('COMP') || c.code === 'MATH101' || c.code === 'MATH102' || c.code === 'STAT101'
  ).slice(0, 6);

  for (const course of student1Courses) {
    await safeEnroll(students[0].id, course.id);
    // Also assign doctor@college.edu to these courses
    const doctorUser = professors.find(p => p.email === 'doctor@college.edu');
    if (doctorUser) {
      await safeAssignInstructor(doctorUser.id, course.id);
    }
  }

  // Student 2: Stats student
  const student2Courses = createdCourses.filter(c =>
    c.code.startsWith('STAT') || c.code === 'MATH101' || c.code === 'MATH203'
  ).slice(0, 5);

  for (const course of student2Courses) {
    await safeEnroll(students[1].id, course.id);
  }

  // Student 3: Physics student
  const student3Courses = createdCourses.filter(c =>
    c.code.startsWith('PHYS') || c.code === 'MATH101' || c.code === 'CHEM101'
  ).slice(0, 5);

  for (const course of student3Courses) {
    await safeEnroll(students[2].id, course.id);
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

  const enrolledCourseIds = [...student1Courses, ...student2Courses, ...student3Courses]
    .map(c => c.id)
    .filter((v, i, a) => a.indexOf(v) === i);

  // Check if schedules already exist
  const existingSchedules = await prisma.courseSchedule.count();
  if (existingSchedules === 0) {
    for (let i = 0; i < enrolledCourseIds.length; i++) {
      const course = createdCourses.find(c => c.id === enrolledCourseIds[i]);
      if (!course) continue;

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
  } else {
    console.log('⏭️  Course schedules already exist, skipping');
  }

  // ============ CREATE TASKS ============
  console.log('📋 Creating tasks...');

  const existingTasks = await prisma.task.count();
  if (existingTasks === 0) {
    const nextWeek = new Date();
    nextWeek.setDate(nextWeek.getDate() + 7);

    const twoWeeks = new Date();
    twoWeeks.setDate(twoWeeks.getDate() + 14);

    const threeWeeks = new Date();
    threeWeeks.setDate(threeWeeks.getDate() + 21);

    const comp102 = createdCourses.find(c => c.code === 'COMP102');
    const comp104 = createdCourses.find(c => c.code === 'COMP104');
    const math101 = createdCourses.find(c => c.code === 'MATH101');
    const stat101 = createdCourses.find(c => c.code === 'STAT101');

    if (comp102) {
      await prisma.task.create({
        data: {
          title: 'Python Programming Lab',
          description: 'Complete exercises 1-5 from Chapter 3',
          taskType: 'LAB', priority: 'MEDIUM',
          dueDate: nextWeek, maxPoints: 20,
          courseId: comp102.id, createdById: professors[0].id
        }
      });
    }

    if (comp104) {
      await prisma.task.create({
        data: {
          title: 'Midterm Exam - Programming 1',
          description: 'Covers: Variables, Loops, Functions, Arrays',
          taskType: 'EXAM', priority: 'HIGH',
          dueDate: twoWeeks, startDate: twoWeeks, maxPoints: 100,
          courseId: comp104.id, createdById: professors[0].id
        }
      });

      await prisma.task.create({
        data: {
          title: 'Assignment 1: Calculator Program',
          description: 'Build a simple calculator using Python',
          taskType: 'ASSIGNMENT', priority: 'MEDIUM',
          dueDate: nextWeek, maxPoints: 30,
          courseId: comp104.id, createdById: professors[0].id
        }
      });
    }

    if (math101) {
      await prisma.task.create({
        data: {
          title: 'Calculus Problem Set 1',
          description: 'Problems from Chapter 2: Derivatives',
          taskType: 'ASSIGNMENT', priority: 'MEDIUM',
          dueDate: nextWeek, maxPoints: 25,
          courseId: math101.id, createdById: professors[1].id
        }
      });

      await prisma.task.create({
        data: {
          title: 'Quiz 1: Limits',
          description: 'Short quiz on limits and continuity',
          taskType: 'QUIZ', priority: 'MEDIUM',
          dueDate: threeWeeks, maxPoints: 15,
          courseId: math101.id, createdById: professors[1].id
        }
      });
    }

    if (stat101) {
      await prisma.task.create({
        data: {
          title: 'Statistics Lab Report',
          description: 'Data analysis using SPSS or R',
          taskType: 'LAB', priority: 'MEDIUM',
          dueDate: twoWeeks, maxPoints: 40,
          courseId: stat101.id, createdById: professors[1].id
        }
      });
    }

    console.log('✅ Tasks created');
  } else {
    console.log('⏭️  Tasks already exist, skipping');
  }

  // ============ CREATE ANNOUNCEMENTS ============
  console.log('📢 Creating announcements...');

  const existingAnnouncements = await prisma.announcement.count();
  if (existingAnnouncements === 0) {
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
  } else {
    console.log('⏭️  Announcements already exist, skipping');
  }

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
