import 'product.dart';

// ─── Cart Item ────────────────────────────────────────────────────────────────
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

// ─── Order Status ─────────────────────────────────────────────────────────────
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:    return 'Aguardando Pagamento';
      case OrderStatus.confirmed:  return 'Confirmado';
      case OrderStatus.processing: return 'Em Preparação';
      case OrderStatus.shipped:    return 'Enviado';
      case OrderStatus.delivered:  return 'Entregue';
      case OrderStatus.cancelled:  return 'Cancelado';
    }
  }

  int get step {
    switch (this) {
      case OrderStatus.pending:    return 0;
      case OrderStatus.confirmed:  return 1;
      case OrderStatus.processing: return 2;
      case OrderStatus.shipped:    return 3;
      case OrderStatus.delivered:  return 4;
      case OrderStatus.cancelled:  return -1;
    }
  }

  // Converte string da API para enum
  static OrderStatus fromString(String value) {
    switch (value) {
      case 'pending':    return OrderStatus.pending;
      case 'confirmed':  return OrderStatus.confirmed;
      case 'processing': return OrderStatus.processing;
      case 'shipped':    return OrderStatus.shipped;
      case 'delivered':  return OrderStatus.delivered;
      case 'cancelled':  return OrderStatus.cancelled;
      default:           return OrderStatus.pending;
    }
  }
}

// ─── Order Item ───────────────────────────────────────────────────────────────
class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId:    json['product']?.toString() ?? '',
      productName:  json['name'] ?? '',
      productImage: json['image'] ?? '',
      price:        (json['price'] ?? 0).toDouble(),
      quantity:     (json['quantity'] ?? 1).toInt(),
    );
  }
}

// ─── Payment Method ───────────────────────────────────────────────────────────
enum PaymentMethod { creditCard, debitCard, pix, boleto }

extension PaymentMethodExt on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.creditCard: return 'Cartão de Crédito';
      case PaymentMethod.debitCard:  return 'Cartão de Débito';
      case PaymentMethod.pix:        return 'Pix';
      case PaymentMethod.boleto:     return 'Boleto Bancário';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.creditCard: return '💳';
      case PaymentMethod.debitCard:  return '🏧';
      case PaymentMethod.pix:        return '⚡';
      case PaymentMethod.boleto:     return '📄';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value) {
      case 'creditCard': return PaymentMethod.creditCard;
      case 'debitCard':  return PaymentMethod.debitCard;
      case 'pix':        return PaymentMethod.pix;
      case 'boleto':     return PaymentMethod.boleto;
      default:           return PaymentMethod.creditCard;
    }
  }
}

// ─── Shipping Address ─────────────────────────────────────────────────────────
class ShippingAddress {
  final String fullName;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;

  const ShippingAddress({
    required this.fullName,
    required this.street,
    required this.number,
    this.complement = '',
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  String get formatted =>
      '$street, $number${complement.isNotEmpty ? ', $complement' : ''} — '
      '$neighborhood, $city/$state — CEP $zipCode';

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName:     json['fullName'] ?? '',
      street:       json['street'] ?? '',
      number:       json['number'] ?? '',
      complement:   json['complement'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      city:         json['city'] ?? '',
      state:        json['state'] ?? '',
      zipCode:      json['zipCode'] ?? '',
    );
  }
}

// ─── Order ────────────────────────────────────────────────────────────────────
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final ShippingAddress address;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    required this.total,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.estimatedDelivery,
  });

  // ── Converte JSON da API para Order ────────────────────────────────────────
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id:     json['_id'] ?? '',
      userId: json['user'] is Map
          ? json['user']['_id'] ?? ''
          : json['user']?.toString() ?? '',
      items: (json['items'] as List? ?? [])
          .map((i) => OrderItem.fromJson(i))
          .toList(),
      address: ShippingAddress.fromJson(
          json['shippingAddress'] ?? {}),
      paymentMethod: PaymentMethodExt.fromString(
          json['paymentMethod'] ?? ''),
      subtotal:     (json['subtotal'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      tax:          (json['tax'] ?? 0).toDouble(),
      total:        (json['total'] ?? 0).toDouble(),
      status: OrderStatusExt.fromString(json['status'] ?? ''),
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'])
          : null,
    );
  }

  Order copyWith({OrderStatus? status}) => Order(
        id:            id,
        userId:        userId,
        items:         items,
        address:       address,
        paymentMethod: paymentMethod,
        subtotal:      subtotal,
        shippingCost:  shippingCost,
        tax:           tax,
        total:         total,
        status:        status ?? this.status,
        createdAt:     createdAt,
        estimatedDelivery: estimatedDelivery,
      );
}
