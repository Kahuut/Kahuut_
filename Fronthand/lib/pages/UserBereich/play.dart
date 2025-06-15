import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sidebar.dart';
import 'home.dart';
import 'play_topic.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> publicTopics = [];
  Map<String, dynamic>? selectedTopic;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPublicTopics();
  }

  Future<void> _loadPublicTopics() async {
    final response = await supabase
        .from('Themen')
        .select('id_themen, name, code')
        .eq('public', true);
        //.execute(); //:contentReference[oaicite:4]{index=4}

    final data = response.data as List<dynamic>?;

    setState(() {
    publicTopics = data
        ?.map((e) => {
    'id': e['id_themen'],
    'name': e['name'],
    'code': e['code'],
    })
        .toList() ??
    [];
    if (publicTopics.isNotEmpty) selectedTopic = publicTopics[0];
    _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(activePage: 'Spielen'),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              color: const Color(0xFFEFF8FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.account_circle, size: 40),
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
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedTopic,
                    decoration: const InputDecoration(
                      labelText: 'Thema auswählen',
                      border: OutlineInputBorder(),
                    ),
                    items: publicTopics
                        .map((topic) => DropdownMenuItem(
                        value: topic, child: Text(topic['name'])))
                        .toList(),
                    onChanged: (v) => setState(() => selectedTopic = v),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: selectedTopic == null
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayTopicPage(
                                topicId: selectedTopic!['id'],
                                topicName: selectedTopic!['name'],
                                topicCode: selectedTopic!['code'],
                              ),
                            ),
                          );
                        },
                        child: const Text('Jetzt spielen'),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Mehrspieler-Modus noch nicht implementiert')),
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
