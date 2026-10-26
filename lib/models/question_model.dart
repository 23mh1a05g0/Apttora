class Question {
  final String question;
  final List<String> options;
  final int correctAnswer; 
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] as String,
      options: List<String>.from(map['options'] as List),
      correctAnswer: map['correctAnswer'] as int,
      explanation: map['explanation'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}
