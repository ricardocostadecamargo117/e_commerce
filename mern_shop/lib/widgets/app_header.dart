import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';

class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController? searchController;
  final Function(String)? onSearch;

  const AppHeader({super.key, this.searchController, this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final isWide = MediaQuery.of(context).size.width > 600;

    return AppBar(
      backgroundColor: kPrimaryRed,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          // Brand name
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/', (route) => false),
            child: const Text(
              'MERN Shop',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (isWide) ...[
            const SizedBox(width: 20),
            // Search bar
            Expanded(
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: _controller,
                  onSubmitted: widget.onSearch,
                  decoration: InputDecoration(
                    hintText: 'Search Products...',
                    hintStyle:
                        const TextStyle(fontSize: 13, color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: SizedBox(
                      width: 70,
                      child: ElevatedButton(
                        onPressed: () =>
                            widget.onSearch?.call(_controller.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        child: const Text('Search',
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ] else
            const Spacer(),
          // Cart
          _HeaderIconButton(
            icon: Icons.shopping_cart_outlined,
            label: 'Cart',
            badge: cart.itemCount > 0 ? '${cart.itemCount}' : null,
            onTap: () => Navigator.pushNamed(context, '/cart'),
          ),
          const SizedBox(width: 8),
          // Auth area
          if (auth.isLoggedIn)
            _UserMenu(userName: auth.userName)
          else
            _HeaderIconButton(
              icon: Icons.person_outline,
              label: 'Sign In',
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              if (badge != null)
                Positioned(
                  top: -6,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                          fontSize: 10,
                          color: kPrimaryRed,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

class _UserMenu extends StatelessWidget {
  final String userName;
  const _UserMenu({required this.userName});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          auth.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      offset: const Offset(0, 40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person, color: Colors.white, size: 20),
          const SizedBox(width: 4),
          Text(
            userName,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Text('Olá, $userName',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: kPrimaryRed)),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'profile',
          child: Row(children: [
            Icon(Icons.person_outline, size: 18),
            SizedBox(width: 8),
            Text('Meu Perfil'),
          ]),
        ),
        const PopupMenuItem(
          value: 'orders',
          child: Row(children: [
            Icon(Icons.receipt_long_outlined, size: 18),
            SizedBox(width: 8),
            Text('Meus Pedidos'),
          ]),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(children: [
            Icon(Icons.logout, size: 18, color: kPrimaryRed),
            SizedBox(width: 8),
            Text('Sair', style: TextStyle(color: kPrimaryRed)),
          ]),
        ),
      ],
    );
  }
}
