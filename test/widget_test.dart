// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hafiz_test/main.dart';
import 'package:hafiz_test/splash_screen.dart';

void main() {
  testWidgets('Smoke test: SplashScreen renders', (WidgetTester tester) async {
    // If your SplashScreen or its children use GetIt, ensure locator is initialized
    // or register test doubles here using get_it + mocktail.
    await tester.pumpWidget(const MaterialApp(home: Hafiz()));
    await tester.pump(); // allow one frame

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
