import 'package:flutter/material.dart';
import '../../main.dart';
import 'play.dart';
import 'settings.dart';
import 'home.dart';

class Sidebar extends StatelessWidget {
  final String activePage;
  const Sidebar({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    Widget buildMenuButton(String label, IconData icon, VoidCallback onTap) {
      bool isActive = activePage == label;
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: isActive ? Colors.grey.shade600 : Colors.grey.shade300,
          child: Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 200,
      color: Colors.grey.shade300,
      child: Column(
        children: [
          const SizedBox(height: 60),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Icon(Icons.account_circle, size: 80, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          buildMenuButton('Spielen', Icons.play_arrow, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PlayPage()),
            );
          }),
          buildMenuButton('Profil', Icons.person, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          }),
          const Spacer(),

          // Logout Button
          buildMenuButton('Log out', Icons.logout, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          }),
        ],
      ),
    );
  }
}
