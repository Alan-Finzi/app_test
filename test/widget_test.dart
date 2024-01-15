// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:agenda_canchas/widget/agendar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('ButtonSchedule widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: ButtonSchedule(),
          ),
        ),
      ),
    );

    // Verify that the button is rendered with the expected icon and text.
    expect(find.byIcon(Icons.sports_soccer), findsOneWidget);
    expect(find.text("Agendar"), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the onPressed callback is triggered.
    // Replace this with your actual navigation verification logic.
    expect(find.text('You pressed the button!'), findsOneWidget);
  });
}
