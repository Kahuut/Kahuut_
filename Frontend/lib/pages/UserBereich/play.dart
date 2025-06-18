import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'play_topic.dart';
import 'home.dart';  // Importiere deine home.dart Datei

class Topic {
  final String id;
  final String name;
  final String code;

  Topic({required this.id, required this.name, required this.code});

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id_themen'].toString(),
      name: map['name'] ?? '',
      code: map['code'] ?? '',
    );
  }
}

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final supabase = Supabase.instance.client;

  List<Topic> topics = [];
  Topic? selectedTopic;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabase
          .from('Themen')
          .select('id_themen, name, code')
          .eq('public', true)
          .execute();



      final data = response.data as List<dynamic>;
      topics = data.map((e) => Topic.fromMap(e)).toList();

      if (topics.isNotEmpty) {
        selectedTopic = topics[0];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Themen: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startGame() {
    if (selectedTopic == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayTopicPage(
          topicId: selectedTopic!.id,
          topicName: selectedTopic!.name,
          topicCode: selectedTopic!.code,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiel starten'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Zurück zur home.dart navigieren
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Thema auswählen:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Topic>(
              value: selectedTopic,
              decoration: const InputDecoration(
                labelText: 'Thema',
                border: OutlineInputBorder(),
              ),
              items: topics.map((topic) {
                return DropdownMenuItem<Topic>(
                  value: topic,
                  child: Text(topic.name),
                );
              }).toList(),
              onChanged: (topic) {
                setState(() {
                  selectedTopic = topic;
                });
              },
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _startGame,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text('Jetzt spielen', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
