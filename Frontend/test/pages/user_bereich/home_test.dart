import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/UserBereich/home.dart';

void main() {
  group('HomePage Tests', () {
    testWidgets('Should render welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      expect(find.text('Willkommen bei KAHUUT!'), findsOneWidget);
      expect(find.text('Dies ist Ihre Benutzerstartseite.'), findsOneWidget);
    });

    testWidgets('Should have correct text styles', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      final titleFinder = find.text('Willkommen bei KAHUUT!');
      final Text titleWidget = tester.widget(titleFinder);
      
      expect(titleWidget.style?.fontSize, 32);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.color, Colors.black87);
    });

    testWidgets('Should have correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      
      expect(container.color, const Color(0xFFEFF8FF));
    });

    testWidgets('Should include Sidebar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      expect(find.byType(Row), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
