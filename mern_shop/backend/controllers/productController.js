const asyncHandler = require('express-async-handler');
const Product = require('../models/Product');

// ─── GET /api/products ────────────────────────────────────────────────────────
const getProducts = asyncHandler(async (req, res) => {
  const { category, search } = req.query;

  const filter = {};
  if (category && category !== 'Todos') filter.category = category;
  if (search) filter.name = { $regex: search, $options: 'i' };

  const products = await Product.find(filter).sort({ createdAt: -1 });
  res.json(products);
});

// ─── GET /api/products/:id ────────────────────────────────────────────────────
const getProductById = asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) {
    res.status(404);
    throw new Error('Produto não encontrado.');
  }
  res.json(product);
});

// ─── POST /api/products (admin) ───────────────────────────────────────────────
const createProduct = asyncHandler(async (req, res) => {
  const {
    name, description, price, originalPrice,
    image, category, stock, isNew,
  } = req.body;

  const product = await Product.create({
    name,
    description,
    price,
    originalPrice: originalPrice || null,
    image,
    category,
    stock,
    isNew: isNew ?? true,
    createdBy: req.user._id,
  });

  res.status(201).json(product);
});

// ─── PUT /api/products/:id (admin) ───────────────────────────────────────────
const updateProduct = asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) {
    res.status(404);
    throw new Error('Produto não encontrado.');
  }

  const {
    name, description, price, originalPrice,
    image, category, stock, isNew,
  } = req.body;

  product.name          = name          ?? product.name;
  product.description   = description   ?? product.description;
  product.price         = price         ?? product.price;
  product.originalPrice = originalPrice ?? product.originalPrice;
  product.image         = image         ?? product.image;
  product.category      = category      ?? product.category;
  product.stock         = stock         ?? product.stock;
  product.isNew         = isNew         ?? product.isNew;

  const updated = await product.save();
  res.json(updated);
});

// ─── DELETE /api/products/:id (admin) ────────────────────────────────────────
const deleteProduct = asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) {
    res.status(404);
    throw new Error('Produto não encontrado.');
  }
  await product.deleteOne();
  res.json({ message: 'Produto removido com sucesso.' });
});

module.exports = {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
};
