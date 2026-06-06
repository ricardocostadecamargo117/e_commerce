import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/product.dart';
import '../../../models/order.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/app_header.dart';
import '../../../theme.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isAdmin) {
      return Scaffold(
        backgroundColor: kBg,
        appBar: const AppHeader(),
        body: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.block, color: kError, size: 60),
            SizedBox(height: 16),
            Text('Acesso negado',
                style: TextStyle(color: kText, fontSize: 18)),
            SizedBox(height: 8),
            Text('Apenas administradores podem acessar esta área.',
                style: TextStyle(color: kTextMuted)),
          ]),
        ),
      );
    }

    final products = context.watch<ProductProvider>().products;
    final orders   = context.watch<OrderProvider>().orders;

    return Scaffold(
      backgroundColor: kBg,
      appBar: const AppHeader(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Admin Header ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kAdminAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.admin_panel_settings_outlined,
                        color: kAdminAccent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Painel Admin',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          color: kText,
                          fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 20),

                // Stats
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    _StatCard(
                        label: 'Produtos',
                        value: '${products.length}',
                        icon: Icons.inventory_2_outlined,
                        color: kGold),
                    const SizedBox(width: 12),
                    _StatCard(
                        label: 'Pedidos',
                        value: '${orders.length}',
                        icon: Icons.receipt_long_outlined,
                        color: Colors.blue),
                    const SizedBox(width: 12),
                    _StatCard(
                        label: 'Receita',
                        value: orders.isEmpty
                            ? 'R\$ 0'
                            : 'R\$ ${orders.fold(0.0, (s, o) => s + o.total).toStringAsFixed(0)}',
                        icon: Icons.attach_money_outlined,
                        color: kSuccess),
                    const SizedBox(width: 12),
                    _StatCard(
                        label: 'Em Aberto',
                        value: '${orders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).length}',
                        icon: Icons.pending_outlined,
                        color: Colors.orange),
                  ]),
                ),
                const SizedBox(height: 20),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: kSurface2,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kBorder),
                  ),
                  child: TabBar(
                    controller: _tabs,
                    indicator: BoxDecoration(
                      color: kAdminAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: kAdminAccent.withOpacity(0.4)),
                    ),
                    labelColor: kAdminAccent,
                    unselectedLabelColor: kTextMuted,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(
                          icon: Icon(Icons.inventory_2_outlined, size: 16),
                          text: 'Produtos'),
                      Tab(
                          icon: Icon(Icons.receipt_long_outlined, size: 16),
                          text: 'Pedidos'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Tab Views ────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _ProductsTab(products: products),
                _OrdersTab(orders: orders),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductDialog(context),
        backgroundColor: kAdminAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto'),
      ),
    );
  }

  void _showProductDialog(BuildContext context, [Product? product]) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ProductDialog(product: product),
    );
  }
}

