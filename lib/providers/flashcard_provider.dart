import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flashcard_quiz_app/models/flashcard_model.dart';

class FlashcardProvider with ChangeNotifier {
  late final Box _box;
  List<Flashcard> _flashcards = [];
  List<Flashcard> _filteredFlashcards = [];
  String _searchQuery = '';

  List<Flashcard> get flashcards => _filteredFlashcards;
  List<Flashcard> get allFlashcards => _flashcards;
  String get searchQuery => _searchQuery;

  FlashcardProvider() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox('flashcards');
    loadFlashcards();
  }

  void loadFlashcards() {
    _flashcards = _box.keys.map((key) {
      final data = _box.get(key);
      return Flashcard.fromMap(data);
    }).toList();
    _filterFlashcards();
    notifyListeners();
  }

  // Add this method to FlashcardProvider class
  void updateFlashcard(String id, String newQuestion, String newAnswer) {
    final index = _flashcards.indexWhere((card) => card.id == id);
    if (index != -1) {
      final oldFlashcard = _flashcards[index];
      final updatedFlashcard = oldFlashcard.copyWith(
        question: newQuestion,
        answer: newAnswer,
      );
      _flashcards[index] = updatedFlashcard;
      _box.put(id, updatedFlashcard.toMap());
      _filterFlashcards();
      notifyListeners();
    }
  }

  void _filterFlashcards() {
    if (_searchQuery.isEmpty) {
      _filteredFlashcards = List.from(_flashcards);
    } else {
      _filteredFlashcards = _flashcards.where((card) {
        return card.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            card.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterFlashcards();
    notifyListeners();
  }

  void addFlashcard(String question, String answer) {
    final flashcard = Flashcard.create(
      question: question,
      answer: answer,
    );
    _box.put(flashcard.id, flashcard.toMap());
    _flashcards.add(flashcard);
    _filterFlashcards();
    notifyListeners();
  }


  // Also update the method that updates stats
  void updateFlashcardStats(String id, bool wasCorrect) {
    final index = _flashcards.indexWhere((card) => card.id == id);
    if (index != -1) {
      final oldFlashcard = _flashcards[index];
      final updatedFlashcard = oldFlashcard.copyWith(
        timesReviewed: oldFlashcard.timesReviewed + 1,
        correctAnswers: wasCorrect 
            ? oldFlashcard.correctAnswers + 1 
            : oldFlashcard.correctAnswers,
      );
      _flashcards[index] = updatedFlashcard;
      _box.put(id, updatedFlashcard.toMap());
      notifyListeners();
    }
  }

  void deleteFlashcard(String id) {
    _box.delete(id);
    _flashcards.removeWhere((card) => card.id == id);
    _filterFlashcards();
    notifyListeners();
  }

  List<Flashcard> getFlashcardsForQuiz([int count = 10]) {
    // Create a new list with explicit type
    final List<Flashcard> shuffled = List<Flashcard>.from(_flashcards)..shuffle();
    
    // Take the first 'count' elements and convert to list
    return shuffled.take(count).toList();
  }
}