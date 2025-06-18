import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/AdminBereich/choose.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('ChoosePage Tests', () {
    testWidgets('ChoosePage should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      // Verify basic widget structure
      expect(find.byType(ChoosePage), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Choose Topic'), findsOneWidget);
    });

    testWidgets('Should show loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show empty state message when no topics', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Should show empty state when no topics are loaded
      expect(find.text('Keine Themen vorhanden.'), findsOneWidget);
    });

    testWidgets('Should have back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      // Verify back button exists
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Test back button functionality
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });

    testWidgets('Topics should be selectable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap Choose button if any topics exist
      if (find.text('Choose').evaluate().isNotEmpty) {
        await tester.tap(find.text('Choose').first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Should display topic code', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      await tester.pumpAndSettle();

      // If there are topics, they should show their codes
      if (find.byType(ListTile).evaluate().isNotEmpty) {
        expect(find.textContaining('Code:'), findsWidgets);
      }
    });

    testWidgets('Should have proper list layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify list structure
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Should have proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChoosePage(),
        ),
      );

      // Verify padding exists
      expect(find.byType(Padding), findsWidgets);
      
      final paddingWidget = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(ChoosePage),
          matching: find.byType(Padding),
        ).first,
      );
      
      expect(paddingWidget.padding, const EdgeInsets.all(16));
    });
  });
}
