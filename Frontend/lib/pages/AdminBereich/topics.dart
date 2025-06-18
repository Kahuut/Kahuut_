import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_new_topic.dart';
import 'AdminStartseite.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  List<Map<String, dynamic>> _topics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('Themen')
          .select('id_themen, name, Fragen(id_frage)')
          .execute();

      final data = response.data as List;

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
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden: $e')),
      );
    }
  }

  Future<void> _confirmAndDeleteTopic(dynamic topicId) async {
    print('Delete button clicked – Thema ID: $topicId');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thema löschen'),
          content: const Text('Möchtest du dieses Thema wirklich löschen?'),
          actions: [
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Ja, löschen'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteTopic(topicId);
    } else {
      print('Löschung abgebrochen');
    }
  }

  Future<void> _deleteTopic(dynamic topicId) async {
    print('Lösche Thema ID: $topicId');

    try {
      final response = await Supabase.instance.client
          .from('Themen')
          .delete()
          .eq('id_themen', topicId)
          .execute();

      print('Delete response status: ${response.status}');
      print('Delete response data: ${response.data}');

      if (response.status == 200 || response.status == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thema wurde gelöscht.')),
        );
        _loadTopics();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Löschen: ${response.data}')),
        );
      }
    } catch (e) {
      print('Fehler beim Löschen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verfügbare Themen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminStartseite()),
            );
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
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
