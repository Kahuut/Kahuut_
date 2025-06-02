import 'package:flutter/material.dart';

class AdminStartseite extends StatelessWidget {
  const AdminStartseite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Startseite')),
      body: const Center(
        child: Text(
          'Willkommen auf der Admin Startseite!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
