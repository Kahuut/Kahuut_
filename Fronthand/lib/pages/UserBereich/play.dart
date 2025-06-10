import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'home.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  String selectedTopic = 'Mathematik';

  final List<String> topics = [
    'Mathematik',
    'Geschichte',
    'Informatik',
    'Sport',
    'Allgemeinwissen',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(activePage: 'Spielen'),

          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              color: const Color(0xFFEFF8FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Obere Leiste mit Avatar
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.account_circle, size: 40, color: Colors.black54),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'Spiel starten',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedTopic,
                    decoration: const InputDecoration(
                      labelText: 'Thema auswählen',
                      border: OutlineInputBorder(),
                    ),
                    items: topics.map((String topic) {
                      return DropdownMenuItem<String>(
                        value: topic,
                        child: Text(topic),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTopic = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Starte Thema: $selectedTopic')),
                          );
                        },
                        child: const Text('Jetzt spielen'),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mehrspieler-Modus noch nicht implementiert'),
                            ),
                          );
                        },
                        child: const Text('Mehrspieler'),
                      ),
                    ],
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
