const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
  const codes = ['COMP402', 'COMP404', 'COMP406', 'COMP408', 'COMP416', 'COMP 402', 'COMP 404', 'COMP 406', 'COMP 408', 'COMP 416'];
  const courses = await prisma.course.findMany({
    where: {
      code: { in: codes }
    }
  });
  console.log("Found Courses:", courses.map(c => c.code));
}
check().catch(console.error).finally(() => prisma.$disconnect());
