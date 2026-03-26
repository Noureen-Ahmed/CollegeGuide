const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('Cleaning UMS database tables for ALL users...');

  try {
    const results = await prisma.$transaction([
      prisma.umsCourse.deleteMany({}),
      prisma.umsGrade.deleteMany({}),
      prisma.umsSession.deleteMany({})
    ]);

    console.log('Successfully deleted:');
    console.log(`- ${results[0].count} Courses`);
    console.log(`- ${results[1].count} Grades`);
    console.log(`- ${results[2].count} Sessions`);

    // ALSO: Remove "mocked" stub courses that don't match any real code
    const mockedCourses = await prisma.course.deleteMany({
      where: {
        OR: [
          { code: { startsWith: 'UMS' } },
          { name: 'Unknown Course' }
        ]
      }
    });
    console.log(`- ${mockedCourses.count} Mocked Stubs removed.`);

  } catch (error) {
    console.error('Error cleaning UMS data:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
