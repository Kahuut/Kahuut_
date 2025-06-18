import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/UserBereich/sidebar.dart';
import 'package:flutter2/pages/UserBereich/home.dart';
import 'package:flutter2/pages/UserBereich/play.dart';
import 'package:flutter2/pages/UserBereich/settings.dart';

void main() {
  group('Sidebar Tests', () {
    testWidgets('Should render all navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: Row(children: const [Sidebar(activePage: 'Home')])),
      ));
      
      expect(find.text('Spielen'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });

    testWidgets('Should highlight active page', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: Row(children: const [Sidebar(activePage: 'Spielen')])),
      ));
      
      final Container playButton = tester.widget(
        find.ancestor(
          of: find.text('Spielen'),
          matching: find.byType(Container),
        ).first,
      );
      
      expect(playButton.color, Colors.grey.shade600);
    });

    testWidgets('Should have correct width', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: Row(children: const [Sidebar(activePage: 'Home')])),
      ));
      
      final Container sidebar = tester.widget(
        find.byType(Container).first,
      );
      
      expect(sidebar.constraints?.maxWidth, 200);
    });
  });
}
