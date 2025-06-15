import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class PlayTopicPage extends StatefulWidget {
  final int topicId;
  final String topicName;
  final String topicCode;

  const PlayTopicPage({
    super.key,
    required this.topicId,
    required this.topicName,
    required this.topicCode,
  });

  @override
  State<PlayTopicPage> createState() => _PlayTopicPageState();
}

class _PlayTopicPageState extends State<PlayTopicPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> questions = [];
  int currentQuestion = 0, correctCount = 0;
  String? selectedAnswer;
  bool finished = false, _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final response = await supabase
        .from('Fragen')
        .select('id_frage, frage, Antworten(antwort, richtig)')
        .eq('fk_id_themen', widget.topicId);
        //.execute(); // :contentReference[oaicite:8]{index=8}

    final data = response.data as List<dynamic>? ?? [];

    setState(() {
    questions = data.map((q) {
    final answers = q['Antworten'] as List<dynamic>;
    return {
    'frage': q['frage'],
    'antworten': answers.map((a) => a['antwort'] as String).toList(),
    'korrekt': answers.map((a) => a['richtig'] as bool).toList(),
    };
    }).toList();
    _loading = false;
    });
  }

  void _next() {
    final ansList = questions[currentQuestion]['korrekt'] as List<bool>;
    if (selectedAnswer != null &&
        ansList[questions[currentQuestion]['antworten']
            .indexOf(selectedAnswer!)] == true) correctCount++;

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      setState(() => finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (finished) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.topicName)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Du hast $correctCount von ${questions.length} richtig!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                  );
                },
                child: const Text('Zurück zur Startseite'),
              )
            ],
          ),
        ),
      );
    }

    final q = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Frage ${currentQuestion + 1}/${questions.length}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(q['frage'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            for (var ans in q['antworten'] as List<String>)
              RadioListTile<String>(
                title: Text(ans),
                value: ans,
                groupValue: selectedAnswer,
                onChanged: (v) => setState(() => selectedAnswer = v),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAnswer == null ? null : _next,
              child: const Text('Weiter'),
            )
          ],
        ),
      ),
    );
  }
}
