import 'package:billing_system_application/stock_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test presence of table and floating action buttons', (WidgetTester tester) async {
    // Build the StockPage widget
    await tester.pumpWidget(MaterialApp(home: StockPage()));

    expect(find.byType(Table), findsOneWidget);

    expect(find.byType(FloatingActionButton), findsNWidgets(2));

    expect(find.byType(Dialog), findsNothing);

    await tester.tap(find.byTooltip('Add'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);

    //await tester.tap(find.);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
  });
}
