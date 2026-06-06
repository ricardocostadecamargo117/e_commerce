import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_header.dart';
import '../theme.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _qty = 1;
  bool _wishlist = false;

  void _addToCart(Product product) {
    context.read<CartProvider>().addItem(product, qty: _qty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle, color: kSuccess, size: 16),
          const SizedBox(width: 8),
          Text('${product.name} adicionado!'),
        ]),
        action: SnackBarAction(
          label: 'Ver Carrinho',
          textColor: kGold,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();
    final wide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: kBg,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (_) => false),
                child: const Text('Início',
                    style: TextStyle(color: kTextMuted, fontSize: 12)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child:
                    Text('/', style: TextStyle(color: kTextFaint, fontSize: 12)),
              ),
              Text(product.category,
                  style: const TextStyle(color: kTextMuted, fontSize: 12)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child:
                    Text('/', style: TextStyle(color: kTextFaint, fontSize: 12)),
              ),
              Flexible(
                child: Text(product.name,
                    style: const TextStyle(color: kGold, fontSize: 12),
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
            const SizedBox(height: 24),

            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5, child: _ImageSection(product: product)),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 6,
                    child: _InfoSection(
                      product: product,
                      qty: _qty,
                      wishlist: _wishlist,
                      inCart: cart.isInCart(product.id),
                      onQtyChange: (v) => setState(() => _qty = v),
                      onWishlist: () =>
                          setState(() => _wishlist = !_wishlist),
                      onAddToCart: () => _addToCart(product),
                      onBuyNow: () {
                        if (!auth.isLoggedIn) {
                          Navigator.pushNamed(context, '/login');
                          return;
                        }
                        _addToCart(product);
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _ImageSection(product: product),
                  const SizedBox(height: 24),
                  _InfoSection(
                    product: product,
                    qty: _qty,
                    wishlist: _wishlist,
                    inCart: cart.isInCart(product.id),
                    onQtyChange: (v) => setState(() => _qty = v),
                    onWishlist: () => setState(() => _wishlist = !_wishlist),
                    onAddToCart: () => _addToCart(product),
                    onBuyNow: () {
                      if (!auth.isLoggedIn) {
                        Navigator.pushNamed(context, '/login');
                        return;
                      }
                      _addToCart(product);
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final Product product;
  const _ImageSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 0.85,
        child: Image.network(
          product.image,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              color: kSurface,
              child: const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: kGold)),
            );
          },
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Product product;
  final int qty;
  final bool wishlist;
  final bool inCart;
  final ValueChanged<int> onQtyChange;
  final VoidCallback onWishlist;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _InfoSection({
    required this.product,
    required this.qty,
    required this.wishlist,
    required this.inCart,
    required this.onQtyChange,
    required this.onWishlist,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kSurface2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
            ),
            child: Text(product.category,
                style: const TextStyle(
                    color: kTextMuted, fontSize: 11, letterSpacing: 1)),
          ),
          if (product.isNew) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: kGoldGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('NOVO',
                  style: TextStyle(
                      color: kBg,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1)),
            ),
          ],
        ]),
        const SizedBox(height: 14),
        Text(product.name,
            style: GoogleFonts.playfairDisplay(
                fontSize: 26, color: kText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        // Rating
        Row(children: [
          ...List.generate(
              5,
              (i) => Icon(
                    i < product.rating.floor()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: kGold,
                  )),
          const SizedBox(width: 8),
          Text('${product.rating}  (${product.numReviews} avaliações)',
              style: const TextStyle(color: kTextMuted, fontSize: 12)),
        ]),
        const SizedBox(height: 20),

        // Price
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: kGold, fontSize: 30, fontWeight: FontWeight.w700)),
          if (product.isOnSale) ...[
            const SizedBox(width: 12),
            Text('R\$ ${product.originalPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: kTextFaint,
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: kError.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('-${product.discountPercent}%',
                  style: const TextStyle(
                      color: kError,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ]),

        const SizedBox(height: 6),
        Text(
          'Em até 12x de R\$ ${(product.price / 12).toStringAsFixed(2)} sem juros',
          style: const TextStyle(color: kTextMuted, fontSize: 12),
        ),
        const SizedBox(height: 24),

        const Divider(color: kBorder),
        const SizedBox(height: 20),

        // Description
        Text(product.description,
            style: const TextStyle(
                color: kTextMuted, fontSize: 14, height: 1.7)),
        const SizedBox(height: 24),

        // Stock
        Row(children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: product.stock > 5
                  ? kSuccess
                  : product.stock > 0
                      ? Colors.orange
                      : kError,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            product.stock > 5
                ? 'Em estoque'
                : product.stock > 0
                    ? 'Apenas ${product.stock} restantes'
                    : 'Esgotado',
            style: TextStyle(
                color: product.stock > 5
                    ? kSuccess
                    : product.stock > 0
                        ? Colors.orange
                        : kError,
                fontSize: 13),
          ),
        ]),
        const SizedBox(height: 20),

        // Quantity selector
        Row(children: [
          const Text('Quantidade:',
              style: TextStyle(color: kTextMuted, fontSize: 13)),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: kSurface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBorder),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 16, color: kTextMuted),
                onPressed: qty > 1 ? () => onQtyChange(qty - 1) : null,
              ),
              SizedBox(
                width: 32,
                child: Text('$qty',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: kText, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 16, color: kTextMuted),
                onPressed: qty < product.stock
                    ? () => onQtyChange(qty + 1)
                    : null,
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 24),

        // Action buttons
        Row(children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: product.stock > 0 ? onAddToCart : null,
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: Text(inCart ? 'Adicionar mais' : 'Adicionar'),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: onBuyNow,
              child: const Text('Comprar agora'),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: kSurface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBorder),
            ),
            child: IconButton(
              icon: Icon(
                wishlist ? Icons.favorite : Icons.favorite_border,
                color: wishlist ? kError : kTextMuted,
                size: 20,
              ),
              onPressed: onWishlist,
            ),
          ),
        ]),

        const SizedBox(height: 20),
        // Free shipping info
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kSurface2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBorder),
          ),
          child: const Row(children: [
            Icon(Icons.local_shipping_outlined,
                color: kGold, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                  'Frete grátis para compras acima de R\$ 200,00',
                  style: TextStyle(color: kTextMuted, fontSize: 12)),
            ),
          ]),
        ),
      ],
    );
  }
}
