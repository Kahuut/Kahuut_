import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/SignInAdmin.dart';

void main() {
  group('SignInAsAdminPage Tests', () {
    testWidgets('Should render form fields correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInAsAdminPage()));
      
      expect(find.text('Admin Login'), findsOneWidget);
      expect(find.text('Benutzername'), findsOneWidget);
      expect(find.text('E-Mail'), findsOneWidget);
      expect(find.text('Passwort'), findsOneWidget);
    });

    testWidgets('Should validate empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInAsAdminPage()));
      
      // Find and tap the submit button
      await tester.tap(find.text('Anmelden'));
      await tester.pump();

      // Verify validation messages
      expect(find.text('Bitte Benutzername eingeben'), findsOneWidget);
      expect(find.text('Bitte E-Mail eingeben'), findsOneWidget);
    });

    testWidgets('Should have correct form field decorations', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInAsAdminPage()));
      
      final usernameFinder = find.ancestor(
        of: find.text('Benutzername'),
        matching: find.byType(InputDecoration),
      );
      expect(usernameFinder, findsOneWidget);
      
      final emailFinder = find.ancestor(
        of: find.text('E-Mail'),
        matching: find.byType(InputDecoration),
      );
      expect(emailFinder, findsOneWidget);
    });

    testWidgets('Should have correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInAsAdminPage()));
      
      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFFEFF8FF));
    });

    testWidgets('Should have back button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInAsAdminPage()));
      
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
