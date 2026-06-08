const express = require('express');
const router = express.Router();
const {
  createOrder,
  getMyOrders,
  getOrderById,
  getAllOrders,
  updateOrderStatus,
} = require('../controllers/orderController');
const { protect, adminOnly } = require('../middleware/authMiddleware');

// POST /api/orders      → criar pedido (logado)
// GET  /api/orders      → todos os pedidos (admin)
router.route('/')
  .post(protect, createOrder)
  .get(protect, adminOnly, getAllOrders);

// GET /api/orders/my    → pedidos do usuário logado
router.get('/my', protect, getMyOrders);

// GET /api/orders/:id           → detalhe do pedido
// PUT /api/orders/:id/status    → atualizar status (admin)
router.get('/:id', protect, getOrderById);
router.put('/:id/status', protect, adminOnly, updateOrderStatus);

module.exports = router;
