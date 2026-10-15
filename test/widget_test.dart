import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('Uygulama karşılama ekranıyla açılır', (WidgetTester tester) async {
    await tester.pumpWidget(const KunyeApp());
    expect(find.text('Künye'), findsOneWidget);
    expect(find.text('Raflara Gir'), findsOneWidget);
  });

  testWidgets('"Raflara Gir" ile raflara geçilir', (WidgetTester tester) async {
    await tester.pumpWidget(const KunyeApp());
    await tester.pump(const Duration(seconds: 4));
    await tester.tap(find.text('Raflara Gir'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('SAHAF'), findsOneWidget);
    // Gezgin kitap raflarda da dolaşmaya devam eder
    expect(find.byIcon(Icons.auto_stories), findsOneWidget);
  });

  testWidgets('Gezgin kitaba dokununca bir dize belirir', (WidgetTester tester) async {
    await tester.pumpWidget(const KunyeApp());
    await tester.tap(find.byIcon(Icons.auto_stories));
    await tester.pump();
    expect(find.textContaining('— '), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.textContaining('— '), findsNothing);
  });
}
