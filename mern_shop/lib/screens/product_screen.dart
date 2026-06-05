import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/app_header.dart';
import '../theme.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _addToCart(Product product) {
    context.read<CartProvider>().addToCart(product, quantity: _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} adicionado ao carrinho!'),
        backgroundColor: kPrimaryRed,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Ver Carrinho',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios, size: 14, color: kPrimaryRed),
                  Text('Voltar',
                      style: TextStyle(color: kPrimaryRed, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Product detail layout
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _ProductImage(product: product),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 3,
                    child: _ProductInfo(
                      product: product,
                      quantity: _quantity,
                      onIncrement: _increment,
                      onDecrement: _decrement,
                      onAddToCart: () => _addToCart(product),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _ProductImage(product: product),
                  const SizedBox(height: 20),
                  _ProductInfo(
                    product: product,
                    quantity: _quantity,
                    onIncrement: _increment,
                    onDecrement: _decrement,
                    onAddToCart: () => _addToCart(product),
                  ),
                ],
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

class _ProductImage extends StatelessWidget {
  final Product product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          product.image,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: kLightGrey,
              child: const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: kPrimaryRed),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const _ProductInfo({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: kTextDark),
        ),
        const SizedBox(height: 8),
        // Rating
        Row(
          children: [
            ...List.generate(
              5,
              (i) => Icon(
                i < product.rating.floor()
                    ? Icons.star
                    : (i < product.rating ? Icons.star_half : Icons.star_border),
                color: Colors.amber,
                size: 18,
              ),
            ),
            const SizedBox(width: 6),
            Text('${product.numReviews} reviews',
                style: const TextStyle(fontSize: 13, color: kTextGrey)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: kTextDark),
        ),
        const Divider(height: 28),
        Text(product.description,
            style: const TextStyle(
                fontSize: 15, color: kTextGrey, height: 1.6)),
        const SizedBox(height: 24),

        // Status
        Row(
          children: [
            const Text('Status: ',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green),
              ),
              child: const Text('Em Estoque',
                  style: TextStyle(color: Colors.green, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Quantity selector
        Row(
          children: [
            const Text('Quantidade:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: kBorderGrey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: onDecrement,
                    constraints: const BoxConstraints(
                        minWidth: 36, minHeight: 36),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('$quantity',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: onIncrement,
                    constraints: const BoxConstraints(
                        minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Add to cart
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onAddToCart,
            icon: const Icon(Icons.shopping_cart_outlined, size: 20),
            label: const Text('Adicionar ao Carrinho'),
          ),
        ),
      ],
    );
  }
}
