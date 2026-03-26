const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const users = await prisma.user.findMany({
    include: {
      _count: { select: { umsCourses: true, enrollments: true } }
    }
  });

  users.forEach(u => {
    console.log(`User: ${u.email} | umsCourses: ${u._count.umsCourses} | enrollments: ${u._count.enrollments}`);
  });
}

main().finally(() => prisma.$disconnect());
