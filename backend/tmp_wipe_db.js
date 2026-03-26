const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('🧹 Wiping ALL user-related database tables...');
  
  try {
    // Delete in sequence to avoid FK violations
    await prisma.$transaction([
      prisma.taskSubmission?.deleteMany({}),
      prisma.notification?.deleteMany({}),
      prisma.task?.deleteMany({}),
      prisma.announcement?.deleteMany({}),
      prisma.verificationCode?.deleteMany({}),
      prisma.umsCourse?.deleteMany({}),
      prisma.umsGrade?.deleteMany({}),
      prisma.umsSession?.deleteMany({}),
      prisma.enrollment?.deleteMany({}),
      prisma.courseInstructor?.deleteMany({}),
      prisma.attendance?.deleteMany({}),
    ].filter(x => x));

    // Finally delete users
    const users = await prisma.user.deleteMany({});
    console.log(`✅ Successfully wiped ${users.count} users and all their data.`);

  } catch (error) {
    console.error('❌ Error wiping DB:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
