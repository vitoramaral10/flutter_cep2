// This is a basic Flutter widget test for the flutter_cep2 example app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_cep2_example/main.dart';

void main() {
  testWidgets('Flutter CEP2 Example App smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads with the correct title
    expect(find.text('Flutter CEP2 Demo'), findsOneWidget);

    // Verify that the main components are present
    expect(find.text('Brazilian ZIP Code Lookup'), findsOneWidget);
    expect(find.text('CEP Lookup'), findsOneWidget);
    expect(find.text('Plugin Features'), findsOneWidget);

    // Verify that the CEP input field is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify that example CEP chips are present
    expect(find.text('01310-100'), findsOneWidget);
  });

  testWidgets('CEP input field accepts text', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find the text field and enter a CEP
    final textField = find.byType(TextField);
    await tester.enterText(textField, '01310-100');

    // Verify the text was entered
    expect(find.text('01310-100'), findsWidgets);
  });
}
