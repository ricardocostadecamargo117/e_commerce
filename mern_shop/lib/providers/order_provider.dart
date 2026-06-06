import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/product.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final _uuid = const Uuid();

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> ordersForUser(String userId) =>
      _orders.where((o) => o.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Order? getOrder(String orderId) =>
      _orders.firstWhere((o) => o.id == orderId, orElse: () => throw Exception());

  // ── Place Order ────────────────────────────────────────────────────────────
  Order placeOrder({
    required String userId,
    required List<CartItem> cartItems,
    required ShippingAddress address,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double shippingCost,
    required double tax,
  }) {
    final order = Order(
      id: _uuid.v4().substring(0, 8).toUpperCase(),
      userId: userId,
      items: cartItems
          .map((ci) => OrderItem(
                productId: ci.product.id,
                productName: ci.product.name,
                productImage: ci.product.image,
                price: ci.product.price,
                quantity: ci.quantity,
              ))
          .toList(),
      address: address,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      shippingCost: shippingCost,
      tax: tax,
      total: subtotal + shippingCost + tax,
      status: paymentMethod == PaymentMethod.boleto
          ? OrderStatus.pending
          : OrderStatus.confirmed,
      createdAt: DateTime.now(),
      estimatedDelivery: DateTime.now().add(const Duration(days: 7)),
    );
    _orders.add(order);

    // Simulate status progression (mock)
    _simulateProgress(order.id, paymentMethod);

    notifyListeners();
    return order;
  }

  void _simulateProgress(String orderId, PaymentMethod method) {
    if (method == PaymentMethod.boleto) return; // stays pending
    Future.delayed(const Duration(seconds: 3), () {
      _updateStatus(orderId, OrderStatus.processing);
    });
  }

  void _updateStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx] = _orders[idx].copyWith(status: status);
      notifyListeners();
    }
  }

  // Admin: manually update status
  void adminUpdateStatus(String orderId, OrderStatus status) {
    _updateStatus(orderId, status);
  }
}
