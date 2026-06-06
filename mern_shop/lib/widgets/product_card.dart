import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? kGold.withOpacity(0.5) : kBorder,
              width: _hovered ? 1 : 0.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: kGold.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ───────────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.network(
                          widget.product.image,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: kSurface2,
                              child: const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5, color: kGold),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: kSurface2,
                            child: const Icon(Icons.image_outlined,
                                color: kTextFaint, size: 40),
                          ),
                        ),
                      ),
                    ),
                    // Badges
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.product.isNew)
                            _Badge(label: 'NOVO', color: kGold),
                          if (widget.product.isOnSale) ...[
                            const SizedBox(height: 4),
                            _Badge(
                                label: '-${widget.product.discountPercent}%',
                                color: kError),
                          ],
                        ],
                      ),
                    ),
                    // Low stock warning
                    if (widget.product.stock <= 3)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                kError.withOpacity(0.8),
                                kError.withOpacity(0.6)
                              ],
                            ),
                          ),
                          child: Text(
                            'Restam apenas ${widget.product.stock}!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Info ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.category,
                      style: const TextStyle(
                          color: kTextFaint,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                          color: kText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (widget.product.isOnSale) ...[
                          Text(
                            'R\$ ${widget.product.originalPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: kTextFaint,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          'R\$ ${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: kGold,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Rating stars
                    Row(children: [
                      ...List.generate(
                          5,
                          (i) => Icon(
                                i < widget.product.rating.floor()
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 12,
                                color: kGold.withOpacity(0.7),
                              )),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.product.numReviews})',
                        style: const TextStyle(
                            color: kTextFaint, fontSize: 10),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5),
        ),
      );
}
