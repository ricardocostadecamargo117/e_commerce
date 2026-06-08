import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/app_header.dart';
import '../theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _step = 0; // 0=cart, 1=address, 2=payment, 3=confirm
  PaymentMethod _paymentMethod = PaymentMethod.creditCard;

  // Address form
  final _addressForm = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'João Silva');
  final _streetCtrl = TextEditingController(text: 'Rua das Flores');
  final _numberCtrl = TextEditingController(text: '123');
  final _complementCtrl = TextEditingController(text: 'Apto 4B');
  final _neighborhoodCtrl = TextEditingController(text: 'Centro');
  final _cityCtrl = TextEditingController(text: 'São Paulo');
  final _stateCtrl = TextEditingController(text: 'SP');
  final _zipCtrl = TextEditingController(text: '01310-100');

  // Payment form
  final _cardNumberCtrl =
      TextEditingController(text: '•••• •••• •••• 4242');
  final _cardNameCtrl = TextEditingController(text: 'JOAO SILVA');
  final _cardExpiryCtrl = TextEditingController(text: '12/26');
  final _cardCvvCtrl = TextEditingController(text: '•••');

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _streetCtrl, _numberCtrl, _complementCtrl,
      _neighborhoodCtrl, _cityCtrl, _stateCtrl, _zipCtrl,
      _cardNumberCtrl, _cardNameCtrl, _cardExpiryCtrl, _cardCvvCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: kBg,
      appBar: const AppHeader(),
      body: cart.items.isEmpty && _step == 0
          ? _EmptyCart()
          : Column(
              children: [
                _StepIndicator(currentStep: _step),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(builder: (context, constraints) {
                      final wide = constraints.maxWidth > 800;
                      return wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: _StepContent(
                                        step: _step,
                                        paymentMethod: _paymentMethod,
                                        addressForm: _addressForm,
                                        nameCtrl: _nameCtrl,
                                        streetCtrl: _streetCtrl,
                                        numberCtrl: _numberCtrl,
                                        complementCtrl: _complementCtrl,
                                        neighborhoodCtrl: _neighborhoodCtrl,
                                        cityCtrl: _cityCtrl,
                                        stateCtrl: _stateCtrl,
                                        zipCtrl: _zipCtrl,
                                        cardNumberCtrl: _cardNumberCtrl,
                                        cardNameCtrl: _cardNameCtrl,
                                        cardExpiryCtrl: _cardExpiryCtrl,
                                        cardCvvCtrl: _cardCvvCtrl,
                                        onPaymentMethodChange: (v) => setState(
                                            () => _paymentMethod = v))),
                                const SizedBox(width: 24),
                                SizedBox(
                                  width: 320,
                                  child: _OrderSummaryPanel(
                                    step: _step,
                                    cart: cart,
                                    auth: auth,
                                    paymentMethod: _paymentMethod,
                                    onNext: _next,
                                    onBack: _step > 0 ? _back : null,
                                    addressData: _addressData,
                                  ),
                                ),
                              ],
                            )
                          : Column(children: [
                              _StepContent(
                                  step: _step,
                                  paymentMethod: _paymentMethod,
                                  addressForm: _addressForm,
                                  nameCtrl: _nameCtrl,
                                  streetCtrl: _streetCtrl,
                                  numberCtrl: _numberCtrl,
                                  complementCtrl: _complementCtrl,
                                  neighborhoodCtrl: _neighborhoodCtrl,
                                  cityCtrl: _cityCtrl,
                                  stateCtrl: _stateCtrl,
                                  zipCtrl: _zipCtrl,
                                  cardNumberCtrl: _cardNumberCtrl,
                                  cardNameCtrl: _cardNameCtrl,
                                  cardExpiryCtrl: _cardExpiryCtrl,
                                  cardCvvCtrl: _cardCvvCtrl,
                                  onPaymentMethodChange: (v) =>
                                      setState(() => _paymentMethod = v)),
                              const SizedBox(height: 20),
                              _OrderSummaryPanel(
                                step: _step,
                                cart: cart,
                                auth: auth,
                                paymentMethod: _paymentMethod,
                                onNext: _next,
                                onBack: _step > 0 ? _back : null,
                                addressData: _addressData,
                              ),
                            ]);
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  ShippingAddress get _addressData => ShippingAddress(
        fullName: _nameCtrl.text,
        street: _streetCtrl.text,
        number: _numberCtrl.text,
        complement: _complementCtrl.text,
        neighborhood: _neighborhoodCtrl.text,
        city: _cityCtrl.text,
        state: _stateCtrl.text,
        zipCode: _zipCtrl.text,
      );

  void _next() async {
    if (_step == 1 && !_addressForm.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    if (_step == 2) {
      // Place order
      if (!auth.isLoggedIn) {
        Navigator.pushNamed(context, '/login');
        return;
      }
      final order = await context.read<OrderProvider>().placeOrder(
  cartItems: cart.items.toList(),
  address: _addressData,
  paymentMethod: _paymentMethod,
  subtotal: cart.subtotal,
  shippingCost: cart.shippingCost,
  tax: cart.tax,
);

if (order == null) {
  // Mostrar erro
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(context.read<OrderProvider>().error ?? 'Erro ao criar pedido')),
  );
  return;
}
      cart.clear();
      Navigator.pushReplacementNamed(context, '/order-success',
          arguments: order);
      return;
    }

    if (_step == 0 && !auth.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    setState(() => _step++);
  }

  void _back() => setState(() => _step--);
}

