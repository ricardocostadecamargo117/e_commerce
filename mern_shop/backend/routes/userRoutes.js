const express = require('express');
const router = express.Router();
const { getProfile, updateProfile, getAllUsers } = require('../controllers/userController');
const { protect, adminOnly } = require('../middleware/authMiddleware');

// GET  /api/users/profile  → perfil do usuário logado
// PUT  /api/users/profile  → atualizar perfil
router.route('/profile')
  .get(protect, getProfile)
  .put(protect, updateProfile);

// GET /api/users → listar todos (admin)
router.get('/', protect, adminOnly, getAllUsers);

module.exports = router;
