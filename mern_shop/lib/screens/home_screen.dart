import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/product_card.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  String _search = '';
  String _category = 'Todos';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Carrega produtos da API ao abrir o app
    Future.microtask(() => context.read<ProductProvider>().fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productProv = context.watch<ProductProvider>();

    List<Product> displayed = productProv.products;
    if (_category != 'Todos') {
      displayed = displayed.where((p) => p.category == _category).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      displayed = displayed
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppHeader(
        searchController: _searchCtrl,
        onSearch: (v) => setState(() => _search = v),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Hero Banner ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(32),
              height: 180,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1508), Color(0xFF0D0D10)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kGold.withOpacity(0.25), width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Coleção\nExclusiva',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: kText,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Moda de alto padrão, direto para você.',
                          style: TextStyle(color: kTextMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: kGoldGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ver Coleção',
                            style: TextStyle(
                                color: kBg,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.diamond, color: kGold, size: 80),
                ],
              ),
            ),
          ),

          // ── Category Filter ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: productCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = productCategories[i];
                  final selected = _category == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? kGold : kSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? kGold : kBorder,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? kBg : kTextMuted,
                          fontSize: 12,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Section Title ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _category == 'Todos' ? 'Todos os Produtos' : _category,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: kText),
                  ),
                  Text(
                    '${displayed.length} itens',
                    style: const TextStyle(color: kTextMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Grid ────────────────────────────────────────────────────
          displayed.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 60, color: kTextFaint),
                        const SizedBox(height: 12),
                        Text('Nenhum produto encontrado',
                            style: const TextStyle(
                                color: kTextMuted, fontSize: 16)),
                        if (_search.isNotEmpty || _category != 'Todos')
                          TextButton(
                            onPressed: () => setState(() {
                              _search = '';
                              _searchCtrl.clear();
                              _category = 'Todos';
                            }),
                            child: const Text('Limpar filtros'),
                          ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => ProductCard(
                        product: displayed[i],
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: displayed[i],
                        ),
                      ),
                      childCount: displayed.length,
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 260,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Copyright © 2024 MERN Shop',
                textAlign: TextAlign.center,
                style: TextStyle(color: kTextFaint, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
