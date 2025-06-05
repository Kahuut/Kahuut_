import 'dart:math';
import 'package:flutter/material.dart';
import 'AdminStartseite.dart';
import 'topics.dart';

class StartTheGamePage extends StatefulWidget {
  const StartTheGamePage({super.key});

  @override
  State<StartTheGamePage> createState() => _StartTheGamePageState();
}

class _StartTheGamePageState extends State<StartTheGamePage> {
  late String gameCode;
  String? selectedTopic;
  List<String> players = ['Testuser'];

  @override
  void initState() {
    super.initState();
    gameCode = _generateRandomCode();
  }

  String _generateRandomCode() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString();
  }

  void _chooseTopic() async {
    // Temporäre Topic Auswahl ohne DB
    String newTopic = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TopicsPage()),
    );
    setState(() {
      selectedTopic = newTopic;
    });
  }

  void _kickPlayer(String player) {
    setState(() {
      players.remove(player);
    });
  }

  Widget _buildSidebarButton(String label, IconData icon, VoidCallback onTap, {bool active = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        color: active ? Colors.grey.shade600 : Colors.grey.shade300,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(label),
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
                _buildSidebarButton('Settings', Icons.settings, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminStartseite()),
                  );
                }),
                _buildSidebarButton('Topics', Icons.topic, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TopicsPage()),
                  );
                }),
                _buildSidebarButton('Start the game', Icons.play_arrow, () {}, active: true),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: const Color(0xFFEFF8FF),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Zurück + Titel
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Game Setup',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Topic Selection Row
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _chooseTopic,
                        child: const Text('Choose the topic'),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: Text('Selected topic: ${selectedTopic ?? ''}'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Game Code
                  Row(
                    children: [
                      const Text('Code:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: gameCode),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Player list
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Players:'),
                        const SizedBox(height: 10),
                        for (var player in players)
                          Container(
                            color: Colors.grey.shade400,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(player),
                                ),
                                ElevatedButton(
                                  onPressed: () => _kickPlayer(player),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                  child: const Text('kick'),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Start button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Spiel starten (Logik folgt später)
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600),
                      child: const Text('Start'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
