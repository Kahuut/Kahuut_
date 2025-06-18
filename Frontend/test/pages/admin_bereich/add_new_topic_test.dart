import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/AdminBereich/add_new_topic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('AddNewTopic Tests', () {
    testWidgets('AddNewTopic should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddNewTopic(),
        ),
      );

      // Verify basic widget structure
      expect(find.byType(AddNewTopic), findsOneWidget);
      expect(find.byType(TextField), findsWidgets); // Topic name and question fields
      expect(find.byType(Checkbox), findsWidgets); // Correct answer checkboxes
      expect(find.byType(ElevatedButton), findsWidgets); // Add question and save buttons

      // Verify text fields
      expect(find.widgetWithText(TextField, 'Thema Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Frage'), findsOneWidget);
    });

    testWidgets('Should handle option count change', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddNewTopic(),
        ),
      );

      // Initially should have default number of options (3)
      expect(find.byType(TextField), findsNWidgets(5)); // Topic name + question + 3 options

      // Find and interact with option count dropdown
      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();

      // Select a different option count if available
      if (find.text('4').evaluate().isNotEmpty) {
        await tester.tap(find.text('4').last);
        await tester.pumpAndSettle();

        // Should now have one more option field
        expect(find.byType(TextField), findsNWidgets(6)); // Topic name + question + 4 options
      }
    });

    testWidgets('Should validate empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddNewTopic(),
        ),
      );

      // Try to save without entering data
      await tester.tap(find.text('Thema speichern'));
      await tester.pumpAndSettle();

      // Should show validation message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Bitte gib einen Namen und mindestens eine Frage ein.'), findsOneWidget);
    });

    testWidgets('Should handle adding questions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddNewTopic(),
        ),
      );

      // Fill in the topic name
      await tester.enterText(find.widgetWithText(TextField, 'Thema Name'), 'Test Topic');

      // Fill in a question
      await tester.enterText(find.widgetWithText(TextField, 'Frage'), 'Test Question');

      // Finde die TextFields mit HintText 'Option...'
      final optionFields = find.byType(TextField).evaluate().where(
            (element) =>
        element.widget is TextField &&
            (element.widget as TextField).decoration?.hintText?.startsWith('Option') == true,
      ).toList(); // Wandle in Liste um per Index zugreifen zu können

      // Befülle alle Option-Felder
      for (var i = 0; i < optionFields.length; i++) {
        final finder = find.byWidget(optionFields[i].widget);
        await tester.enterText(finder, 'Option $i');
      }

      // Select a correct answer
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      // Add the question
      await tester.tap(find.text('Frage hinzufügen'));
      await tester.pumpAndSettle();

      // Verify question was added to the list
      expect(find.text('Test Question'), findsOneWidget);
    });

    testWidgets('Should have public/private toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddNewTopic(),
        ),
      );

      // Find and verify switch exists
      expect(find.byType(Switch), findsOneWidget);

      // Toggle the switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Verify the switch state changed
      final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });
  });
}
