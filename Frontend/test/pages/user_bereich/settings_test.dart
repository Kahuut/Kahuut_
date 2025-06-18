import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/UserBereich/settings.dart';

void main() {
  group('SettingsPage Tests', () {
    testWidgets('Should render all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      
      expect(find.text('Benutzereinstellungen'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('E-Mail'), findsOneWidget);
      expect(find.text('Passwort ändern'), findsOneWidget);
    });

    testWidgets('Should have save button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      
      expect(find.text('Speichern'), findsOneWidget);
    });

    testWidgets('Should show success message on save', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      
      await tester.tap(find.text('Speichern'));
      await tester.pumpAndSettle();
      
      expect(find.text('Änderungen gespeichert'), findsOneWidget);
    });

    testWidgets('Should have correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      
      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      
      expect(container.color, const Color(0xFFEFF8FF));
    });

    testWidgets('Should include Sidebar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      
      expect(find.byType(Row), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });
  });
}
