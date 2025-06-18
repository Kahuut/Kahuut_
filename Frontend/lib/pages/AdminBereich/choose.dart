import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  static final _logger = Logger('ChoosePage');
  List<Map<String, dynamic>> _topics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing ChoosePage');
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    _logger.info('Loading topics for selection');
    setState(() {
      _isLoading = true;
    });

    try {
      _logger.fine('Fetching topics from database');
      final response = await Supabase.instance.client
          .from('Themen')
          .select('id_themen, name, code')
          .execute();

      final data = response.data as List<dynamic>? ?? [];
      _logger.info('Successfully loaded ${data.length} topics');

      final topics = data.map((thema) => {
        'id_themen': thema['id_themen'],
        'name': thema['name'],
        'code': thema['code'],
      }).toList();

      setState(() {
        _topics = topics;
        _isLoading = false;
      });
    } catch (e) {
      _logger.severe('Error loading topics', e);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    }
  }

  void _chooseTopic(Map<String, dynamic> topic) {
    _logger.info('Topic selected: ${topic['name']} (ID: ${topic['id_themen']})');
    Navigator.pop(context, topic);
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building ChoosePage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Topic'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _logger.info('Returning without selection');
            Navigator.pop(context);
          },
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
