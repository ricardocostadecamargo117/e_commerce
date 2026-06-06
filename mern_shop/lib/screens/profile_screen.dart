import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/user_avatar.dart';
import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _bioCtrl;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user!;
    _nameCtrl  = TextEditingController(text: user.name);
    _phoneCtrl = TextEditingController(text: user.phone ?? '');
    _bioCtrl   = TextEditingController(text: user.bio ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      context.read<AuthProvider>().updateProfile(avatarPath: picked.path);
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    context.read<AuthProvider>().updateProfile(
          name:  _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          bio:   _bioCtrl.text.trim(),
        );
    setState(() { _saving = false; _editing = false; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil atualizado com sucesso!'),
        backgroundColor: kSuccess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth   = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>().ordersForUser(auth.user!.id);

    if (!auth.isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      return const SizedBox();
    }

    final user = auth.user!;

    return Scaffold(
      backgroundColor: kBg,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile Hero ───────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: glassDecoration(radius: 20),
                  child: Column(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          UserAvatar(
                            name: user.name,
                            avatarPath: auth.avatarLocalPath,
                            radius: 48,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAvatar,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  gradient: kGoldGradient,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kBg, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    size: 14, color: kBg),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(user.name,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              color: kText,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(user.email,
                          style: const TextStyle(
                              color: kTextMuted, fontSize: 13)),
                      if (user.isAdmin) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: kAdminAccent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: kAdminAccent.withOpacity(0.4)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.admin_panel_settings_outlined,
                                  color: kAdminAccent, size: 14),
                              SizedBox(width: 6),
                              Text('Administrador',
                                  style: TextStyle(
                                      color: kAdminAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatChip(
                              label: 'Pedidos',
                              value: '${orders.length}',
                              icon: Icons.receipt_long_outlined),
                          const SizedBox(width: 12),
                          _StatChip(
                              label: 'Total gasto',
                              value: orders.isEmpty
                                  ? 'R\$ 0,00'
                                  : 'R\$ ${orders.fold(0.0, (s, o) => s + o.total).toStringAsFixed(2)}',
                              icon: Icons.payments_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Edit Form ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: glassDecoration(radius: 20),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text('Dados Pessoais',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  color: kText,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          if (!_editing)
                            TextButton.icon(
                              onPressed: () =>
                                  setState(() => _editing = true),
                              icon: const Icon(Icons.edit_outlined,
                                  size: 16),
                              label: const Text('Editar'),
                            )
                          else
                            TextButton(
                              onPressed: () =>
                                  setState(() => _editing = false),
                              child: const Text('Cancelar',
                                  style:
                                      TextStyle(color: kTextMuted)),
                            ),
                        ]),
                        const SizedBox(height: 20),

                        _ProfileField(
                          label: 'Nome completo',
                          controller: _nameCtrl,
                          enabled: _editing,
                          icon: Icons.person_outline,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Obrigatório' : null,
                        ),
                        const SizedBox(height: 16),
                        _ProfileField(
                          label: 'E-mail',
                          controller: TextEditingController(text: user.email),
                          enabled: false,
                          icon: Icons.mail_outline,
                          hint: 'Não é possível alterar o e-mail',
                        ),
                        const SizedBox(height: 16),
                        _ProfileField(
                          label: 'Telefone',
                          controller: _phoneCtrl,
                          enabled: _editing,
                          icon: Icons.phone_outlined,
                          hint: '+55 11 99999-9999',
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bio',
                                style: TextStyle(
                                    color: kTextMuted,
                                    fontSize: 12,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _bioCtrl,
                              enabled: _editing,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: kText, fontSize: 13),
                              decoration: const InputDecoration(
                                hintText: 'Conte um pouco sobre você...',
                              ),
                            ),
                          ],
                        ),

                        if (_editing) ...[
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _saving ? null : _save,
                              child: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: kBg))
                                  : const Text('Salvar Alterações'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Quick links ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: glassDecoration(radius: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Acesso Rápido',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              color: kText,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      _QuickLink(
                        icon: Icons.receipt_long_outlined,
                        label: 'Meus Pedidos',
                        subtitle: '${orders.length} pedido(s)',
                        onTap: () =>
                            Navigator.pushNamed(context, '/orders'),
                      ),
                      if (auth.isAdmin)
                        _QuickLink(
                          icon: Icons.admin_panel_settings_outlined,
                          label: 'Painel Admin',
                          subtitle: 'Gerenciar produtos e pedidos',
                          iconColor: kAdminAccent,
                          onTap: () =>
                              Navigator.pushNamed(context, '/admin'),
                        ),
                      _QuickLink(
                        icon: Icons.logout,
                        label: 'Sair da conta',
                        subtitle: 'Encerrar sessão',
                        iconColor: kError,
                        onTap: () {
                          auth.logout();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (_) => false);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatChip(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: kSurface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: kGold, size: 16),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
                style: const TextStyle(
                    color: kText, fontWeight: FontWeight.w700, fontSize: 14)),
            Text(label,
                style:
                    const TextStyle(color: kTextFaint, fontSize: 10)),
          ]),
        ]),
      );
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final IconData icon;
  final String? hint;
  final FormFieldValidator<String>? validator;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.icon,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: kTextMuted, fontSize: 12, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: enabled,
            style: const TextStyle(color: kText, fontSize: 13),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: kTextFaint, size: 18),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: kBorder.withOpacity(0.4)),
              ),
              fillColor: enabled ? kSurface2 : kSurface,
            ),
          ),
        ],
      );
}

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;

  const _QuickLink({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.iconColor = kGold,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kBorder, width: 0.5))),
          child: Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: kText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: kTextFaint, fontSize: 11)),
                  ]),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: kTextFaint, size: 14),
          ]),
        ),
      );
}
