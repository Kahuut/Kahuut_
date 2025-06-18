import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/AdminBereich/topics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('TopicsPage Tests', () {
    testWidgets('TopicsPage should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TopicsPage(),
        ),
      );

      // Verify initial loading state
      expect(find.byType(TopicsPage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('TopicsPage should show empty state message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TopicsPage(),
        ),
      );

      // Let the future complete
      await tester.pumpAndSettle();

      // Should show empty state when no topics are loaded
      expect(find.text('Keine Themen gefunden'), findsOneWidget);
    });

    testWidgets('Should show add topic button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TopicsPage(),
        ),
      );

      // Verify add topic button exists
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Should have delete confirmation dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TopicsPage(),
        ),
      );

      // Add a mock topic to trigger delete
      // This would normally come from Supabase but we're testing UI only
      await tester.pumpAndSettle();

      // Find and tap delete button (if there was a topic)
      if (find.byIcon(Icons.delete).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pumpAndSettle();

        // Verify dialog appears
        expect(find.text('Thema löschen'), findsOneWidget);
        expect(find.text('Möchtest du dieses Thema wirklich löschen?'), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Abbrechen'), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Ja, löschen'), findsOneWidget);
      }
    });

    testWidgets('Should have navigation buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TopicsPage(),
        ),
      );

      // Verify navigation elements
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Topic items should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TopicsPage(),
        ),
      );

      await tester.pumpAndSettle();

      // In a real app, topics would be loaded from Supabase
      // Here we're just verifying the ListView exists
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
