import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/app_header.dart';
import '../widgets/product_card.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = mockProducts;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
      _filteredProducts = _searchQuery.isEmpty
          ? mockProducts
          : mockProducts
              .where((p) => p.name.toLowerCase().contains(_searchQuery))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        searchController: _searchController,
        onSearch: _onSearch,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Latest Products',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 20),
              if (_filteredProducts.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off,
                            size: 60, color: kBorderGrey),
                        const SizedBox(height: 12),
                        Text(
                          'Nenhum produto encontrado para "$_searchQuery"',
                          style: const TextStyle(
                              color: kTextGrey, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    if (constraints.maxWidth > 900) crossAxisCount = 4;
                    else if (constraints.maxWidth > 600) crossAxisCount = 3;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: product,
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
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
