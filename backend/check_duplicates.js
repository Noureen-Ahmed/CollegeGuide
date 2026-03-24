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
      }
    }
  });

  if (!user) {
    console.log("UMS USER NOT FOUND!");
    return;
  }

  console.log(`User: ${user.email} (ID: ${user.id})`);
  console.log(`Enrollments: ${user.enrollments.length}`);
  user.enrollments.forEach(e => {
    console.log(` - Enrollment ID: ${e.id} | ${e.course.code}: ${e.course.name}`);
  });
}

check().catch(console.error).finally(() => prisma.$disconnect());
