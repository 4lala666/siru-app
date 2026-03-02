class Mistake {
  const Mistake({
    required this.questionId,
    required this.moduleId,
    required this.wrongCount,
    required this.lastWrongAt,
  });

  final String questionId;
  final String moduleId;
  final int wrongCount;
  final DateTime lastWrongAt;

  Mistake copyWith({
    String? questionId,
    String? moduleId,
    int? wrongCount,
    DateTime? lastWrongAt,
  }) {
    return Mistake(
      questionId: questionId ?? this.questionId,
      moduleId: moduleId ?? this.moduleId,
      wrongCount: wrongCount ?? this.wrongCount,
      lastWrongAt: lastWrongAt ?? this.lastWrongAt,
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.questionId,
    required this.moduleId,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  final String questionId;
  final String moduleId;
  final String question;
  final List<String> options;
  final int correctIndex;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionId: json['questionId'] as String,
      moduleId: json['moduleId'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).map((dynamic e) => e.toString()).toList(),
      correctIndex: json['correctIndex'] as int,
    );
  }
}

