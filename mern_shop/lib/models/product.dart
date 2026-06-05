class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;
  final String category;
  final double rating;
  final int numReviews;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
    required this.numReviews,
  });
}

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'All Set',
    price: 70.99,
    image: 'https://picsum.photos/seed/bag1/400/400',
    description:
        'A stylish and versatile handbag perfect for any occasion. Crafted with premium materials for durability and elegance.',
    category: 'Bags',
    rating: 4.5,
    numReviews: 12,
  ),
  Product(
    id: '2',
    name: 'Blurrygram Shawl',
    price: 85.99,
    image: 'https://picsum.photos/seed/shawl1/400/400',
    description:
        'A luxurious shawl with a unique blurry gradient pattern. Perfect for cool evenings and sophisticated looks.',
    category: 'Accessories',
    rating: 4.2,
    numReviews: 8,
  ),
  Product(
    id: '3',
    name: 'Since 1854 Metallic Buckle',
    price: 90.99,
    image: 'https://picsum.photos/seed/pants1/400/400',
    description:
        'Classic black pants featuring the iconic metallic buckle detail. A wardrobe essential for the modern fashion enthusiast.',
    category: 'Clothing',
    rating: 4.7,
    numReviews: 25,
  ),
  Product(
    id: '4',
    name: 'Minister Chelsea Boots',
    price: 100.99,
    image: 'https://picsum.photos/seed/boots1/400/400',
    description:
        'Premium Chelsea boots with a sleek silhouette. Handcrafted for comfort and style, ideal for any urban adventure.',
    category: 'Shoes',
    rating: 4.8,
    numReviews: 31,
  ),
  Product(
    id: '5',
    name: 'Silk Evening Blouse',
    price: 120.00,
    image: 'https://picsum.photos/seed/blouse1/400/400',
    description:
        'An elegant silk blouse designed for evening occasions. Features a flowing silhouette and premium silk fabric.',
    category: 'Clothing',
    rating: 4.4,
    numReviews: 18,
  ),
  Product(
    id: '6',
    name: 'Leather Crossbody',
    price: 95.50,
    image: 'https://picsum.photos/seed/bag2/400/400',
    description:
        'A compact leather crossbody bag with multiple compartments. Combines practicality with timeless style.',
    category: 'Bags',
    rating: 4.6,
    numReviews: 22,
  ),
  Product(
    id: '7',
    name: 'Cashmere Scarf',
    price: 65.00,
    image: 'https://picsum.photos/seed/scarf1/400/400',
    description:
        'A soft cashmere scarf in a neutral tone, perfect for layering during colder months. Luxuriously warm.',
    category: 'Accessories',
    rating: 4.3,
    numReviews: 14,
  ),
  Product(
    id: '8',
    name: 'Oxford Brogues',
    price: 135.99,
    image: 'https://picsum.photos/seed/shoes2/400/400',
    description:
        'Classic Oxford brogues with intricate detailing. A sophisticated choice for formal and semi-formal occasions.',
    category: 'Shoes',
    rating: 4.9,
    numReviews: 40,
  ),
];
