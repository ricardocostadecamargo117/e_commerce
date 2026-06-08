const asyncHandler = require('express-async-handler');
const User = require('../models/User');

// ─── GET /api/users/profile ───────────────────────────────────────────────────
const getProfile = asyncHandler(async (req, res) => {
  const user = await User.findById(req.user._id).select('-password');
  if (!user) {
    res.status(404);
    throw new Error('Usuário não encontrado.');
  }
  res.json(user);
});

// ─── PUT /api/users/profile ───────────────────────────────────────────────────
const updateProfile = asyncHandler(async (req, res) => {
  const user = await User.findById(req.user._id);
  if (!user) {
    res.status(404);
    throw new Error('Usuário não encontrado.');
  }

  user.name      = req.body.name      ?? user.name;
  user.phone     = req.body.phone     ?? user.phone;
  user.bio       = req.body.bio       ?? user.bio;
  user.avatarUrl = req.body.avatarUrl ?? user.avatarUrl;

  // Atualiza senha apenas se enviada
  if (req.body.password) {
    user.password = req.body.password;
  }

  const updated = await user.save();

  res.json({
    _id:       updated._id,
    name:      updated.name,
    email:     updated.email,
    role:      updated.role,
    phone:     updated.phone,
    bio:       updated.bio,
    avatarUrl: updated.avatarUrl,
  });
});

// ─── GET /api/users (admin only) ──────────────────────────────────────────────
const getAllUsers = asyncHandler(async (req, res) => {
  const users = await User.find().select('-password').sort({ createdAt: -1 });
  res.json(users);
});

module.exports = { getProfile, updateProfile, getAllUsers };
