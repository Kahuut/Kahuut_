import 'package:flutter/material.dart';

class UserStartseite extends StatefulWidget {
  const UserStartseite({super.key});

  @override
  State<UserStartseite> createState() => _UserStartseiteState();
}

class _UserStartseiteState extends State<UserStartseite> {
  final TextEditingController _nameController =
  TextEditingController(text: 'User One');
  final TextEditingController _emailController =
  TextEditingController(text: 'user1@gmail.com');

  String activePage = 'Profil';

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
        color: isActive ? Colors.blue.shade300 : Colors.blue.shade100,
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
            color: Colors.blue.shade100,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.account_circle, size: 80, color: Colors.black54),
                const SizedBox(height: 20),
                _buildMenuButton(context, 'Profil', Icons.person, () {
                  // Bleibt auf der Profilseite
                }),
                _buildMenuButton(context, 'Meine Themen', Icons.bookmark, () {
                  // Beispiel: Navigator.push(...);
                }),
                _buildMenuButton(context, 'Spiel starten', Icons.play_arrow, () {
                  // TODO: Logik zum Spielstart
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
                    'User Einstellungen',
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
