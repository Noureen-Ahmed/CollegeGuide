const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function mapCourses() {
  const user = await prisma.user.findFirst({
    where: {
      OR: [
        { email: '30410030100903@sci.asu.edu.eg' },
        { studentId: '30410030100903' }
      ]
    },
    include: { umsCourses: true }
  });

  if (!user) {
    console.log("UMS USER NOT FOUND!");
    return;
  }

  let enrolled = 0;
  for (const umsCourse of user.umsCourses) {
    if (umsCourse.courseCode) {
      // Remove spaces since App Courses might be saved like 'COMP402'
      const normalizedCode = umsCourse.courseCode.replace(/\s+/g, '');
      
      console.log(`Looking for App Course: ${normalizedCode}`);
      
      const appCourse = await prisma.course.findUnique({
        where: { code: normalizedCode }
      });
      
      if (appCourse) {
        await prisma.enrollment.upsert({
          where: {
            userId_courseId: {
              userId: user.id,
              courseId: appCourse.id
            }
          },
          update: { status: 'ENROLLED' },
          create: {
            userId: user.id,
            courseId: appCourse.id,
            status: 'ENROLLED'
          }
        });
        console.log(`✅ Enrolled in ${appCourse.code}`);
        enrolled++;
      } else {
        console.log(`❌ App Course ${normalizedCode} not found.`);
      }
    }
  }
  console.log(`Total App Courses enrolled: ${enrolled}`);
}

mapCourses().catch(console.error).finally(() => prisma.$disconnect());
