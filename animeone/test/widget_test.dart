import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animeone/main.dart';

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
void main() {
  testWidgets('Basic checks', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    // TODO: UI tests need to be fixed
    await tester.pump();

    // Bottom three taps
    expect(find.byIcon(Icons.list), findsOneWidget);
    var list = find.byIcon(Icons.new_releases);
    expect(list, findsOneWidget);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    // Refresh
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    // Tap new release
    await tester.tap(list);
    await tester.pump();
    // Search button should be visible
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
