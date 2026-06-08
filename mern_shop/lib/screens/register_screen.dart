import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (!_acceptedTerms) {
      setState(() => _error = 'Aceite os termos para continuar.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final err = await context.read<AuthProvider>().register(
          _nameCtrl.text.trim(),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (_) => false),
                          child: const Icon(Icons.arrow_back,
                              color: kTextMuted),
                        ),
                        const SizedBox(height: 32),
                        Text('Criar sua\nconta.',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 36,
                                color: kText,
                                fontWeight: FontWeight.w700,
                                height: 1.1)),
                        const SizedBox(height: 8),
                        const Text(
                            'Junte-se à nossa comunidade exclusiva.',
                            style: TextStyle(
                                color: kTextMuted, fontSize: 14)),
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

                        _FieldLabel('Nome completo'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameCtrl,
                          style: const TextStyle(color: kText),
                          decoration: const InputDecoration(
                            hintText: 'Seu nome',
                            prefixIcon: Icon(Icons.person_outline,
                                color: kTextFaint, size: 18),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Campo obrigatório'
                              : null,
                        ),
                        const SizedBox(height: 18),

                        _FieldLabel('E-mail'),
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
                        const SizedBox(height: 18),

                        _FieldLabel('Senha'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscurePass,
                          style: const TextStyle(color: kText),
                          decoration: InputDecoration(
                            hintText: 'Mínimo 6 caracteres',
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: kTextFaint, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscurePass
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kTextFaint,
                                  size: 18),
                              onPressed: () => setState(
                                  () => _obscurePass = !_obscurePass),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Campo obrigatório';
                            if (v.length < 6)
                              return 'Mínimo 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        _FieldLabel('Confirmar senha'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: _obscureConfirm,
                          style: const TextStyle(color: kText),
                          decoration: InputDecoration(
                            hintText: 'Repita a senha',
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: kTextFaint, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kTextFaint,
                                  size: 18),
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Campo obrigatório';
                            if (v != _passCtrl.text)
                              return 'Senhas não coincidem';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Terms checkbox
                        Row(children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _acceptedTerms,
                              onChanged: (v) =>
                                  setState(() => _acceptedTerms = v ?? false),
                              activeColor: kGold,
                              checkColor: kBg,
                              side: const BorderSide(color: kBorder),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text.rich(TextSpan(children: [
                              const TextSpan(
                                  text: 'Concordo com os ',
                                  style: TextStyle(
                                      color: kTextMuted, fontSize: 12)),
                              TextSpan(
                                  text: 'Termos de Uso',
                                  style: const TextStyle(
                                      color: kGold, fontSize: 12)),
                              const TextSpan(
                                  text: ' e ',
                                  style: TextStyle(
                                      color: kTextMuted, fontSize: 12)),
                              TextSpan(
                                  text: 'Política de Privacidade',
                                  style: const TextStyle(
                                      color: kGold, fontSize: 12)),
                            ])),
                          ),
                        ]),
                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: kBg))
                                : const Text('Criar conta'),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Já tem conta? ',
                                  style: TextStyle(
                                      color: kTextMuted, fontSize: 13)),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushReplacementNamed(
                                        context, '/login'),
                                child: const Text('Entrar',
                                    style: TextStyle(
                                        color: kGold,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: kTextMuted, fontSize: 12, letterSpacing: 0.5));
}
