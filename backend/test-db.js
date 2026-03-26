const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const users = await prisma.user.findMany({
    include: {
      enrollments: true,
      umsCourses: true,
      umsGrades: true,
    }
  });

  for (const user of users) {
    console.log(`User: ${user.email} | StudentID: ${user.studentId} | Role: ${user.role} | Enrolled in App: ${user.enrollments.length} | UMS Courses: ${user.umsCourses.length} | UMS Grades: ${user.umsGrades.length}`);
    if (user.umsCourses.length > 0) {
      console.log('  UMS Courses:', user.umsCourses.map(c => c.courseCode).join(', '));
    }
  }
}

main()
  .catch(e => console.error(e))
  .finally(() => prisma.$disconnect());
