// Script para popular o banco com dados iniciais
// Rode com: node seeder.js

require('dotenv').config();
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const connectDB = require('./config/db');
const User = require('./models/User');
const Product = require('./models/Product');

const seedData = async () => {
  await connectDB();

  // Limpa o banco
  await User.deleteMany();
  await Product.deleteMany();
  console.log('🗑️  Banco limpo.');

  // Cria usuário admin
  const admin = await User.create({
    name: 'Admin',
    email: 'admin@mernshop.com',
    password: 'admin123',
    role: 'admin',
    bio: 'Administrador da plataforma.',
  });
  console.log('👤 Admin criado:', admin.email);

  // Cria usuário cliente de exemplo
  await User.create({
    name: 'João Silva',
    email: 'joao@email.com',
    password: '123456',
    role: 'customer',
  });
  console.log('👤 Cliente criado: joao@email.com');

  // Cria produtos iniciais
  const products = [
    {
      name: 'All Set Tote Bag',
      price: 70.99,
      image: 'https://picsum.photos/seed/bag1lux/500/600',
      description: 'Uma bolsa tote espaçosa em couro premium italiano.',
      category: 'Bolsas', stock: 5, isNew: true, createdBy: admin._id,
    },
    {
      name: 'Blurrygram Shawl',
      price: 85.99, originalPrice: 110.00,
      image: 'https://picsum.photos/seed/shawl2lux/500/600',
      description: 'Xale de seda com padrão degradê exclusivo.',
      category: 'Acessórios', stock: 12, createdBy: admin._id,
    },
    {
      name: 'Metallic Buckle Trousers',
      price: 90.99,
      image: 'https://picsum.photos/seed/pants3lux/500/600',
      description: 'Calça slim fit com fivela metálica icônica.',
      category: 'Roupas', stock: 8, isNew: true, createdBy: admin._id,
    },
    {
      name: 'Minister Chelsea Boots',
      price: 100.99,
      image: 'https://picsum.photos/seed/boots4lux/500/600',
      description: 'Bota Chelsea em couro curtido artesanalmente.',
      category: 'Calçados', stock: 4, createdBy: admin._id,
    },
    {
      name: 'Silk Evening Blouse',
      price: 120.00, originalPrice: 155.00,
      image: 'https://picsum.photos/seed/blouse5lux/500/600',
      description: 'Blusa de seda fluida para ocasiões especiais.',
      category: 'Roupas', stock: 7, createdBy: admin._id,
    },
    {
      name: 'Leather Crossbody Bag',
      price: 95.50,
      image: 'https://picsum.photos/seed/bag6lux/500/600',
      description: 'Bolsa crossbody em couro genuíno com múltiplos compartimentos.',
      category: 'Bolsas', stock: 9, createdBy: admin._id,
    },
    {
      name: 'Gold Cuff Bracelet',
      price: 189.00,
      image: 'https://picsum.photos/seed/bracelet9lux/500/600',
      description: 'Pulseira cuff banhada a ouro 18k.',
      category: 'Joias', stock: 6, isNew: true, createdBy: admin._id,
    },
    {
      name: 'Structured Wool Coat',
      price: 245.00, originalPrice: 320.00,
      image: 'https://picsum.photos/seed/coat10lux/500/600',
      description: 'Casaco estruturado em lã virgem com corte alfaiataria.',
      category: 'Roupas', stock: 2, createdBy: admin._id,
    },
  ];

  await Product.insertMany(products);
  console.log(`📦 ${products.length} produtos criados.`);
  console.log('✅ Seed concluído!');
  process.exit(0);
};

seedData().catch((err) => {
  console.error('❌ Erro no seed:', err);
  process.exit(1);
});
