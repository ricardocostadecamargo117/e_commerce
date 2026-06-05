import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/app_header.dart';
import '../theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 80, color: kBorderGrey),
                  const SizedBox(height: 16),
                  const Text('Seu carrinho está vazio',
                      style: TextStyle(fontSize: 18, color: kTextGrey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false),
                    child: const Text('Continuar Comprando'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shopping Cart',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kTextDark),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${cart.itemCount} ${cart.itemCount == 1 ? 'item' : 'itens'}',
                    style: const TextStyle(color: kTextGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 700) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3, child: _CartItemsList(cart: cart)),
                            const SizedBox(width: 24),
                            SizedBox(
                                width: 280,
                                child: _OrderSummary(cart: cart)),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _CartItemsList(cart: cart),
                          const SizedBox(height: 20),
                          _OrderSummary(cart: cart),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: kLightGrey,
        child: const Text(
          'Copyright © MERN Shop',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: kTextGrey),
        ),
      ),
    );
  }
}

class _CartItemsList extends StatelessWidget {
  final CartProvider cart;
  const _CartItemsList({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cart.items.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      item.product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          Container(color: kLightGrey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: item.product,
                        ),
                        child: Text(
                          item.product.name,
                          style: const TextStyle(
                              color: kPrimaryRed,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)} cada',
                        style: const TextStyle(
                            color: kTextGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Quantity controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kBorderGrey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            onPressed: () => context
                                .read<CartProvider>()
                                .decrementQuantity(item.product.id),
                            constraints: const BoxConstraints(
                                minWidth: 32, minHeight: 32),
                          ),
                          Text('${item.quantity}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            onPressed: () => context
                                .read<CartProvider>()
                                .incrementQuantity(item.product.id),
                            constraints: const BoxConstraints(
                                minWidth: 32, minHeight: 32),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: kPrimaryRed, size: 20),
                      onPressed: () => context
                          .read<CartProvider>()
                          .removeFromCart(item.product.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;
  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final shipping = cart.totalPrice > 100 ? 0.0 : 9.99;
    final tax = cart.totalPrice * 0.08;
    final total = cart.totalPrice + shipping + tax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo do Pedido',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextDark),
            ),
            const Divider(height: 24),
            _SummaryRow(
                label: 'Subtotal',
                value: '\$${cart.totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Frete',
              value: shipping == 0 ? 'Grátis' : '\$${shipping.toStringAsFixed(2)}',
              valueColor: shipping == 0 ? Colors.green : null,
            ),
            const SizedBox(height: 10),
            _SummaryRow(
                label: 'Impostos (8%)',
                value: '\$${tax.toStringAsFixed(2)}'),
            const Divider(height: 24),
            _SummaryRow(
              label: 'Total',
              value: '\$${total.toStringAsFixed(2)}',
              bold: true,
              valueSize: 18,
            ),
            const SizedBox(height: 16),
            if (shipping == 0)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_shipping_outlined,
                        size: 16, color: Colors.green),
                    SizedBox(width: 6),
                    Text('Frete grátis aplicado!',
                        style:
                            TextStyle(color: Colors.green, fontSize: 13)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Checkout concluído! (protótipo)'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
                child: const Text('Finalizar Compra'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false),
                child: const Text('Continuar Comprando'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final double? valueSize;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueSize,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: valueSize ?? 14,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: valueColor ?? kTextDark,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: kTextDark)),
        Text(value, style: style),
      ],
    );
  }
}
