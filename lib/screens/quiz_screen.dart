import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashcard_quiz_app/models/flashcard_model.dart';
import 'package:flashcard_quiz_app/providers/flashcard_provider.dart';
import 'package:flashcard_quiz_app/screens/score_screen.dart';
import 'package:flashcard_quiz_app/widgets/quiz_progress_indicator.dart';

class QuizScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  const QuizScreen({super.key, required this.flashcards});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Flashcard> _quizFlashcards;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  String? _selectedAnswer;
  bool _showAnswer = false;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _quizFlashcards = List.from(widget.flashcards)..shuffle();
    _prepareQuestion();
  }

  void _prepareQuestion() {
    final currentFlashcard = _quizFlashcards[_currentIndex];
    final allAnswers = _quizFlashcards
        .where((card) => card.id != currentFlashcard.id)
        .map((card) => card.answer)
        .toList()
      ..shuffle();

    _options = [currentFlashcard.answer, ...allAnswers.take(3)]..shuffle();
    _selectedAnswer = null;
    _showAnswer = false;
  }

  void _nextQuestion() {
    if (_currentIndex + 1 < _quizFlashcards.length) {
      setState(() {
        _currentIndex++;
        _prepareQuestion();
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final provider = Provider.of<FlashcardProvider>(context, listen: false);
    
    // Update stats for each flashcard
    for (int i = 0; i < _quizFlashcards.length; i++) {
      final wasCorrect = i < _correctAnswers;
      provider.updateFlashcardStats(_quizFlashcards[i].id, wasCorrect);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScoreScreen(
          score: _correctAnswers,
          total: _quizFlashcards.length,
        ),
      ),
    );
  }

  void _checkAnswer(String selectedAnswer) {
    final isCorrect =
        selectedAnswer == _quizFlashcards[_currentIndex].answer;
    
    setState(() {
      _selectedAnswer = selectedAnswer;
      _showAnswer = true;
      if (isCorrect) {
        _correctAnswers++;
      }
    });

    Future.delayed(const Duration(seconds: 1), _nextQuestion);
  }

  @override
  Widget build(BuildContext context) {
    final currentFlashcard = _quizFlashcards[_currentIndex];
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,            
            children: [              
              QuizProgressIndicator(
                current: _currentIndex + 1,
                total: _quizFlashcards.length,          
              ),
            ],
          ),
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Leave Quiz?'),
                    content: const Text(
                        'Your progress will not be saved if you leave now.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Leave'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Question',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentFlashcard.question,
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Select the correct answer:',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    final isCorrect = option == currentFlashcard.answer;
                    final isSelected = _selectedAnswer == option;
      
                    Color? backgroundColor;
                    Color? foregroundColor;
      
                    if (_showAnswer) {
                      if (isCorrect) {
                        backgroundColor = Colors.green.shade100;
                        foregroundColor = Colors.green.shade900;
                      } else if (isSelected) {
                        backgroundColor = Colors.red.shade100;
                        foregroundColor = Colors.red.shade900;
                      }
                    }
      
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        foregroundColor: foregroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selectedAnswer == null
                          ? () => _checkAnswer(option)
                          : null,
                      child: Text(
                        option,
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}