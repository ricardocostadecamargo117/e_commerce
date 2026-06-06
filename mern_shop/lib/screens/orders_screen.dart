import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/order_status_stepper.dart';
import '../theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orderProv = context.watch<OrderProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        backgroundColor: kBg,
        appBar: const AppHeader(),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.lock_outline, color: kTextFaint, size: 60),
            const SizedBox(height: 16),
            const Text('Faça login para ver seus pedidos',
                style: TextStyle(color: kTextMuted, fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Entrar'),
            ),
          ]),
        ),
      );
    }

    final orders = orderProv.ordersForUser(auth.user!.id);

    return Scaffold(
      backgroundColor: kBg,
      appBar: const AppHeader(),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 80, color: kTextFaint),
                  const SizedBox(height: 16),
                  Text('Nenhum pedido encontrado',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 22, color: kTextMuted)),
                  const SizedBox(height: 8),
                  const Text('Seus pedidos aparecerão aqui.',
                      style: TextStyle(color: kTextFaint, fontSize: 14)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false),
                    child: const Text('Explorar Produtos'),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Meus Pedidos',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                color: kText,
                                fontWeight: FontWeight.w700)),
                        Text('${orders.length} pedido${orders.length != 1 ? 's' : ''}',
                            style: const TextStyle(
                                color: kTextMuted, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _OrderCard(order: orders[i]),
                      childCount: orders.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.order.status) {
      case OrderStatus.delivered: return kSuccess;
      case OrderStatus.cancelled: return kError;
      case OrderStatus.shipped:   return Colors.blue;
      case OrderStatus.pending:   return Colors.orange;
      default:                    return kGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final dateStr =
        '${order.createdAt.day.toString().padLeft(2, '0')}/'
        '${order.createdAt.month.toString().padLeft(2, '0')}/'
        '${order.createdAt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: glassDecoration(),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Order id + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pedido #${order.id}',
                            style: const TextStyle(
                                color: kText,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(dateStr,
                            style: const TextStyle(
                                color: kTextMuted, fontSize: 12)),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _statusColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      order.status.label,
                      style: TextStyle(
                          color: _statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Total
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('R\$ ${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: kGold,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      Text(
                          '${order.items.length} ${order.items.length == 1 ? 'item' : 'itens'}',
                          style: const TextStyle(
                              color: kTextFaint, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: kTextFaint,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded content ────────────────────────────────────────
          if (_expanded) ...[
            const Divider(color: kBorder, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status stepper
                  OrderStatusStepper(status: order.status),
                  const SizedBox(height: 20),

                  // Items preview
                  const Text('Itens',
                      style: TextStyle(
                          color: kTextMuted,
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Image.network(
                                item.productImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(color: kSurface2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(item.productName,
                                style: const TextStyle(
                                    color: kText, fontSize: 13)),
                          ),
                          const SizedBox(width: 8),
                          Text('×${item.quantity}',
                              style: const TextStyle(
                                  color: kTextMuted, fontSize: 12)),
                          const SizedBox(width: 8),
                          Text(
                              'R\$ ${item.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: kGold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      )),

                  const Divider(color: kBorder, height: 20),

                  // Address + Payment row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ENTREGA',
                                style: TextStyle(
                                    color: kTextFaint,
                                    fontSize: 10,
                                    letterSpacing: 1)),
                            const SizedBox(height: 6),
                            Text(
                              '${order.address.street}, ${order.address.number}\n'
                              '${order.address.city}/${order.address.state}',
                              style: const TextStyle(
                                  color: kTextMuted,
                                  fontSize: 12,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PAGAMENTO',
                                style: TextStyle(
                                    color: kTextFaint,
                                    fontSize: 10,
                                    letterSpacing: 1)),
                            const SizedBox(height: 6),
                            Row(children: [
                              Text(order.paymentMethod.icon),
                              const SizedBox(width: 6),
                              Text(order.paymentMethod.label,
                                  style: const TextStyle(
                                      color: kTextMuted, fontSize: 12)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (order.estimatedDelivery != null &&
                      order.status != OrderStatus.delivered &&
                      order.status != OrderStatus.cancelled) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: kGold.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: kGold.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.local_shipping_outlined,
                            color: kGold, size: 14),
                        const SizedBox(width: 8),
                        Text(
                          'Previsão de entrega: '
                          '${order.estimatedDelivery!.day.toString().padLeft(2, '0')}/'
                          '${order.estimatedDelivery!.month.toString().padLeft(2, '0')}/'
                          '${order.estimatedDelivery!.year}',
                          style: const TextStyle(
                              color: kGold, fontSize: 12),
                        ),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
