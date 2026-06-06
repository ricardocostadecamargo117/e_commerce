import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order.dart';
import '../widgets/app_header.dart';
import '../widgets/order_status_stepper.dart';
import '../theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    return Scaffold(
      backgroundColor: kBg,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Success icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSuccess.withOpacity(0.12),
                    border: Border.all(
                        color: kSuccess.withOpacity(0.4), width: 2),
                  ),
                  child: const Icon(Icons.check, color: kSuccess, size: 40),
                ),
                const SizedBox(height: 20),
                Text('Pedido Realizado!',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 28, color: kText, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Pedido #${order.id}',
                    style: const TextStyle(color: kGold, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                    'Você receberá uma confirmação no e-mail em breve.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kTextMuted, fontSize: 14)),
                const SizedBox(height: 32),

                // Status stepper
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: glassDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Status do Pedido',
                          style: TextStyle(
                              color: kText, fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 20),
                      OrderStatusStepper(status: order.status),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Order details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: glassDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Detalhes do Pedido',
                          style: TextStyle(
                              color: kText, fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 16),

                      // Items
                      ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Image.network(item.productImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(color: kSurface2)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName,
                                        style: const TextStyle(
                                            color: kText, fontSize: 13)),
                                    Text('Qtd: ${item.quantity}',
                                        style: const TextStyle(
                                            color: kTextMuted, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Text('R\$ ${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: kGold, fontWeight: FontWeight.w600, fontSize: 13)),
                            ]),
                          )),

                      const Divider(color: kBorder, height: 20),
                      _DetailRow('Subtotal',
                          'R\$ ${order.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 6),
                      _DetailRow('Frete',
                          order.shippingCost == 0 ? 'Grátis' : 'R\$ ${order.shippingCost.toStringAsFixed(2)}'),
                      const SizedBox(height: 6),
                      _DetailRow('Impostos',
                          'R\$ ${order.tax.toStringAsFixed(2)}'),
                      const Divider(color: kBorder, height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total',
                                style: TextStyle(
                                    color: kText, fontWeight: FontWeight.w700, fontSize: 15)),
                            Text('R\$ ${order.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: kGold, fontWeight: FontWeight.w800, fontSize: 18)),
                          ]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Address + payment
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: glassDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('Endereço de Entrega'),
                      const SizedBox(height: 8),
                      Text(order.address.formatted,
                          style: const TextStyle(color: kTextMuted, fontSize: 13, height: 1.5)),
                      const Divider(color: kBorder, height: 20),
                      _SectionTitle('Pagamento'),
                      const SizedBox(height: 8),
                      Row(children: [
                        Text(order.paymentMethod.icon),
                        const SizedBox(width: 8),
                        Text(order.paymentMethod.label,
                            style: const TextStyle(color: kTextMuted, fontSize: 13)),
                      ]),
                      if (order.estimatedDelivery != null) ...[
                        const Divider(color: kBorder, height: 20),
                        _SectionTitle('Previsão de Entrega'),
                        const SizedBox(height: 8),
                        Text(
                          '${order.estimatedDelivery!.day.toString().padLeft(2, '0')}/'
                          '${order.estimatedDelivery!.month.toString().padLeft(2, '0')}/'
                          '${order.estimatedDelivery!.year}',
                          style: const TextStyle(color: kGold, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/orders'),
                      icon: const Icon(Icons.receipt_long_outlined, size: 16),
                      label: const Text('Meus Pedidos'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/', (_) => false),
                      child: const Text('Continuar Comprando'),
                    ),
                  ),
                ]),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kTextMuted, fontSize: 13)),
          Text(value, style: const TextStyle(color: kText, fontSize: 13)),
        ],
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: kTextMuted, fontSize: 11, letterSpacing: 0.8, fontWeight: FontWeight.w600));
}
