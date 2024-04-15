
import 'package:billing_system_application/user_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UserLoginPage UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: UserLoginPage(),
    ));

    expect(find.byType(TextFormField), findsNWidgets(2));

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    await tester.enterText(
        find.byType(TextFormField).first, 'user1@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password1');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

  });
}
