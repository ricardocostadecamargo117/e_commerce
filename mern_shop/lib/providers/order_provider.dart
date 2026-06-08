import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _loading = false;
  String? _error;

  List<Order> get orders => List.unmodifiable(_orders);
  bool get loading => _loading;
  String? get error => _error;

  // ── Buscar pedidos do usuário logado ───────────────────────────────────────
  Future<void> fetchMyOrders() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.get('/orders/my') as List;
      _orders = data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _loading = false;
    notifyListeners();
  }

  // ── Buscar todos os pedidos (admin) ────────────────────────────────────────
  Future<void> fetchAllOrders() async {
    _loading = true;
    notifyListeners();

    try {
      final data = await ApiService.get('/orders') as List;
      _orders = data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _loading = false;
    notifyListeners();
  }

  // ── Criar pedido ───────────────────────────────────────────────────────────
  Future<Order?> placeOrder({
    required List<CartItem> cartItems,
    required ShippingAddress address,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double shippingCost,
    required double tax,
  }) async {
    try {
      final data = await ApiService.post('/orders', {
        'items': cartItems
            .map((ci) => {
                  'productId': ci.product.id,
                  'quantity': ci.quantity,
                })
            .toList(),
        'shippingAddress': {
          'fullName': address.fullName,
          'street': address.street,
          'number': address.number,
          'complement': address.complement,
          'neighborhood': address.neighborhood,
          'city': address.city,
          'state': address.state,
          'zipCode': address.zipCode,
        },
        'paymentMethod': paymentMethod.name,
        'subtotal': subtotal,
        'shippingCost': shippingCost,
        'tax': tax,
      });

      final order = Order.fromJson(data);
      _orders.insert(0, order);
      notifyListeners();
      return order;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  // ── Atualizar status (admin) ───────────────────────────────────────────────
  Future<void> adminUpdateStatus(String orderId, OrderStatus status) async {
    try {
      await ApiService.put('/orders/$orderId/status', {
        'status': status.name,
      });
      final idx = _orders.indexWhere((o) => o.id == orderId);
      if (idx >= 0) {
        _orders[idx] = _orders[idx].copyWith(status: status);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  List<Order> ordersForUser(String userId) =>
      _orders.where((o) => o.userId == userId).toList();

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
