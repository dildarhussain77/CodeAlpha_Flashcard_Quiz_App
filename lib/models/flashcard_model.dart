class Flashcard {
  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;
  final int timesReviewed;
  final int correctAnswers;

  // Main constructor (all fields required)
  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.timesReviewed,
    required this.correctAnswers,
  });

  // Factory constructor for creating new flashcards
  factory Flashcard.create({
    required String question,
    required String answer,
    DateTime? createdAt,
  }) {
    return Flashcard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: question,
      answer: answer,
      createdAt: createdAt ?? DateTime.now(),
      timesReviewed: 0,
      correctAnswers: 0,
    );
  }

  double get masteryLevel {
    if (timesReviewed == 0) return 0;
    return correctAnswers / timesReviewed;
  }

  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    DateTime? createdAt,
    int? timesReviewed,
    int? correctAnswers,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      correctAnswers: correctAnswers ?? this.correctAnswers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'createdAt': createdAt.toIso8601String(),
      'timesReviewed': timesReviewed,
      'correctAnswers': correctAnswers,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      createdAt: DateTime.parse(map['createdAt']),
      timesReviewed: map['timesReviewed'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
    );
  }
}