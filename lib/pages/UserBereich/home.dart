import 'package:flutter/material.dart';
import 'sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Seitenleiste (Navigation)
          const Sidebar(activePage: 'Home'),

          // Hauptinhalt
          Expanded(
            child: Container(
              color: const Color(0xFFEFF8FF),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 40),
                  Text(
                    'Willkommen bei KAHUUT!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Dies ist Ihre Benutzerstartseite.',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
