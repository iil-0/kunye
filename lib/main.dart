import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme.dart';

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
      initialRoute: AppRoutes.home,
      routes: AppRoutes.table,
    );
  }
}