// ─── Products Tab ─────────────────────────────────────────────────────────────
class _ProductsTab extends StatelessWidget {
  final List<Product> products;
  const _ProductsTab({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final p = products[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: glassDecoration(),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.network(p.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: kSurface2)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style: const TextStyle(
                          color: kText,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),
                  const SizedBox(height: 3),
                  Row(children: [
                    Text(p.category,
                        style: const TextStyle(
                            color: kTextFaint, fontSize: 11)),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 10,
                      color: kBorder,
                    ),
                    const SizedBox(width: 8),
                    Text('Estoque: ${p.stock}',
                        style: TextStyle(
                            color: p.stock <= 3 ? kError : kTextFaint,
                            fontSize: 11)),
                  ]),
                  const SizedBox(height: 4),
                  Text('R\$ ${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: kGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ],
              ),
            ),
            Column(children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: kAdminAccent, size: 18),
                onPressed: () => showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (_) => _ProductDialog(product: p),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: kError, size: 18),
                onPressed: () => _confirmDelete(context, p),
              ),
            ]),
          ]),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Product p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kSurface2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Excluir produto?',
            style: TextStyle(color: kText)),
        content: Text('Tem certeza que deseja excluir "${p.name}"?',
            style: const TextStyle(color: kTextMuted)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: kTextMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kError),
            onPressed: () {
              context.read<ProductProvider>().deleteProduct(p.id);
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

// ─── Orders Tab ───────────────────────────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  final List<Order> orders;
  const _OrdersTab({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('Nenhum pedido ainda.',
            style: TextStyle(color: kTextMuted, fontSize: 15)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final o = orders[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: glassDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('Pedido #${o.id}',
                    style: const TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                const Spacer(),
                Text('R\$ ${o.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: kGold,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ]),
              const SizedBox(height: 6),
              Text(
                '${o.items.length} item(s) · ${o.paymentMethod.icon} ${o.paymentMethod.label}',
                style: const TextStyle(color: kTextFaint, fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Status selector
              Row(children: [
                const Text('Status: ',
                    style:
                        TextStyle(color: kTextMuted, fontSize: 12)),
                Expanded(
                  child: DropdownButton<OrderStatus>(
                    value: o.status,
                    dropdownColor: kSurface2,
                    style: const TextStyle(color: kText, fontSize: 12),
                    underline: const SizedBox(),
                    isDense: true,
                    items: OrderStatus.values
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.label,
                                  style:
                                      const TextStyle(fontSize: 12)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        context
                            .read<OrderProvider>()
                            .adminUpdateStatus(o.id, v);
                      }
                    },
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }
}

// ─── Product Dialog ───────────────────────────────────────────────────────────
class _ProductDialog extends StatefulWidget {
  final Product? product;
  const _ProductDialog({this.product});
  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _originalPriceCtrl;
  late TextEditingController _imageCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _stockCtrl;
  late String _category;
  bool _saving = false;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl          = TextEditingController(text: p?.name ?? '');
    _priceCtrl         = TextEditingController(text: p?.price.toStringAsFixed(2) ?? '');
    _originalPriceCtrl = TextEditingController(
        text: p?.originalPrice?.toStringAsFixed(2) ?? '');
    _imageCtrl         = TextEditingController(text: p?.image ?? 'https://picsum.photos/seed/new/500/600');
    _descCtrl          = TextEditingController(text: p?.description ?? '');
    _stockCtrl         = TextEditingController(text: '${p?.stock ?? 10}');
    _category          = p?.category ?? productCategories[1];
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _priceCtrl, _originalPriceCtrl,
      _imageCtrl, _descCtrl, _stockCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final prov = context.read<ProductProvider>();
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final origPrice = _originalPriceCtrl.text.isNotEmpty
        ? double.tryParse(_originalPriceCtrl.text)
        : null;
    final stock = int.tryParse(_stockCtrl.text) ?? 0;

    if (isEdit) {
      prov.updateProduct(widget.product!.copyWith(
        name: _nameCtrl.text.trim(),
        price: price,
        image: _imageCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category,
        stock: stock,
      ));
    } else {
      prov.addProduct(prov.createNew(
        name: _nameCtrl.text.trim(),
        price: price,
        image: _imageCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category,
        stock: stock,
        originalPrice: origPrice,
      ));
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(isEdit ? 'Editar Produto' : 'Novo Produto',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          color: kText,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: kTextMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ]),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogField('Nome do produto', _nameCtrl,
                            required: true),
                        const SizedBox(height: 14),
                        Row(children: [
                          Expanded(
                              child: _dialogField('Preço (R\$)', _priceCtrl,
                                  keyboardType:
                                      TextInputType.number,
                                  required: true)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _dialogField(
                                  'Preço original (opcional)',
                                  _originalPriceCtrl,
                                  keyboardType:
                                      TextInputType.number)),
                        ]),
                        const SizedBox(height: 14),
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Categoria',
                                    style: TextStyle(
                                        color: kTextMuted, fontSize: 12)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _category,
                                  dropdownColor: kSurface2,
                                  style: const TextStyle(
                                      color: kText, fontSize: 13),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                  ),
                                  items: productCategories
                                      .where((c) => c != 'Todos')
                                      .map((c) => DropdownMenuItem(
                                          value: c, child: Text(c)))
                                      .toList(),
                                  onChanged: (v) => setState(
                                      () => _category = v ?? _category),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _dialogField('Estoque', _stockCtrl,
                                  keyboardType: TextInputType.number,
                                  required: true)),
                        ]),
                        const SizedBox(height: 14),
                        _dialogField('URL da imagem', _imageCtrl,
                            required: true),
                        const SizedBox(height: 14),
                        const Text('Descrição',
                            style: TextStyle(
                                color: kTextMuted, fontSize: 12)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descCtrl,
                          maxLines: 3,
                          style: const TextStyle(
                              color: kText, fontSize: 13),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Obrigatório'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kAdminAccent,
                        foregroundColor: Colors.white),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(isEdit ? 'Salvar alterações' : 'Adicionar produto'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogField(String label, TextEditingController ctrl,
      {TextInputType? keyboardType, bool required = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(color: kTextMuted, fontSize: 12)),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(color: kText, fontSize: 13),
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        validator: required
            ? (v) =>
                (v == null || v.isEmpty) ? 'Campo obrigatório' : null
            : null,
      ),
    ]);
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w800, fontSize: 18)),
            Text(label,
                style:
                    const TextStyle(color: kTextMuted, fontSize: 11)),
          ]),
        ]),
      );
}
