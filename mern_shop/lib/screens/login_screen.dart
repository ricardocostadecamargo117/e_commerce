import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final err = context.read<AuthProvider>().login(
          _emailCtrl.text.trim(),
          _passCtrl.text,
        );
    setState(() { _loading = false; _error = err; });
    if (err == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Row(
        children: [
          // ── Left decorative panel (wide only) ─────────────────────
          if (MediaQuery.of(context).size.width > 800)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF130F04), kBg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: kGoldGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.diamond_outlined,
                          color: kBg, size: 44),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'MERN SHOP',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        color: kText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Moda de alto padrão',
                      style: TextStyle(color: kTextMuted, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

          // ── Right form panel ───────────────────────────────────────
          Expanded(
            child: Container(
              color: kBg,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamedAndRemoveUntil(
                                context, '/', (_) => false),
                            child: const Icon(Icons.arrow_back,
                                color: kTextMuted),
                          ),
                          const SizedBox(height: 32),
                          Text('Bem-vindo\nde volta.',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 36,
                                  color: kText,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1)),
                          const SizedBox(height: 8),
                          const Text('Entre na sua conta para continuar.',
                              style:
                                  TextStyle(color: kTextMuted, fontSize: 14)),
                          const SizedBox(height: 36),

                          if (_error != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kError.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: kError.withOpacity(0.4)),
                              ),
                              child: Row(children: [
                                const Icon(Icons.error_outline,
                                    color: kError, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(_error!,
                                        style: const TextStyle(
                                            color: kError, fontSize: 13))),
                              ]),
                            ),

                          // Email
                          const Text('E-mail',
                              style: TextStyle(
                                  color: kTextMuted,
                                  fontSize: 12,
                                  letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailCtrl,
                            style: const TextStyle(color: kText),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'seu@email.com',
                              prefixIcon: Icon(Icons.mail_outline,
                                  color: kTextFaint, size: 18),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Campo obrigatório';
                              if (!v.contains('@')) return 'E-mail inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password
                          const Text('Senha',
                              style: TextStyle(
                                  color: kTextMuted,
                                  fontSize: 12,
                                  letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            style: const TextStyle(color: kText),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: kTextFaint, size: 18),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: kTextFaint,
                                    size: 18),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Campo obrigatório'
                                : null,
                          ),
                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kGold,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: kBg))
                                  : const Text('Entrar'),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Não tem conta? ',
                                    style: TextStyle(
                                        color: kTextMuted, fontSize: 13)),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, '/register'),
                                  child: const Text('Cadastre-se',
                                      style: TextStyle(
                                          color: kGold,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                          const Divider(color: kBorder),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kSurface2,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: kBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Contas de demonstração:',
                                    style: TextStyle(
                                        color: kTextMuted, fontSize: 11)),
                                SizedBox(height: 4),
                                Text('Admin: admin@mernshop.com / admin123',
                                    style: TextStyle(
                                        color: kTextFaint, fontSize: 11)),
                                Text('Cliente: joao@email.com / 123456',
                                    style: TextStyle(
                                        color: kTextFaint, fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
