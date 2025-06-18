import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/main.dart';
import 'package:flutter2/pages/SignIn.dart';
import 'package:flutter2/pages/SignUp.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('MyApp should have correct theme color', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.colorScheme.primary, ColorScheme.fromSeed(seedColor: Colors.indigo).primary);
      expect(app.debugShowCheckedModeBanner, false);
      expect(app.title, 'Kahuutt');
    });
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen should display welcome text', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      expect(find.text('Welcome to Kahuut!'), findsOneWidget);
    });

    testWidgets('HomeScreen should have Sign in and Sign up buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('Sign in button should navigate to SignInPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('Sign up button should navigate to SignUpPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SignUpPage), findsOneWidget);
    });

    testWidgets('HomeScreen should have correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFFEFF8FF));
    });

    testWidgets('Welcome text should have correct style', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      final Text welcomeText = tester.widget(find.text('Welcome to Kahuut!'));
      expect(welcomeText.style?.fontSize, 32);
      expect(welcomeText.style?.fontWeight, FontWeight.bold);
    });
  });
}
