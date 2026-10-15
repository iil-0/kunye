import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('Ana sayfada uygulama adı görünür', (WidgetTester tester) async {
    await tester.pumpWidget(const KunyeApp());
    expect(find.text('Künye'), findsOneWidget);
  });
}
