import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/pages/SignIn.dart';
import 'package:flutter2/pages/SignInUser.dart';
import 'package:flutter2/pages/SignInAdmin.dart';

void main() {
  group('SignInPage Tests', () {
    testWidgets('Should render SignInPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInPage()));
      
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Sign In Page'), findsOneWidget);
    });

    testWidgets('Should have User and Admin sign in buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInPage()));
      
      expect(find.text('Sign in as User'), findsOneWidget);
      expect(find.text('Sign in as Admin'), findsOneWidget);
    });

    testWidgets('User button should navigate to SignInAsUserPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInPage()));
      
      await tester.tap(find.text('Sign in as User'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SignInAsUserPage), findsOneWidget);
    });

    testWidgets('Admin button should navigate to SignInAsAdminPage', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInPage()));
      
      await tester.tap(find.text('Sign in as Admin'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SignInAsAdminPage), findsOneWidget);
    });

    testWidgets('Should have correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInPage()));
      
      final Scaffold scaffold = tester.widget(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFFF9F9F9));
    });
  });
}
