const mongoose = require('mongoose');

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Nome do produto é obrigatório'],
      trim: true,
    },
    description: {
      type: String,
      required: [true, 'Descrição é obrigatória'],
    },
    price: {
      type: Number,
      required: [true, 'Preço é obrigatório'],
      min: 0,
    },
    originalPrice: {
      type: Number,
      default: null,
    },
    image: {
      type: String,
      required: [true, 'Imagem é obrigatória'],
    },
    category: {
      type: String,
      required: [true, 'Categoria é obrigatória'],
      enum: ['Bolsas', 'Roupas', 'Calçados', 'Acessórios', 'Joias'],
    },
    stock: {
      type: Number,
      required: true,
      min: 0,
      default: 0,
    },
    isNew: {
      type: Boolean,
      default: false,
    },
    rating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
    },
    numReviews: {
      type: Number,
      default: 0,
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Product', productSchema);
