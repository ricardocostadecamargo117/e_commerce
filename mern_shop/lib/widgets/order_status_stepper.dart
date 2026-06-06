import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme.dart';

class OrderStatusStepper extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusStepper({super.key, required this.status});

  static const _steps = [
    (OrderStatus.confirmed,   'Confirmado',   Icons.check_circle_outline),
    (OrderStatus.processing,  'Preparando',   Icons.inventory_2_outlined),
    (OrderStatus.shipped,     'Enviado',      Icons.local_shipping_outlined),
    (OrderStatus.delivered,   'Entregue',     Icons.home_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kError.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kError.withOpacity(0.3)),
        ),
        child: const Row(children: [
          Icon(Icons.cancel_outlined, color: kError),
          SizedBox(width: 10),
          Text('Pedido Cancelado',
              style: TextStyle(color: kError, fontWeight: FontWeight.w600)),
        ]),
      );
    }

    if (status == OrderStatus.pending) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kGold.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kGold.withOpacity(0.3)),
        ),
        child: const Row(children: [
          Icon(Icons.hourglass_top_rounded, color: kGold),
          SizedBox(width: 10),
          Text('Aguardando Pagamento',
              style: TextStyle(color: kGold, fontWeight: FontWeight.w600)),
        ]),
      );
    }

    final currentStep = status.step;

    return Row(
      children: List.generate(_steps.length * 2 - 1, (idx) {
        if (idx.isOdd) {
          // Connector line
          final stepIdx = idx ~/ 2;
          final done = currentStep > stepIdx + 1;
          return Expanded(
            child: Container(
              height: 2,
              color: done ? kGold : kBorder,
            ),
          );
        }
        final stepIdx = idx ~/ 2;
        final (stepStatus, label, icon) = _steps[stepIdx];
        final done = currentStep >= stepStatus.step;
        final active = currentStep == stepStatus.step;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? kGold : kSurface2,
                border: Border.all(
                    color: done ? kGold : kBorder,
                    width: active ? 2 : 1),
              ),
              child: Icon(icon,
                  size: 16,
                  color: done ? kBg : (active ? kGold : kTextFaint)),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active || done
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: done ? kGold : (active ? kText : kTextFaint),
              ),
            ),
          ],
        );
      }),
    );
  }
}
