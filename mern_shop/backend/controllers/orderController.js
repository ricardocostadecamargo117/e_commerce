const asyncHandler = require('express-async-handler');
const Order = require('../models/Order');
const Product = require('../models/Product');

// ─── POST /api/orders ─────────────────────────────────────────────────────────
const createOrder = asyncHandler(async (req, res) => {
  const {
    items, shippingAddress, paymentMethod,
    subtotal, shippingCost, tax,
  } = req.body;

  if (!items || items.length === 0) {
    res.status(400);
    throw new Error('Nenhum item no pedido.');
  }

  // Verifica estoque e monta os itens
  const orderItems = [];
  for (const item of items) {
    const product = await Product.findById(item.productId);
    if (!product) {
      res.status(404);
      throw new Error(`Produto ${item.productId} não encontrado.`);
    }
    if (product.stock < item.quantity) {
      res.status(400);
      throw new Error(`Estoque insuficiente para "${product.name}".`);
    }
    // Desconta do estoque
    product.stock -= item.quantity;
    await product.save();

    orderItems.push({
      product: product._id,
      name:     product.name,
      image:    product.image,
      price:    product.price,
      quantity: item.quantity,
    });
  }

  const total = subtotal + shippingCost + tax;

  const order = await Order.create({
    user: req.user._id,
    items: orderItems,
    shippingAddress,
    paymentMethod,
    subtotal,
    shippingCost,
    tax,
    total,
    status: paymentMethod === 'boleto' ? 'pending' : 'confirmed',
  });

  res.status(201).json(order);
});

// ─── GET /api/orders/my ───────────────────────────────────────────────────────
const getMyOrders = asyncHandler(async (req, res) => {
  const orders = await Order.find({ user: req.user._id })
    .sort({ createdAt: -1 });
  res.json(orders);
});

// ─── GET /api/orders/:id ──────────────────────────────────────────────────────
const getOrderById = asyncHandler(async (req, res) => {
  const order = await Order.findById(req.params.id).populate(
    'user', 'name email'
  );
  if (!order) {
    res.status(404);
    throw new Error('Pedido não encontrado.');
  }
  // Usuário só pode ver o próprio pedido (admin vê todos)
  if (
    order.user._id.toString() !== req.user._id.toString() &&
    req.user.role !== 'admin'
  ) {
    res.status(403);
    throw new Error('Acesso negado.');
  }
  res.json(order);
});

// ─── GET /api/orders (admin) ──────────────────────────────────────────────────
const getAllOrders = asyncHandler(async (req, res) => {
  const orders = await Order.find()
    .populate('user', 'name email')
    .sort({ createdAt: -1 });
  res.json(orders);
});

// ─── PUT /api/orders/:id/status (admin) ──────────────────────────────────────
const updateOrderStatus = asyncHandler(async (req, res) => {
  const { status } = req.body;
  const order = await Order.findById(req.params.id);
  if (!order) {
    res.status(404);
    throw new Error('Pedido não encontrado.');
  }
  order.status = status;
  const updated = await order.save();
  res.json(updated);
});

module.exports = {
  createOrder,
  getMyOrders,
  getOrderById,
  getAllOrders,
  updateOrderStatus,
};
