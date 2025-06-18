import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'AdminStartseite.dart';
import 'topics.dart';
import 'dart:math';

class AddNewTopic extends StatefulWidget {
  const AddNewTopic({super.key});

  @override
  State<AddNewTopic> createState() => _AddNewTopicState();
}

class _AddNewTopicState extends State<AddNewTopic> {
  static final _logger = Logger('AddNewTopic');
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final List<bool> _isOptionCorrect = [];
  bool _isPublic = false;
  int selectedOptionCount = 3;
  final List<QuestionBlock> _questionsList = [];

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing AddNewTopic page');
    _initializeOptions(selectedOptionCount);
  }

  void _initializeOptions(int count) {
    _logger.fine('Initializing $count options');
    _optionControllers.clear();
    _isOptionCorrect.clear();
    for (int i = 0; i < count; i++) {
      _optionControllers.add(TextEditingController());
      _isOptionCorrect.add(false);
    }
  }

  String _generateUniqueCode() {
    _logger.fine('Generating unique code');
    final random = Random();
    List<int> digits = [];
    while (digits.length < 6) {
      int digit = random.nextInt(10);
      if (!digits.contains(digit)) {
        digits.add(digit);
      }
    }
    final code = digits.join();
    _logger.info('Generated unique code: $code');
    return code;
  }

  Future<void> _saveTopicToDatabase() async {
    _logger.info('Starting to save new topic to database');
    final topicName = _topicNameController.text.trim();
    final code = _generateUniqueCode();

    if (topicName.isEmpty || _questionsList.isEmpty) {
      _logger.warning('Attempted to save topic with empty name or no questions');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib einen Namen und mindestens eine Frage ein.')),
      );
      return;
    }

    try {
      _logger.info('Inserting new topic: $topicName');
      final insertedTopic = await Supabase.instance.client
          .from('Themen')
          .insert({'name': topicName, 'code': code, 'public': _isPublic})
          .select()
          .single();

      final topicId = insertedTopic['id_themen'];
      _logger.info('Topic created with ID: $topicId');

      for (final q in _questionsList) {
        _logger.fine('Adding question: ${q.question}');
        final insertedQuestion = await Supabase.instance.client
            .from('Fragen')
            .insert({
              'frage': q.question,
              'fk_id_themen': topicId,
            })
            .select()
            .single();

        final questionId = insertedQuestion['id_frage'];
        _logger.fine('Question created with ID: $questionId');

        for (int i = 0; i < q.options.length; i++) {
          _logger.fine('Adding answer option ${i + 1} for question $questionId');
          await Supabase.instance.client.from('Antworten').insert({
            'antwort': q.options[i],
            'richtig': q.isCorrect[i],
            'fk_id_frage': questionId,
          });
        }
      }

      _logger.info('Successfully saved topic with ${_questionsList.length} questions');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thema erfolgreich erstellt!')),
      );

      _topicNameController.clear();
      _questionsList.clear();
      _questionController.clear();
      setState(() {
        selectedOptionCount = 3;
        _initializeOptions(selectedOptionCount);
        _isPublic = false;
      });

    } catch (e) {
      _logger.severe('Error saving topic to database', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building AddNewTopic page');
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New topic name:", style: Theme.of(context).textTheme.titleLarge),
            TextField(controller: _topicNameController),
            const SizedBox(height: 24),
            _buildQuestionInput(),
            const SizedBox(height: 24),

            // Public / Private Auswahl
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _isPublic = false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPublic ? Colors.grey : Colors.red,
                      ),
                      child: const Text('private'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _isPublic = true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPublic ? Colors.green : Colors.grey,
                      ),
                      child: const Text('public'),
                    ),
                  ],
                ),

                // Add Topic Button
                ElevatedButton(
                  onPressed: _saveTopicToDatabase,
                  child: const Text("Add new topic"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Back Button
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TopicsPage()),
                  );
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Topics"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Question:"),
          TextField(controller: _questionController),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Options:"),
              DropdownButton<int>(
                value: selectedOptionCount,
                items: List.generate(6, (index) => index + 2)
                    .map((val) => DropdownMenuItem<int>(
                  value: val,
                  child: Text(val.toString()),
                ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedOptionCount = val;
                      _initializeOptions(selectedOptionCount);
                    });
                  }
                },
              )
            ],
          ),
          Container(
            color: Colors.lightBlueAccent,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: List.generate(selectedOptionCount, (index) {
                return Row(
                  children: [
                    Expanded(child: TextField(controller: _optionControllers[index])),
                    Checkbox(
                      value: _isOptionCorrect[index],
                      onChanged: (val) {
                        setState(() => _isOptionCorrect[index] = val ?? false);
                      },
                    )
                  ],
                );
              }),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_questionController.text.isEmpty ||
                    _optionControllers.any((c) => c.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bitte fülle alle Felder vollständig aus.')),
                  );
                  return;
                }

                _questionsList.add(
                  QuestionBlock(
                    question: _questionController.text.trim(),
                    options: _optionControllers.map((c) => c.text.trim()).toList(),
                    isCorrect: List.from(_isOptionCorrect),
                  ),
                );

                setState(() {
                  _questionController.clear();
                  selectedOptionCount = 3;
                  _initializeOptions(selectedOptionCount);
                });
              },
              child: const Text("OK"),
            ),
          )
        ],
      ),
    );
  }
}

class QuestionBlock {
  String question;
  List<String> options;
  List<bool> isCorrect;

  QuestionBlock({
    required this.question,
    required this.options,
    required this.isCorrect,
  });
}
