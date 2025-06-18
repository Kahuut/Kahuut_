import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/UserBereich/play_topic.dart';

void main() {
  group('PlayTopicPage Tests', () {
    testWidgets('Should render loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlayTopicPage(
          topicId: '1',
          topicName: 'Test Topic',
          topicCode: '123456',
        ),
      ));
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show topic name in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlayTopicPage(
          topicId: '1',
          topicName: 'Test Topic',
          topicCode: '123456',
        ),
      ));
      
      expect(find.text('Test Topic'), findsOneWidget);
    });

    testWidgets('Should have back button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlayTopicPage(
          topicId: '1',
          topicName: 'Test Topic',
          topicCode: '123456',
        ),
      ));
      
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
