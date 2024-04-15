import 'package:billing_system_application/billing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Billing Page UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BillingPage(),
    ));

    expect(find.byType(TextFormField), findsOneWidget);

    expect(find.byType(Autocomplete<String>), findsOneWidget);

    expect(find.byType(FloatingActionButton), findsNWidgets(3));
  });
}