// ─── Step Indicator ───────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  static const _labels = ['Carrinho', 'Endereço', 'Pagamento'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorder, width: 0.5))),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
                child: Container(
                    height: 1,
                    color: currentStep > i ~/ 2 + 1 ? kGold : kBorder));
          }
          final idx = i ~/ 2;
          final done = currentStep > idx;
          final active = currentStep == idx;
          return Row(mainAxisSize: MainAxisSize.min, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? kGold
                    : active
                        ? kGold.withOpacity(0.2)
                        : kSurface2,
                border: Border.all(
                    color: done || active ? kGold : kBorder, width: 1),
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check, size: 14, color: kBg)
                    : Text('${idx + 1}',
                        style: TextStyle(
                            fontSize: 12,
                            color: active ? kGold : kTextFaint,
                            fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 6),
            Text(_labels[idx],
                style: TextStyle(
                    fontSize: 12,
                    color: done || active ? kText : kTextFaint,
                    fontWeight:
                        active ? FontWeight.w600 : FontWeight.normal)),
          ]);
        }),
      ),
    );
  }
}

// ─── Step Content ─────────────────────────────────────────────────────────────
class _StepContent extends StatelessWidget {
  final int step;
  final PaymentMethod paymentMethod;
  final GlobalKey<FormState> addressForm;
  final TextEditingController nameCtrl, streetCtrl, numberCtrl,
      complementCtrl, neighborhoodCtrl, cityCtrl, stateCtrl, zipCtrl;
  final TextEditingController cardNumberCtrl, cardNameCtrl,
      cardExpiryCtrl, cardCvvCtrl;
  final ValueChanged<PaymentMethod> onPaymentMethodChange;

  const _StepContent({
    required this.step,
    required this.paymentMethod,
    required this.addressForm,
    required this.nameCtrl, required this.streetCtrl, required this.numberCtrl,
    required this.complementCtrl, required this.neighborhoodCtrl,
    required this.cityCtrl, required this.stateCtrl, required this.zipCtrl,
    required this.cardNumberCtrl, required this.cardNameCtrl,
    required this.cardExpiryCtrl, required this.cardCvvCtrl,
    required this.onPaymentMethodChange,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    switch (step) {
      case 0: return _CartItemsList(cart: cart);
      case 1: return _AddressForm(
          formKey: addressForm, nameCtrl: nameCtrl, streetCtrl: streetCtrl,
          numberCtrl: numberCtrl, complementCtrl: complementCtrl,
          neighborhoodCtrl: neighborhoodCtrl, cityCtrl: cityCtrl,
          stateCtrl: stateCtrl, zipCtrl: zipCtrl);
      case 2: return _PaymentForm(
          method: paymentMethod, onMethodChange: onPaymentMethodChange,
          cardNumberCtrl: cardNumberCtrl, cardNameCtrl: cardNameCtrl,
          cardExpiryCtrl: cardExpiryCtrl, cardCvvCtrl: cardCvvCtrl);
      default: return const SizedBox();
    }
  }
}

// ─── Cart Items List ──────────────────────────────────────────────────────────
class _CartItemsList extends StatelessWidget {
  final CartProvider cart;
  const _CartItemsList({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meu Carrinho',
            style: GoogleFonts.playfairDisplay(
                fontSize: 22, color: kText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        ...cart.items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: glassDecoration(),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.network(item.product.image,
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
                      Text(item.product.name,
                          style: const TextStyle(
                              color: kText,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                          'R\$ ${item.product.price.toStringAsFixed(2)} cada',
                          style: const TextStyle(
                              color: kTextMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kSurface2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kBorder),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      _QtyBtn(
                          icon: Icons.remove,
                          onTap: () => context
                              .read<CartProvider>()
                              .decrement(item.product.id)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('${item.quantity}',
                            style: const TextStyle(
                                color: kText, fontWeight: FontWeight.w600)),
                      ),
                      _QtyBtn(
                          icon: Icons.add,
                          onTap: () => context
                              .read<CartProvider>()
                              .increment(item.product.id)),
                    ]),
                  ),
                  const SizedBox(height: 6),
                  Row(children: [
                    Text('R\$ ${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: kGold, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => context
                          .read<CartProvider>()
                          .removeItem(item.product.id),
                      child: const Icon(Icons.delete_outline,
                          color: kError, size: 16),
                    ),
                  ]),
                ]),
              ]),
            )),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 14, color: kTextMuted),
        ),
      );
}

