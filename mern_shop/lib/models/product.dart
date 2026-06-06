class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  final String category;
  final double rating;
  final int numReviews;
  final int stock;
  final bool isNew;
  final double? originalPrice;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
    required this.numReviews,
    this.stock = 10,
    this.isNew = false,
    this.originalPrice,
  });

  bool get isOnSale => originalPrice != null && originalPrice! > price;
  int get discountPercent => isOnSale
      ? (((originalPrice! - price) / originalPrice!) * 100).round()
      : 0;

  Product copyWith({
    String? name,
    double? price,
    String? image,
    String? description,
    String? category,
    int? stock,
  }) =>
      Product(
        id: id,
        name: name ?? this.name,
        price: price ?? this.price,
        image: image ?? this.image,
        description: description ?? this.description,
        category: category ?? this.category,
        rating: rating,
        numReviews: numReviews,
        stock: stock ?? this.stock,
        isNew: isNew,
        originalPrice: originalPrice,
      );
}

final List<String> productCategories = [
  'Todos',
  'Bolsas',
  'Roupas',
  'Calçados',
  'Acessórios',
  'Joias',
];

List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'All Set Tote Bag',
    price: 70.99,
    image: 'https://picsum.photos/seed/bag1lux/500/600',
    description:
        'Uma bolsa tote espaçosa e elegante em couro premium italiano. '
        'Design atemporal com ferragens douradas e costura artesanal.',
    category: 'Bolsas',
    rating: 4.5,
    numReviews: 12,
    stock: 5,
    isNew: true,
  ),
  Product(
    id: '2',
    name: 'Blurrygram Shawl',
    price: 85.99,
    originalPrice: 110.00,
    image: 'https://picsum.photos/seed/shawl2lux/500/600',
    description:
        'Xale de seda com padrão degradê exclusivo. Fabricado com '
        '100% seda natural, leve e sofisticado para qualquer ocasião.',
    category: 'Acessórios',
    rating: 4.2,
    numReviews: 8,
    stock: 12,
  ),
  Product(
    id: '3',
    name: 'Metallic Buckle Trousers',
    price: 90.99,
    image: 'https://picsum.photos/seed/pants3lux/500/600',
    description:
        'Calça slim fit com fivela metálica icônica. Tecido de alta '
        'performance que mantém o caimento impecável o dia todo.',
    category: 'Roupas',
    rating: 4.7,
    numReviews: 25,
    stock: 8,
    isNew: true,
  ),
  Product(
    id: '4',
    name: 'Minister Chelsea Boots',
    price: 100.99,
    image: 'https://picsum.photos/seed/boots4lux/500/600',
    description:
        'Bota Chelsea em couro curtido artesanalmente. Solado de borracha '
        'resistente com elástico lateral de alta qualidade.',
    category: 'Calçados',
    rating: 4.8,
    numReviews: 31,
    stock: 4,
  ),
  Product(
    id: '5',
    name: 'Silk Evening Blouse',
    price: 120.00,
    originalPrice: 155.00,
    image: 'https://picsum.photos/seed/blouse5lux/500/600',
    description:
        'Blusa de seda fluida para ocasiões especiais. Decote em V '
        'elegante com acabamento em renda delicada nas mangas.',
    category: 'Roupas',
    rating: 4.4,
    numReviews: 18,
    stock: 7,
  ),
  Product(
    id: '6',
    name: 'Leather Crossbody Bag',
    price: 95.50,
    image: 'https://picsum.photos/seed/bag6lux/500/600',
    description:
        'Bolsa crossbody em couro genuíno com múltiplos compartimentos. '
        'Alça ajustável e fecho magnético de segurança.',
    category: 'Bolsas',
    rating: 4.6,
    numReviews: 22,
    stock: 9,
  ),
  Product(
    id: '7',
    name: 'Cashmere Blend Scarf',
    price: 65.00,
    image: 'https://picsum.photos/seed/scarf7lux/500/600',
    description:
        'Cachecol em mistura de cashmere e lã merino. Extremamente '
        'macio, quente e com textura luxuosa inconfundível.',
    category: 'Acessórios',
    rating: 4.3,
    numReviews: 14,
    stock: 20,
  ),
  Product(
    id: '8',
    name: 'Oxford Brogue Shoes',
    price: 135.99,
    image: 'https://picsum.photos/seed/shoes8lux/500/600',
    description:
        'Oxford com brogue artesanal em couro de bezerro italiano. '
        'Solado de couro duplo para máxima durabilidade e elegância.',
    category: 'Calçados',
    rating: 4.9,
    numReviews: 40,
    stock: 3,
  ),
  Product(
    id: '9',
    name: 'Gold Cuff Bracelet',
    price: 189.00,
    image: 'https://picsum.photos/seed/bracelet9lux/500/600',
    description:
        'Pulseira cuff banhada a ouro 18k com acabamento polido. '
        'Design minimalista e atemporal para uso diário ou especial.',
    category: 'Joias',
    rating: 4.7,
    numReviews: 35,
    stock: 6,
    isNew: true,
  ),
  Product(
    id: '10',
    name: 'Structured Wool Coat',
    price: 245.00,
    originalPrice: 320.00,
    image: 'https://picsum.photos/seed/coat10lux/500/600',
    description:
        'Casaco estruturado em lã virgem com corte alfaiataria. '
        'Forro em seda e botões de chifre natural. Peça atemporal.',
    category: 'Roupas',
    rating: 4.9,
    numReviews: 52,
    stock: 2,
  ),
];
