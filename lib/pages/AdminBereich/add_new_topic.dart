import 'package:flutter/material.dart';
import 'AdminStartseite.dart';
import 'topics.dart';

class AddNewTopicPage extends StatefulWidget {
  const AddNewTopicPage({super.key});

  @override
  State<AddNewTopicPage> createState() => _AddNewTopicPageState();
}

class _AddNewTopicPageState extends State<AddNewTopicPage> {
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  List<TextEditingController> _optionControllers = [];
  List<bool> _isOptionCorrect = [];

  bool isPublic = false;
  int selectedOptionCount = 3;

  @override
  void initState() {
    super.initState();
    _initializeOptions(selectedOptionCount);
  }

  void _initializeOptions(int count) {
    _optionControllers = List.generate(count, (_) => TextEditingController());
    _isOptionCorrect = List.generate(count, (_) => false);
  }

  @override
  void dispose() {
    _topicNameController.dispose();
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildSidebarButton(String label, IconData icon, VoidCallback onTap,
      {bool active = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        color: active ? Colors.grey.shade600 : Colors.grey.shade300,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.grey.shade300,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.account_circle, size: 80, color: Colors.black54),
                const SizedBox(height: 20),
                _buildSidebarButton('Settings', Icons.settings, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminStartseite()),
                  );
                }),
                _buildSidebarButton('Topics', Icons.topic, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TopicsPage()),
                  );
                }, active: true),
                _buildSidebarButton('Start the game', Icons.play_arrow, () {}),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: const Color(0xFFEFF8FF),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topic name
                  Row(
                    children: [
                      const Text('New topic name:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(controller: _topicNameController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Question Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question input and dropdown
                        Row(
                          children: [
                            const Expanded(child: Text('Question:')),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 4,
                              child: TextField(controller: _questionController),
                            ),
                            const SizedBox(width: 10),
                            const Text('Options:'),
                            const SizedBox(width: 10),
                            DropdownButton<int>(
                              value: selectedOptionCount,
                              items: [2, 3, 4].map((count) {
                                return DropdownMenuItem<int>(
                                  value: count,
                                  child: Text(count.toString()),
                                );
                              }).toList(),
                              onChanged: (newCount) {
                                setState(() {
                                  selectedOptionCount = newCount!;
                                  _initializeOptions(selectedOptionCount);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Option Inputs
                        Container(
                          color: Colors.lightBlue.shade200,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Options:'),
                              const SizedBox(height: 10),
                              for (int i = 0; i < selectedOptionCount; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _optionControllers[i],
                                          decoration: InputDecoration(
                                            hintText: 'Option ${String.fromCharCode(65 + i)}',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isOptionCorrect[i] = !_isOptionCorrect[i];
                                          });
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: Center(
                                            child: _isOptionCorrect[i]
                                                ? const Icon(Icons.check,
                                                size: 20, color: Colors.green)
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Placeholder für Speichern
                                  },
                                  child: const Text('OK'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Public / Private
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() => isPublic = false);
                              },
                              child: const Text('private'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreenAccent,
                              ),
                              onPressed: () {
                                setState(() => isPublic = true);
                              },
                              child: const Text('public'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Add topic button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Hier später das Topic speichern
                        String name = _topicNameController.text;
                        String question = _questionController.text;
                        List<Map<String, dynamic>> options = List.generate(
                          selectedOptionCount,
                              (i) => {
                            'text': _optionControllers[i].text,
                            'isCorrect': _isOptionCorrect[i]
                          },
                        );

                        print('Topic: $name');
                        print('Question: $question');
                        print('Options: $options');
                        print('Public: $isPublic');

                        // Du kannst hier die Logik zum Speichern in DB einbauen
                      },
                      child: const Text('Add new topic'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
