import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'home.dart';

class PlayTopicPage extends StatefulWidget {
  final String topicId;
  final String topicName;
  final String? topicCode;

  const PlayTopicPage({
    super.key,
    required this.topicId,
    required this.topicName,
    this.topicCode,
  });

  @override
  State<PlayTopicPage> createState() => _PlayTopicPageState();
}

class Question {
  final String id;
  final String questionText;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionText,
    required this.answers,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    final answersData = map['Antworten'] as List<dynamic>? ?? [];

    List<Answer> answers = answersData.map((a) {
      return Answer(
        id: a['id_antwort'].toString(),
        text: a['antwort'] ?? '',
        isCorrect: a['richtig'] ?? false,
      );
    }).toList();

    return Question(
      id: map['id_frage'].toString(),
      questionText: map['frage'] ?? '',
      answers: answers,
    );
  }
}

class Answer {
  final String id;
  final String text;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}

class _PlayTopicPageState extends State<PlayTopicPage> {
  static final _logger = Logger('PlayTopicPage');
  final supabase = Supabase.instance.client;

  List<Question> questions = [];
  int currentIndex = 0;
  int correctAnswers = 0;
  int? selectedAnswerIndex;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing PlayTopicPage for topic: ${widget.topicName}');
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    _logger.info('Loading questions for topic: ${widget.topicName}');
    setState(() {
      isLoading = true;
    });

    try {
      _logger.fine('Fetching questions from database for topic ID: ${widget.topicId}');
      final response = await supabase
          .from('Fragen')
          .select('id_frage, frage, Antworten(id_antwort, antwort, richtig)')
          .eq('fk_id_themen', widget.topicId)
          .execute();

      final data = response.data as List<dynamic>;
      questions = data.map((e) => Question.fromMap(e)).toList();
      _logger.info('Successfully loaded ${questions.length} questions');

      if (questions.isEmpty) {
        _logger.warning('No questions found for topic: ${widget.topicName}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Keine Fragen gefunden.')),
        );
      }
    } catch (e) {
      _logger.severe('Error loading questions', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Fragen: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _nextQuestion() {
    if (selectedAnswerIndex == null) {
      _logger.warning('Attempted to proceed without selecting an answer');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte eine Antwort auswählen')),
      );
      return;
    }

    _logger.fine('Processing answer for question ${currentIndex + 1}');
    if (questions[currentIndex].answers[selectedAnswerIndex!].isCorrect) {
      correctAnswers++;
      _logger.info('Correct answer given for question ${currentIndex + 1}');
    } else {
      _logger.info('Incorrect answer given for question ${currentIndex + 1}');
    }

    setState(() {
      selectedAnswerIndex = null;
      currentIndex++;
    });

    if (currentIndex >= questions.length) {
      _logger.info('Quiz completed. Final score: $correctAnswers/${questions.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building PlayTopicPage state');
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topicName),
          leading: BackButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }),
        ),
        body: const Center(
          child: Text('Keine Fragen verfügbar.'),
        ),
      );
    }

    // Quiz Ende
    if (currentIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topicName),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quiz beendet!\nDu hast $correctAnswers von ${questions.length} Fragen richtig beantwortet.',
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  },
                  child: const Text('Zurück zur Startseite'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicName),
        leading: BackButton(onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frage ${currentIndex + 1} von ${questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(question.answers.length, (index) {
              final answer = question.answers[index];
              return RadioListTile<int>(
                value: index,
                groupValue: selectedAnswerIndex,
                title: Text(answer.text.isNotEmpty ? answer.text : '– keine Antwort –'),
                onChanged: (value) {
                  setState(() {
                    selectedAnswerIndex = value;
                  });
                },
              );
            }),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                child: const Text('Weiter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
