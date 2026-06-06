import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/product_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_success_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin/admin_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MernShopApp(),
    ),
  );
}

class MernShopApp extends StatelessWidget {
  const MernShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MERN Shop',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/',
      routes: {
        '/':              (_) => const HomeScreen(),
        '/login':         (_) => const LoginScreen(),
        '/register':      (_) => const RegisterScreen(),
        '/product':       (_) => const ProductScreen(),
        '/cart':          (_) => const CartScreen(),
        '/order-success': (_) => const OrderSuccessScreen(),
        '/orders':        (_) => const OrdersScreen(),
        '/profile':       (_) => const ProfileScreen(),
        '/admin':         (_) => const AdminScreen(),
      },
    );
  }
}