// ─── Address Form ─────────────────────────────────────────────────────────────
class _AddressForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, streetCtrl, numberCtrl,
      complementCtrl, neighborhoodCtrl, cityCtrl, stateCtrl, zipCtrl;

  const _AddressForm({
    required this.formKey, required this.nameCtrl, required this.streetCtrl,
    required this.numberCtrl, required this.complementCtrl,
    required this.neighborhoodCtrl, required this.cityCtrl,
    required this.stateCtrl, required this.zipCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Endereço de Entrega',
            style: GoogleFonts.playfairDisplay(
                fontSize: 22, color: kText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        _formField('Nome completo', nameCtrl, required: true),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(flex: 3, child: _formField('CEP', zipCtrl, required: true)),
          const SizedBox(width: 12),
          Expanded(flex: 4, child: _formField('Cidade', cityCtrl, required: true)),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _formField('UF', stateCtrl, required: true, maxLength: 2)),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(flex: 4, child: _formField('Rua/Avenida', streetCtrl, required: true)),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _formField('Número', numberCtrl, required: true)),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _formField('Complemento', complementCtrl)),
          const SizedBox(width: 12),
          Expanded(child: _formField('Bairro', neighborhoodCtrl, required: true)),
        ]),
      ]),
    );
  }

  Widget _formField(String label, TextEditingController ctrl,
      {bool required = false, int? maxLength}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: kTextMuted, fontSize: 12)),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        maxLength: maxLength,
        style: const TextStyle(color: kText, fontSize: 13),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        validator: required
            ? (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null
            : null,
      ),
    ]);
  }
}

// ─── Payment Form ─────────────────────────────────────────────────────────────
class _PaymentForm extends StatelessWidget {
  final PaymentMethod method;
  final ValueChanged<PaymentMethod> onMethodChange;
  final TextEditingController cardNumberCtrl, cardNameCtrl,
      cardExpiryCtrl, cardCvvCtrl;

  const _PaymentForm({
    required this.method, required this.onMethodChange,
    required this.cardNumberCtrl, required this.cardNameCtrl,
    required this.cardExpiryCtrl, required this.cardCvvCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Forma de Pagamento',
          style: GoogleFonts.playfairDisplay(
              fontSize: 22, color: kText, fontWeight: FontWeight.w600)),
      const SizedBox(height: 20),

      // Payment methods
      ...PaymentMethod.values.map((pm) => GestureDetector(
            onTap: () => onMethodChange(pm),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: method == pm
                    ? kGold.withOpacity(0.08)
                    : kSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: method == pm ? kGold : kBorder,
                    width: method == pm ? 1.5 : 0.5),
              ),
              child: Row(children: [
                Text(pm.icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Text(pm.label,
                    style: TextStyle(
                        color: method == pm ? kGold : kText,
                        fontWeight: method == pm
                            ? FontWeight.w600
                            : FontWeight.normal)),
                const Spacer(),
                if (method == pm)
                  const Icon(Icons.check_circle, color: kGold, size: 18),
              ]),
            ),
          )),

      // Card details
      if (method == PaymentMethod.creditCard ||
          method == PaymentMethod.debitCard) ...[
        const SizedBox(height: 20),
        // Card preview
        Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1508), Color(0xFF2A1F08)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kGold.withOpacity(0.3)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.credit_card, color: kGold, size: 28),
              Spacer(),
              Text('VISA', style: TextStyle(color: kGold, fontSize: 18, fontWeight: FontWeight.w800)),
            ]),
            const Spacer(),
            Text(cardNumberCtrl.text,
                style: const TextStyle(color: kText, fontSize: 16, letterSpacing: 2)),
            const SizedBox(height: 8),
            Row(children: [
              Text(cardNameCtrl.text,
                  style: const TextStyle(color: kTextMuted, fontSize: 12)),
              const Spacer(),
              Text(cardExpiryCtrl.text,
                  style: const TextStyle(color: kTextMuted, fontSize: 12)),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        _cardField('Número do cartão', cardNumberCtrl),
        const SizedBox(height: 12),
        _cardField('Nome no cartão', cardNameCtrl),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _cardField('Validade', cardExpiryCtrl)),
          const SizedBox(width: 12),
          Expanded(child: _cardField('CVV', cardCvvCtrl, obscure: true)),
        ]),
        const SizedBox(height: 12),
        if (method == PaymentMethod.creditCard)
          DropdownButtonFormField<int>(
            value: 1,
            dropdownColor: kSurface2,
            style: const TextStyle(color: kText, fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Parcelas',
              labelStyle: TextStyle(color: kTextMuted),
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            items: List.generate(
                12,
                (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text(i == 0
                          ? '1x à vista'
                          : '${i + 1}x sem juros'),
                    )),
            onChanged: (_) {},
          ),
      ],

      if (method == PaymentMethod.pix) ...[
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kSurface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
          ),
          child: Column(children: [
            const Icon(Icons.qr_code_2, color: kGold, size: 80),
            const SizedBox(height: 12),
            const Text('QR Code Pix',
                style: TextStyle(color: kText, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('O QR Code será gerado após confirmar o pedido.',
                textAlign: TextAlign.center,
                style: TextStyle(color: kTextMuted, fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kGold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '⚡ Aprovação em segundos',
                style: TextStyle(color: kGold, fontSize: 12),
              ),
            ),
          ]),
        ),
      ],

      if (method == PaymentMethod.boleto) ...[
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kSurface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.receipt_long_outlined, color: kGold),
                SizedBox(width: 8),
                Text('Boleto Bancário',
                    style: TextStyle(
                        color: kText, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 12),
              const Text(
                  '• Vencimento em 3 dias úteis\n'
                  '• Pagamento confirmado em até 2 dias úteis\n'
                  '• O boleto será enviado para seu e-mail',
                  style: TextStyle(color: kTextMuted, fontSize: 12, height: 1.8)),
            ],
          ),
        ),
      ],
    ]);
  }

  Widget _cardField(String label, TextEditingController ctrl,
      {bool obscure = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(color: kText, fontSize: 13),
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    ]);
  }
}

