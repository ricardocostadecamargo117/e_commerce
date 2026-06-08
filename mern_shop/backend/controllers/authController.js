const asyncHandler = require('express-async-handler');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Gera um token JWT para o usuário
const generateToken = (id) =>
  jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '30d' });

// ─── POST /api/auth/register ──────────────────────────────────────────────────
const register = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    res.status(400);
    throw new Error('Preencha todos os campos.');
  }

  const userExists = await User.findOne({ email });
  if (userExists) {
    res.status(400);
    throw new Error('Este e-mail já está em uso.');
  }

  const user = await User.create({ name, email, password });

  res.status(201).json({
    _id:      user._id,
    name:     user.name,
    email:    user.email,
    role:     user.role,
    phone:    user.phone,
    bio:      user.bio,
    avatarUrl: user.avatarUrl,
    token:    generateToken(user._id),
  });
});

// ─── POST /api/auth/login ─────────────────────────────────────────────────────
const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });

  if (user && (await user.matchPassword(password))) {
    res.json({
      _id:      user._id,
      name:     user.name,
      email:    user.email,
      role:     user.role,
      phone:    user.phone,
      bio:      user.bio,
      avatarUrl: user.avatarUrl,
      token:    generateToken(user._id),
    });
  } else {
    res.status(401);
    throw new Error('E-mail ou senha incorretos.');
  }
});

module.exports = { register, login };
