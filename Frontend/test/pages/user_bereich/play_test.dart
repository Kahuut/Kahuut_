import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/UserBereich/play.dart';
import 'package:flutter2/pages/UserBereich/play_topic.dart';

void main() {
  group('PlayPage Tests', () {
    testWidgets('Should render loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlayPage()));
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should have correct AppBar title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlayPage()));
      
      expect(find.text('Spiel starten'), findsOneWidget);
    });

    testWidgets('Should have back button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlayPage()));
      
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}

class MockTopic {
  final String id;
  final String name;
  final String code;

  MockTopic({required this.id, required this.name, required this.code});
}
