import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'sidebar.dart';
import 'home.dart';

class UserStartseite extends StatelessWidget {
  static final _logger = Logger('UserStartseite');
  const UserStartseite({super.key});

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building UserStartseite');
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(activePage: 'Start'),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              color: const Color(0xFFEFF8FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Obere Leiste mit Avatar
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.account_circle, size: 40, color: Colors.black54),
                      onPressed: () {
                        _logger.info('Navigating to HomePage');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'Willkommen bei KAHUUT!',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
