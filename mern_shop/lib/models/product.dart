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

  bool get isOnSale =>
      originalPrice != null && originalPrice! > price;

  int get discountPercent => isOnSale
      ? (((originalPrice! - price) / originalPrice!) * 100).round()
      : 0;

  // ── Converte JSON da API para Product ──────────────────────────────────────
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:            json['_id'] ?? json['id'] ?? '',
      name:          json['name'] ?? '',
      price:         (json['price'] ?? 0).toDouble(),
      image:         json['image'] ?? '',
      description:   json['description'] ?? '',
      category:      json['category'] ?? '',
      rating:        (json['rating'] ?? 0).toDouble(),
      numReviews:    (json['numReviews'] ?? 0).toInt(),
      stock:         (json['stock'] ?? 0).toInt(),
      isNew:         json['isNew'] ?? false,
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice']).toDouble()
          : null,
    );
  }

  // ── Converte Product para JSON (para enviar à API) ─────────────────────────
  Map<String, dynamic> toJson() => {
        'name':          name,
        'price':         price,
        'image':         image,
        'description':   description,
        'category':      category,
        'stock':         stock,
        'isNew':         isNew,
        'originalPrice': originalPrice,
      };

  Product copyWith({
    String? name,
    double? price,
    String? image,
    String? description,
    String? category,
    int? stock,
  }) =>
      Product(
        id:            id,
        name:          name ?? this.name,
        price:         price ?? this.price,
        image:         image ?? this.image,
        description:   description ?? this.description,
        category:      category ?? this.category,
        rating:        rating,
        numReviews:    numReviews,
        stock:         stock ?? this.stock,
        isNew:         isNew,
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