// ─── Order Summary Panel ──────────────────────────────────────────────────────
class _OrderSummaryPanel extends StatelessWidget {
  final int step;
  final CartProvider cart;
  final AuthProvider auth;
  final PaymentMethod paymentMethod;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final ShippingAddress addressData;

  const _OrderSummaryPanel({
    required this.step, required this.cart, required this.auth,
    required this.paymentMethod, required this.onNext, this.onBack,
    required this.addressData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: glassDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Resumo',
            style: TextStyle(
                color: kText, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),

        // Items
        ...cart.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Expanded(
                  child: Text('${item.product.name} ×${item.quantity}',
                      style: const TextStyle(
                          color: kTextMuted, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Text('R\$ ${item.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: kText, fontSize: 12)),
              ]),
            )),

        const Divider(color: kBorder, height: 24),
        _SummaryRow('Subtotal',
            'R\$ ${cart.subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _SummaryRow(
          'Frete',
          cart.shippingCost == 0
              ? 'Grátis'
              : 'R\$ ${cart.shippingCost.toStringAsFixed(2)}',
          valueColor:
              cart.shippingCost == 0 ? kSuccess : null,
        ),
        const SizedBox(height: 8),
        _SummaryRow('Impostos (6%)',
            'R\$ ${cart.tax.toStringAsFixed(2)}'),
        const Divider(color: kBorder, height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                style: TextStyle(
                    color: kText, fontWeight: FontWeight.w700, fontSize: 15)),
            Text('R\$ ${cart.total.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: kGold,
                    fontWeight: FontWeight.w800,
                    fontSize: 20)),
          ],
        ),
        const SizedBox(height: 20),

        // Action buttons
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onNext,
            child: Text(step == 2 ? 'Finalizar Pedido' : 'Continuar'),
          ),
        ),
        if (onBack != null) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextButton(
              onPressed: onBack,
              child: const Text('Voltar',
                  style: TextStyle(color: kTextMuted)),
            ),
          ),
        ],

        const SizedBox(height: 16),
        const Row(children: [
          Icon(Icons.lock_outline, color: kTextFaint, size: 14),
          SizedBox(width: 6),
          Text('Compra 100% segura',
              style: TextStyle(color: kTextFaint, fontSize: 11)),
        ]),
      ]),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: kTextMuted, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? kText, fontSize: 13)),
        ],
      );
}

// ─── Empty Cart ───────────────────────────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 80, color: kTextFaint),
          const SizedBox(height: 16),
          const Text('Seu carrinho está vazio',
              style: TextStyle(color: kTextMuted, fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/', (_) => false),
            child: const Text('Explorar Produtos'),
          ),
        ]),
      );
}
