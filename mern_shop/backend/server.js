require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

// Rotas
const authRoutes    = require('./routes/authRoutes');
const userRoutes    = require('./routes/userRoutes');
const productRoutes = require('./routes/productRoutes');
const orderRoutes   = require('./routes/orderRoutes');

// Conecta ao MongoDB
connectDB();

const app = express();

// ─── Middlewares globais ──────────────────────────────────────────────────────
app.use(cors());                        // Permite requisições do Flutter
app.use(express.json());                // Lê JSON no body das requisições
app.use(express.urlencoded({ extended: true }));

// ─── Rotas da API ─────────────────────────────────────────────────────────────
app.use('/api/auth',     authRoutes);
app.use('/api/users',    userRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders',   orderRoutes);

// ─── Rota raiz (teste rápido) ─────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({ message: '🛍️ MERN Shop API está rodando!' });
});

// ─── Middleware de erros globais ──────────────────────────────────────────────
app.use((err, req, res, next) => {
  const statusCode = res.statusCode === 200 ? 500 : res.statusCode;
  res.status(statusCode).json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? null : err.stack,
  });
});

// ─── Inicia o servidor ────────────────────────────────────────────────────────
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
  console.log(`📡 API disponível em http://localhost:${PORT}`);
});
