import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'SignUpUser.dart';
import 'SignUpAdmin.dart';

class SignUpPage extends StatelessWidget {
  static final _logger = Logger('SignUpPage');
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building SignUpPage');
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      appBar: AppBar(title: const Text("Sign Up")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign Up Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _logger.info('Navigating to Sign Up as User page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpAsUserPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Sign up as User', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _logger.info('Navigating to Sign Up as Admin page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpAsAdminPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              ),
              child: const Text('Sign up as Admin'),
            ),
          ],
        ),
      ),
    );
  }
}


