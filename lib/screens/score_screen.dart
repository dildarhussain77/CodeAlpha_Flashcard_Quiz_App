import 'package:flutter/material.dart';
import 'package:flashcard_quiz_app/screens/home_screen.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final int total;

  const ScoreScreen({
    super.key,
    required this.score,
    required this.total,
  });

  double get percentage => (score / total) * 100;

  String get resultMessage {
    if (percentage >= 90) return 'Excellent! 🎉';
    if (percentage >= 70) return 'Good job! 👍';
    if (percentage >= 50) return 'Not bad! 😊';
    return 'Keep practicing! 📚';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Quiz Results',style: TextStyle(color: Colors.white),)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  resultMessage,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: percentage / 100,
                        strokeWidth: 12,
                        color: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '$score / $total',
                          style: theme.textTheme.headlineLarge,
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.home),
                  label: const Text('Back to Home'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}