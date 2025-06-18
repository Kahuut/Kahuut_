import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'add_new_topic.dart';
import 'AdminStartseite.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  static final _logger = Logger('TopicsPage');
  List<Map<String, dynamic>> _topics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing TopicsPage');
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    _logger.info('Loading topics');
    setState(() => _isLoading = true);

    try {
      _logger.fine('Fetching topics and questions from database');
      final response = await Supabase.instance.client
          .from('Themen')
          .select('id_themen, name, Fragen(id_frage)')
          .execute();

      final data = response.data as List;
      _logger.info('Successfully loaded ${data.length} topics');

      setState(() {
        _topics = data.map((thema) {
          final fragen = thema['Fragen'] as List? ?? [];
          return {
            'id_themen': thema['id_themen'],
            'name': thema['name'],
            'frage_count': fragen.length,
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      _logger.severe('Error loading topics', e);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden: $e')),
      );
    }
  }

  Future<void> _confirmAndDeleteTopic(dynamic topicId) async {
    _logger.info('Confirming deletion of topic ID: $topicId');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thema löschen'),
          content: const Text('Möchtest du dieses Thema wirklich löschen?'),
          actions: [
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                _logger.info('Topic deletion cancelled');
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Ja, löschen'),
              onPressed: () {
                _logger.info('Topic deletion confirmed');
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteTopic(topicId);
    } else {
      _logger.info('Topic deletion cancelled by user');
    }
  }

  Future<void> _deleteTopic(dynamic topicId) async {
    _logger.info('Deleting topic ID: $topicId');

    try {
      _logger.fine('Executing delete operation in database');
      final response = await Supabase.instance.client
          .from('Themen')
          .delete()
          .eq('id_themen', topicId)
          .execute();

      _logger.fine('Delete response status: ${response.status}');

      if (response.status == 200 || response.status == 204) {
        _logger.info('Successfully deleted topic ID: $topicId');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thema wurde gelöscht.')),
        );
        _loadTopics();
      } else {
        _logger.warning('Failed to delete topic. Status: ${response.status}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Löschen: ${response.data}')),
        );
      }
    } catch (e) {
      _logger.severe('Error deleting topic', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building TopicsPage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verfügbare Themen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _logger.info('Navigating back to AdminStartseite');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminStartseite()),
            );
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              _logger.info('Navigating to AddNewTopic page');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddNewTopic()),
              ).then((_) => _loadTopics());
            },
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text('Add new topic', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: _topics.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Keine Themen vorhanden.'),
          )
              : Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final topic = _topics[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${topic['name']} (Fragen: ${topic['frage_count']})',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Optional
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmAndDeleteTopic(topic['id_themen']);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
