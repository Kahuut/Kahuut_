import 'package:flutter/material.dart';
import 'package:flutter2/pages/SignUpAdmin.dart';
import 'package:logging/logging.dart';
import 'SignInUser.dart';
import 'SignInAdmin.dart';


class SignInPage extends StatelessWidget {
  static final _logger = Logger('SignInPage');
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building SignInPage');
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(title: const Text("Sign In")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _logger.info('Navigating to Sign In as User page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInAsUserPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Sign in as User', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _logger.info('Navigating to Sign In as Admin page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInAsAdminPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              ),
              child: const Text('Sign in as Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
