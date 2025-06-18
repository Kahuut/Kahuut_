import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/AdminBereich/AdminStartseite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AdminStartseite Tests', () {
    testWidgets('AdminStartseite should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminStartseite(),
        ),
      );

      // Verify basic widget structure
      expect(find.byType(AdminStartseite), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3)); // Name, Email, Password fields
      expect(find.byType(ElevatedButton), findsWidgets); // Save button

      // Verify text fields exist
      expect(find.widgetWithText(TextField, 'Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Passwort'), findsOneWidget);
    });

    testWidgets('Should show snackbar on save without admin ID', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminStartseite(),
        ),
      );

      // Trigger save
      await tester.tap(find.widgetWithText(ElevatedButton, 'Speichern'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Fehler: Keine Admin-ID verfügbar'), findsOneWidget);
    });

    testWidgets('Should have a responsive layout', (WidgetTester tester) async {
      // Test with different screen sizes
      const Size smallScreen = Size(400, 600);
      const Size largeScreen = Size(1200, 800);

      // Small screen
      await tester.binding.setSurfaceSize(smallScreen);
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminStartseite(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify layout adapts to small screen
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Large screen
      await tester.binding.setSurfaceSize(largeScreen);
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminStartseite(),
        ),
      );
      await tester.pumpAndSettle();

      // Reset the surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Should have navigation menu', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminStartseite(),
        ),
      );

      // Verify navigation elements
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.topic), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });
  });
}
