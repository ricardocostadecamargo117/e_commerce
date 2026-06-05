import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/product_screen.dart';
import 'screens/cart_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
      title: 'FERN Shop',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/product': (context) => const ProductScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
