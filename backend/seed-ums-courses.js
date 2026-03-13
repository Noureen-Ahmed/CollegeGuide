/**
 * Seed UMS courses into the database from the browser-scraped data
 * Run: node seed-ums-courses.js
 */
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const UMS_COURSES = [
  { courseCode: 'COMP 402', courseName: 'Bioinformatics', creditHours: 3 },
  { courseCode: 'COMP 404', courseName: 'Software Engineering', creditHours: 3 },
  { courseCode: 'COMP 406', courseName: 'Computer Project B', creditHours: 3 },
  { courseCode: 'COMP 408', courseName: 'Advanced Topics in AI', creditHours: 3 },
  { courseCode: 'COMP 416', courseName: 'Data and Web Mining', creditHours: 3 },
];

async function main() {
  // Find the user
  const user = await prisma.user.findFirst({
    where: {
      OR: [
        { email: '30410030100903@sci.asu.edu.eg' },
        { studentId: '30410030100903' }
      ]
    }
  });

  if (!user) {
    console.error('❌ User not found! Make sure you have logged in at least once.');
    return;
  }

  console.log(`Found user: ${user.name} (${user.email}), id=${user.id}`);

  // Also update user profile data from the UMS scrape
  await prisma.user.update({
    where: { id: user.id },
    data: {
      name: 'Noureen Ahmed Ali',
      nameAr: 'نورين احمد على محمد',
      phone: '01013229538',
      email: '30410030100903@sci.asu.edu.eg',
      studentId: '30410030100903',
      level: 4,
      isVerified: true,
      isOnboardingComplete: true
    }
  });
  console.log('✅ Updated user profile with UMS data');

  // Insert/update courses
  for (const course of UMS_COURSES) {
    await prisma.umsCourse.upsert({
      where: {
        userId_courseCode_semester_academicYear: {
          userId: user.id,
          courseCode: course.courseCode,
          semester: 'Spring',
          academicYear: '2025-2026'
        }
      },
      update: {
        courseName: course.courseName,
        creditHours: course.creditHours,
        syncedAt: new Date()
      },
      create: {
        userId: user.id,
        courseCode: course.courseCode,
        courseName: course.courseName,
        creditHours: course.creditHours,
        semester: 'Spring',
        academicYear: '2025-2026',
        syncedAt: new Date()
      }
    });
    console.log(`  ✅ ${course.courseCode}: ${course.courseName}`);
  }

  console.log(`\n✅ Seeded ${UMS_COURSES.length} courses for user ${user.email}`);

  // Verify
  const count = await prisma.umsCourse.count({ where: { userId: user.id } });
  console.log(`Total UMS courses in DB: ${count}`);
}

main()
  .catch(err => console.error('Error:', err))
  .finally(() => prisma.$disconnect());
