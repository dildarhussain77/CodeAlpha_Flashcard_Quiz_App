import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../screens/add_flashcard_screen.dart';
import '../screens/quiz_screen.dart';
import '../widgets/flashcard_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flashcardProvider = Provider.of<FlashcardProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text("Flashcard Quiz App", style: TextStyle(color: Colors.white),)),
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: flashcardProvider.flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcardProvider.flashcards[index];
                  return FlashcardTile(flashcard: flashcard);
                },
              ),
            ),
          ],
        ),
        
        // ✅ Correct Placement of Floating Action Buttons
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "start_quiz",
              child: const Icon(Icons.play_arrow),
              onPressed: () {
                if (flashcardProvider.flashcards.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen(flashcards: flashcardProvider.flashcards)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No flashcards available. Please add some first!")),
                  );
                }
              },
            ),
            const SizedBox(height: 10), // Spacing between buttons
            FloatingActionButton(
              heroTag: "add_flashcard",
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddFlashcardScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
