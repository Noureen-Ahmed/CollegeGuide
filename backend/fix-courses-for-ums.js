const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const UMS_COURSES = [
  { courseCode: 'COMP402', courseName: 'Bioinformatics', creditHours: 3 },
  { courseCode: 'COMP404', courseName: 'Software Engineering', creditHours: 3 },
  { courseCode: 'COMP406', courseName: 'Computer Project B', creditHours: 3 },
  { courseCode: 'COMP408', courseName: 'Advanced Topics in AI', creditHours: 3 },
  { courseCode: 'COMP416', courseName: 'Data and Web Mining', creditHours: 3 },
];

async function main() {
  console.log('--- Starting Data Fix ---');

  // 1. Delete fake student accounts
  const fakeEmails = ['student@college.edu', 'sara@college.edu', 'omar@college.edu'];
  const deleted = await prisma.user.deleteMany({
    where: { email: { in: fakeEmails } }
  });
  console.log(`Deleted ${deleted.count} fake student accounts.`);

  // 2. Find real UMS student
  const student = await prisma.user.findFirst({
    where: {
      OR: [
        { email: '30410030100903@sci.asu.edu.eg' },
        { studentId: '30410030100903' }
      ]
    }
  });

  if (!student) {
    console.log('Error: UMS student 30410030100903 not found! Please log in with UMS first.');
  } else {
    console.log(`Found real user: ${student.email}`);
  }

  // 3. Find doctor
  let doctor = await prisma.user.findUnique({
    where: { email: 'doctor@college.edu' }
  });

  if (!doctor) {
    console.log('Error: doctor@college.edu not found!');
  } else {
    console.log('Found doctor: doctor@college.edu');
  }

  // Find Computer Science Department
  const dept = await prisma.department.findFirst({ where: { code: 'MATH' } });
  
  // 4. Create/Upsert Courses and enrollments
  for (const c of UMS_COURSES) {
    const course = await prisma.course.upsert({
      where: { code: c.courseCode },
      update: {
        name: c.courseName,
        creditHours: c.creditHours
      },
      create: {
        code: c.courseCode,
        name: c.courseName,
        category: 'COMP',
        creditHours: c.creditHours,
        semester: 'Spring',
        academicYear: '2025-2026',
        isActive: true,
        departmentId: dept?.id,
      }
    });

    console.log(`Ensured Course exists: ${course.code} - ${course.name}`);

    // Enroll student
    if (student) {
      await prisma.enrollment.upsert({
        where: {
          userId_courseId: {
            userId: student.id,
            courseId: course.id
          }
        },
        update: { status: 'ENROLLED' },
        create: {
          userId: student.id,
          courseId: course.id,
          status: 'ENROLLED'
        }
      });
      console.log(` - Enrolled ${student.studentId} in ${course.code}`);
    }

    // Assign doctor
    if (doctor) {
      await prisma.courseInstructor.upsert({
        where: {
          userId_courseId: {
            userId: doctor.id,
            courseId: course.id
          }
        },
        update: { isPrimary: true },
        create: {
          userId: doctor.id,
          courseId: course.id,
          isPrimary: true
        }
      });
      console.log(` - Assigned doctor to ${course.code}`);
    }
  }

  console.log('--- Data Fix Complete ---');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
