import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'play_topic.dart';
import 'home.dart';

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
  static final _logger = Logger('PlayPage');
  final supabase = Supabase.instance.client;

  List<Topic> topics = [];
  Topic? selectedTopic;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing PlayPage');
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    _logger.info('Loading topics');
    setState(() {
      isLoading = true;
    });

    try {
      _logger.fine('Fetching public topics from database');
      final response = await supabase
          .from('Themen')
          .select('id_themen, name, code')
          .eq('public', true)
          .execute();

      final data = response.data as List<dynamic>;
      topics = data.map((e) => Topic.fromMap(e)).toList();
      _logger.info('Successfully loaded ${topics.length} topics');

      if (topics.isNotEmpty) {
        selectedTopic = topics[0];
        _logger.fine('Selected default topic: ${selectedTopic!.name}');
      }
    } catch (e) {
      _logger.severe('Error loading topics', e);
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
    if (selectedTopic == null) {
      _logger.warning('Attempting to start game without selected topic');
      return;
    }

    _logger.info('Starting game with topic: ${selectedTopic!.name}');
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
    _logger.fine('Building PlayPage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiel starten'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _logger.info('Navigating back to HomePage');
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
