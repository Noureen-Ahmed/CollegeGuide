const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
async function run() {
  const users = await prisma.user.findMany();
  console.log("Users in DB:");
  users.forEach(u => console.log(`${u.id} - ${u.email} - ${u.name} - ${u.role}`));
}
run().finally(() => prisma.$disconnect());
