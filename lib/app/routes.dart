import 'package:flutter/material.dart';

import '../screens/book_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';

/// Tüm sayfa adresleri tek yerde. Yeni sayfa = yeni sabit + tabloya bir satır.
abstract final class AppRoutes {
  static const home = '/';
  static const detail = '/detail';
  static const cart = '/cart';

  static Map<String, WidgetBuilder> get table => {
        home: (context) => const HomeScreen(),
        detail: (context) => const BookDetailScreen(),
        cart: (context) => const CartScreen(),
      };
}
