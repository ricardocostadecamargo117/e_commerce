const mongoose = require('mongoose');

const orderItemSchema = new mongoose.Schema({
  product: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true,
  },
  name: { type: String, required: true },
  image: { type: String, required: true },
  price: { type: Number, required: true },
  quantity: { type: Number, required: true, min: 1 },
});

const shippingAddressSchema = new mongoose.Schema({
  fullName:     { type: String, required: true },
  street:       { type: String, required: true },
  number:       { type: String, required: true },
  complement:   { type: String, default: '' },
  neighborhood: { type: String, required: true },
  city:         { type: String, required: true },
  state:        { type: String, required: true },
  zipCode:      { type: String, required: true },
});

const orderSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    items: [orderItemSchema],
    shippingAddress: shippingAddressSchema,
    paymentMethod: {
      type: String,
      enum: ['creditCard', 'debitCard', 'pix', 'boleto'],
      required: true,
    },
    subtotal:     { type: Number, required: true },
    shippingCost: { type: Number, required: true },
    tax:          { type: Number, required: true },
    total:        { type: Number, required: true },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'],
      default: 'pending',
    },
    estimatedDelivery: {
      type: Date,
      default: () => new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // +7 dias
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Order', orderSchema);
