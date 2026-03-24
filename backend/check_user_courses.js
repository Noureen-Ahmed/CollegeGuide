const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
  const user = await prisma.user.findFirst({
    where: {
      OR: [
        { email: '30410030100903@sci.asu.edu.eg' },
        { studentId: '30410030100903' }
      ]
    },
    include: {
      enrollments: {
        include: { course: true }
      },
      umsCourses: true
    }
  });

  if (!user) {
    console.log("UMS USER NOT FOUND!");
    return;
  }

  console.log(`User: ${user.email} (ID: ${user.id})`);
  console.log(`Enrollments: ${user.enrollments.length}`);
  user.enrollments.forEach(e => {
    console.log(` - ${e.course.code}: ${e.course.name}`);
  });

  console.log(`UMS Courses: ${user.umsCourses.length}`);
  user.umsCourses.forEach(c => {
    console.log(` - ${c.courseCode}: ${c.courseName}`);
  });
}

check().catch(console.error).finally(() => prisma.$disconnect());
