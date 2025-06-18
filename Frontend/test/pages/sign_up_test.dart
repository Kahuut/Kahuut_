import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/SignUp.dart';
import 'package:flutter2/pages/SignUpUser.dart';
import 'package:flutter2/pages/SignUpAdmin.dart';

void main() {
  group('SignUpPage Tests', () {
    testWidgets('Should render SignUpPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
      
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Sign Up Page'), findsOneWidget);
    });

    testWidgets('Should have User and Admin sign up buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
      
      expect(find.text('Sign up as User'), findsOneWidget);
      expect(find.text('Sign up as Admin'), findsOneWidget);
    });

    testWidgets('User button should navigate to SignUpAsUserPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
      
      await tester.tap(find.text('Sign up as User'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SignUpAsUserPage), findsOneWidget);
    });

    testWidgets('Admin button should navigate to SignUpAsAdminPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
      
      await tester.tap(find.text('Sign up as Admin'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SignUpAsAdminPage), findsOneWidget);
    });

    testWidgets('Should have correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
      
      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFFEFF8FF));
    });
  });
}
