const express = require('express');
const router = express.Router();
const {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
} = require('../controllers/productController');
const { protect, adminOnly } = require('../middleware/authMiddleware');

// GET  /api/products        → listar (público)
// POST /api/products        → criar (admin)
router.route('/')
  .get(getProducts)
  .post(protect, adminOnly, createProduct);

// GET    /api/products/:id  → detalhe (público)
// PUT    /api/products/:id  → editar (admin)
// DELETE /api/products/:id  → excluir (admin)
router.route('/:id')
  .get(getProductById)
  .put(protect, adminOnly, updateProduct)
  .delete(protect, adminOnly, deleteProduct);

module.exports = router;
