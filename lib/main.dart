import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme.dart';
import 'widgets/ambient_layer.dart';

void main() {
  runApp(const KunyeApp());
}

class KunyeApp extends StatelessWidget {
  const KunyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Künye',
      debugShowCheckedModeBanner: false,
      theme: buildKunyeTheme(),
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.table,
      // Gezgin kitap ve toz zerreleri tüm sayfaların üstünde yaşar.
      builder: (context, child) => AmbientLayer(child: child!),
    );
  }
}
