import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashcard_quiz_app/providers/flashcard_provider.dart';

class EditFlashcardScreen extends StatelessWidget {
  final String id;
  final String currentQuestion;
  final String currentAnswer;

  const EditFlashcardScreen({
    super.key,
    required this.id,
    required this.currentQuestion,
    required this.currentAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final questionController = TextEditingController(text: currentQuestion);
    final answerController = TextEditingController(text: currentAnswer);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Flashcard',style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
          ),
          
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Provider.of<FlashcardProvider>(context, listen: false).updateFlashcard(
                  id,
                  questionController.text.trim(),
                  answerController.text.trim(),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}