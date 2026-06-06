import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = List.from(mockProducts);
  final _uuid = const Uuid();

  List<Product> get products => List.unmodifiable(_products);

  List<Product> search(String query) {
    if (query.isEmpty) return products;
    final q = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  List<Product> byCategory(String category) {
    if (category == 'Todos') return products;
    return _products.where((p) => p.category == category).toList();
  }

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void updateProduct(Product updated) {
    final idx = _products.indexWhere((p) => p.id == updated.id);
    if (idx >= 0) {
      _products[idx] = updated;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Product createNew({
    required String name,
    required double price,
    required String image,
    required String description,
    required String category,
    required int stock,
    double? originalPrice,
  }) =>
      Product(
        id: _uuid.v4(),
        name: name,
        price: price,
        image: image,
        description: description,
        category: category,
        rating: 0.0,
        numReviews: 0,
        stock: stock,
        isNew: true,
        originalPrice: originalPrice,
      );
}
