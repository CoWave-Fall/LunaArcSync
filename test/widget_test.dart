import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_arc_sync/app.dart';
import 'package:luna_arc_sync/core/di/injection.dart';

void main() {
  // Set up dependency injection before running tests
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('App starts and shows a loading indicator', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // At the start, our app's AuthState is `initial`, which shows a CircularProgressIndicator.
    // Let's verify that this indicator is present.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}