import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';
import 'user_avatar.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearch;

  const AppHeader({super.key, this.searchController, this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final wide = MediaQuery.of(context).size.width > 680;

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: kBg,
        border: Border(bottom: BorderSide(color: kBorder, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // ── Brand ────────────────────────────────────────────────────────
          GestureDetector(
            onTap: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
            child: Row(children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: kGoldGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.diamond_outlined,
                    color: kBg, size: 18),
              ),
              const SizedBox(width: 10),
              if (wide)
                const Text(
                  'MERN SHOP',
                  style: TextStyle(
                    color: kText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
            ]),
          ),

          // ── Search ───────────────────────────────────────────────────────
          if (wide) ...[
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: kSurface2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kBorder),
                ),
                child: TextField(
                  controller: searchController,
                  onSubmitted: onSearch,
                  style: const TextStyle(color: kText, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar produtos...',
                    hintStyle:
                        const TextStyle(color: kTextFaint, fontSize: 13),
                    prefixIcon: const Icon(Icons.search,
                        color: kTextFaint, size: 18),
                    suffixIcon: searchController != null &&
                            (searchController?.text.isNotEmpty ?? false)
                        ? GestureDetector(
                            onTap: () {
                              searchController?.clear();
                              onSearch?.call('');
                            },
                            child: const Icon(Icons.close,
                                color: kTextFaint, size: 16),
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ] else
            const Spacer(),

          // ── Cart ─────────────────────────────────────────────────────────
          _HeaderButton(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined,
                    color: kText, size: 22),
                if (cart.itemCount > 0)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: kGold, shape: BoxShape.circle),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                            fontSize: 9,
                            color: kBg,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // ── Auth ─────────────────────────────────────────────────────────
          if (auth.isLoggedIn)
            _UserDropdown(auth: auth)
          else ...[
            _HeaderButton(
              onTap: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Entrar',
                  style: TextStyle(color: kText, fontSize: 13)),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/register'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  gradient: kGoldGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Cadastrar',
                    style: TextStyle(
                        color: kBg,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _HeaderButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: child,
        ),
      );
}

class _UserDropdown extends StatelessWidget {
  final AuthProvider auth;
  const _UserDropdown({required this.auth});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (v) {
        switch (v) {
          case 'profile':
            Navigator.pushNamed(context, '/profile');
            break;
          case 'orders':
            Navigator.pushNamed(context, '/orders');
            break;
          case 'admin':
            Navigator.pushNamed(context, '/admin');
            break;
          case 'logout':
            auth.logout();
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            break;
        }
      },
      color: kSurface2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: kBorder),
      ),
      offset: const Offset(0, 48),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(
            name: auth.user!.name,
            avatarPath: auth.avatarLocalPath,
            radius: 16,
          ),
          const SizedBox(width: 8),
          Text(
            auth.user!.name.split(' ').first,
            style: const TextStyle(color: kText, fontSize: 13),
          ),
          const Icon(Icons.expand_more, color: kTextMuted, size: 16),
        ],
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(auth.user!.name,
                style: const TextStyle(
                    color: kText, fontWeight: FontWeight.w600, fontSize: 14)),
            Text(auth.user!.email,
                style: const TextStyle(color: kTextMuted, fontSize: 12)),
          ]),
        ),
        const PopupMenuDivider(),
        if (auth.isAdmin)
          const PopupMenuItem(
            value: 'admin',
            child: _MenuItem(icon: Icons.admin_panel_settings_outlined,
                label: 'Painel Admin', color: kAdminAccent),
          ),
        const PopupMenuItem(
          value: 'profile',
          child: _MenuItem(icon: Icons.person_outline, label: 'Meu Perfil'),
        ),
        const PopupMenuItem(
          value: 'orders',
          child: _MenuItem(icon: Icons.receipt_long_outlined, label: 'Meus Pedidos'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: _MenuItem(icon: Icons.logout, label: 'Sair', color: kError),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MenuItem(
      {required this.icon, required this.label, this.color = kText});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontSize: 13)),
      ]);
}
