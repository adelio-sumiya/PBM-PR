import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pbm_app/screens/login_screen.dart';

void main() {
  testWidgets('Login screen shows required fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
