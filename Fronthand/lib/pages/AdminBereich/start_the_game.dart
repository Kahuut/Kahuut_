import 'package:flutter/material.dart';
import 'package:flutter2/pages/AdminBereich/AdminStartseite.dart';
import 'package:flutter2/pages/AdminBereich/topics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'choose.dart';

class StartTheGamePage extends StatefulWidget {
  const StartTheGamePage({super.key});

  @override
  State<StartTheGamePage> createState() => _StartTheGamePageState();
}

class _StartTheGamePageState extends State<StartTheGamePage> {
  Map<String, dynamic>? selectedTopic;
  String gameCode = '';
  List<Map<String, dynamic>> players = [];

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    try {
      final response = await Supabase.instance.client
          .from('User')  // Groß-U und Anführungszeichen
          .select('id_user, name')
          .execute();


      final data = response.data as List<dynamic>? ?? [];

      setState(() {
        players = data.map((p) => {
          'id_user': p['id_user'],
          'name': p['name'],
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Spieler: $e')),
      );
    }
  }


  void _chooseTopic() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChoosePage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedTopic = result;
        gameCode = result['code'] ?? '';
      });
    }
  }

  void _kickPlayer(String idUser) {
    setState(() {
      players.removeWhere((p) => p['id_user'] == idUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Menü (wie AdminStartseite)
          Container(
            width: 200,
            color: Colors.grey.shade300,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.account_circle, size: 80, color: Colors.black54),
                const SizedBox(height: 20),

                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const TopicsPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Row(
                      children: const [
                        Icon(Icons.topic),
                        SizedBox(width: 10),
                        Text('Topics'),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    // Bleibe hier
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    color: Colors.grey.shade600,
                    child: Row(
                      children: const [
                        Icon(Icons.play_arrow),
                        SizedBox(width: 10),
                        Text('Start the game'),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminStartseite()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Row(
                      children: const [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text('Settings'),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Row(
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(width: 10),
                        Text('Log out'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hauptbereich
          Expanded(
            child: Container(
              color: const Color(0xFFEFF8FF),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thema wählen + Anzeige
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
                        child: Text('Selected topic: ${selectedTopic?['name'] ?? ''}'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Code anzeigen
                  Row(
                    children: [
                      const Text(
                        'Code:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
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

                  // Spieler Liste
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
                        if (players.isEmpty)
                          const Text('Keine Spieler vorhanden.'),
                        for (var player in players)
                          Container(
                            color: Colors.grey.shade400,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(player['name'] ?? 'Unnamed'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _kickPlayer(player['id_user']),
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

                  // Start Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Spiel starten Logik hier
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Spiel gestartet!')),
                        );
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
