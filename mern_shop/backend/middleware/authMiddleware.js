const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Verifica se o token JWT é válido
const protect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer ')
  ) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      req.user = await User.findById(decoded.id).select('-password');
      next();
    } catch (error) {
      res.status(401).json({ message: 'Token inválido ou expirado.' });
    }
  } else {
    res.status(401).json({ message: 'Não autorizado. Token não encontrado.' });
  }
};

// Verifica se o usuário é admin
const adminOnly = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    res.status(403).json({ message: 'Acesso negado. Apenas administradores.' });
  }
};

module.exports = { protect, adminOnly };
