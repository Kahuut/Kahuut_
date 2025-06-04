import 'package:flutter/material.dart';
import 'topics.dart';

class AdminStartseite extends StatefulWidget {
  const AdminStartseite({super.key});

  @override
  State<AdminStartseite> createState() => _AdminStartseiteState();
}

class _AdminStartseiteState extends State<AdminStartseite> {
  final TextEditingController _nameController =
  TextEditingController(text: 'Admin One');
  final TextEditingController _emailController =
  TextEditingController(text: 'admin1@gmail.com');

  String activePage = 'Settings';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildMenuButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onPressed,
      ) {
    bool isActive = activePage == label;

    return InkWell(
      onTap: () {
        setState(() {
          activePage = label;
        });
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        color: isActive ? Colors.grey.shade600 : Colors.grey.shade300,
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.grey.shade300,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.account_circle, size: 80, color: Colors.black54),
                const SizedBox(height: 20),
                _buildMenuButton(context, 'Settings', Icons.settings, () {
                  // bleibe auf derselben Seite
                }),
                _buildMenuButton(context, 'Topics', Icons.topic, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TopicsPage()),
                  );
                }),
                _buildMenuButton(context, 'Start the game', Icons.play_arrow, () {
                  // TODO
                }),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              color: const Color(0xFFEFF8FF),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Admin Einstellungen',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'E-Mail',
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Daten gespeichert')),
                            );
                          },
                          child: const Text('Speichern'),
                        ),
                      ],
                    ),
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
