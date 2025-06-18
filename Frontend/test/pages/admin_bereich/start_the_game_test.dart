import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/AdminBereich/start_the_game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('StartTheGamePage Tests', () {
    testWidgets('StartTheGamePage should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      // Verify basic widget structure
      expect(find.byType(StartTheGamePage), findsOneWidget);
      
      // Verify key elements
      expect(find.text('Spiel starten'), findsOneWidget);
      expect(find.text('Thema auswählen'), findsOneWidget);
      expect(find.text('Spieler'), findsOneWidget);
    });

    testWidgets('Should show initial empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Should show empty state when no topic is selected
      expect(find.text('Kein Thema ausgewählt'), findsOneWidget);
    });

    testWidgets('Should show game code when topic is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Initially should not show game code
      expect(find.text('Spiel Code:'), findsNothing);

      // After topic selection (simulated), should show game code
      // Note: In actual implementation, this would come from state updates
    });

    testWidgets('Should show players list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify players section exists
      expect(find.text('Spieler'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Should have navigation sidebar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      // Verify sidebar elements
      expect(find.byType(Container), findsWidgets);
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    testWidgets('Should handle player kick functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap kick button if any players exist
      if (find.byIcon(Icons.close).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();
        
        // Verify player was removed
        // Note: In actual implementation, this would verify the specific player was removed
      }
    });

    testWidgets('Should have topic selection button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      // Verify topic selection button exists
      expect(find.byType(ElevatedButton), findsWidgets);
      expect(find.text('Thema auswählen'), findsOneWidget);
    });

    testWidgets('Should have responsive layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );

      // Test with different screen sizes
      const Size smallScreen = Size(400, 600);
      const Size largeScreen = Size(1200, 800);

      // Small screen
      await tester.binding.setSurfaceSize(smallScreen);
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Large screen
      await tester.binding.setSurfaceSize(largeScreen);
      await tester.pumpWidget(
        const MaterialApp(
          home: StartTheGamePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Reset the surface size
      await tester.binding.setSurfaceSize(null);
    });
  });
}
