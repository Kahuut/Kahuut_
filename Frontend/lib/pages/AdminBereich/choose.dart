import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  List<Map<String, dynamic>> _topics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('Themen')
          .select('id_themen, name, code')
          .execute();

      final data = response.data as List<dynamic>? ?? [];

      final topics = data.map((thema) => {
        'id_themen': thema['id_themen'],
        'name': thema['name'],
        'code': thema['code'], // wichtig für Rückgabe
      }).toList();

      setState(() {
        _topics = topics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    }
  }

  void _chooseTopic(Map<String, dynamic> topic) {
    Navigator.pop(context, topic); // Topic zurückgeben an start_the_game.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Topic'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _topics.isEmpty
            ? const Center(child: Text('Keine Themen vorhanden.'))
            : ListView.builder(
          itemCount: _topics.length,
          itemBuilder: (context, index) {
            final topic = _topics[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(topic['name']),
                subtitle: Text('Code: ${topic['code']}'),
                trailing: ElevatedButton(
                  onPressed: () => _chooseTopic(topic),
                  child: const Text('Choose'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
