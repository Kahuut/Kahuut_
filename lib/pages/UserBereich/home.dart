import 'package:flutter/material.dart';
import 'sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(activePage: 'Home'),
          Expanded(
            child: Container(
              color: const Color(0xFFEFF8FF),
              child: const Center(
                child: Text(
                  'Willkommen bei KAHUUT!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
