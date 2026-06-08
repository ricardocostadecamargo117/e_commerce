import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => List.unmodifiable(_products);
  bool get loading           => _loading;
  String? get error          => _error;

  // ── Buscar todos os produtos ───────────────────────────────────────────────
  Future<void> fetchProducts({String? category, String? search}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      String path = '/products?';
      if (category != null && category != 'Todos') {
        path += 'category=${Uri.encodeComponent(category)}&';
      }
      if (search != null && search.isNotEmpty) {
        path += 'search=${Uri.encodeComponent(search)}';
      }

      final data = await ApiService.get(path) as List;
      _products = data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _loading = false;
    notifyListeners();
  }

  // ── Criar produto (admin) ──────────────────────────────────────────────────
  Future<String?> createProduct({
    required String name,
    required double price,
    double? originalPrice,
    required String image,
    required String description,
    required String category,
    required int stock,
  }) async {
    try {
      final data = await ApiService.post('/products', {
        'name':          name,
        'price':         price,
        'originalPrice': originalPrice,
        'image':         image,
        'description':   description,
        'category':      category,
        'stock':         stock,
        'isNew':         true,
      });
      _products.insert(0, Product.fromJson(data));
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  // ── Editar produto (admin) ─────────────────────────────────────────────────
  Future<String?> updateProduct(String id, Map<String, dynamic> fields) async {
    try {
      final data = await ApiService.put('/products/$id', fields);
      final idx = _products.indexWhere((p) => p.id == id);
      if (idx >= 0) _products[idx] = Product.fromJson(data);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  // ── Excluir produto (admin) ────────────────────────────────────────────────
  Future<String?> deleteProduct(String id) async {
    try {
      await ApiService.delete('/products/$id');
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
