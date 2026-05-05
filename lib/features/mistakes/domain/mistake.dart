class Mistake {
  const Mistake({
    required this.questionId,
    required this.moduleId,
    required this.lessonId,
    required this.difficulty,
    required this.wrongCount,
    required this.lastWrongAt,
  });

  final String questionId;
  final String moduleId;
  final String lessonId;
  final String difficulty;
  final int wrongCount;
  final DateTime lastWrongAt;

  Mistake copyWith({
    String? questionId,
    String? moduleId,
    String? lessonId,
    String? difficulty,
    int? wrongCount,
    DateTime? lastWrongAt,
  }) {
    return Mistake(
      questionId: questionId ?? this.questionId,
      moduleId: moduleId ?? this.moduleId,
      lessonId: lessonId ?? this.lessonId,
      difficulty: difficulty ?? this.difficulty,
      wrongCount: wrongCount ?? this.wrongCount,
      lastWrongAt: lastWrongAt ?? this.lastWrongAt,
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.questionId,
    required this.moduleId,
    required this.lessonId,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.hint,
    required this.source,
  });

  final String questionId;
  final String moduleId;
  final String lessonId;
  final String type;
  final String difficulty;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String hint;
  final QuestionSource? source;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionId: json['questionId'] as String,
      moduleId: json['moduleId'] as String,
      lessonId: (json['lessonId'] ?? '').toString(),
      type: (json['type'] ?? 'single_choice').toString(),
      difficulty: (json['difficulty'] ?? 'easy').toString(),
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).map((dynamic e) => e.toString()).toList(),
      correctIndex: json['correctIndex'] as int,
      explanation: (json['explanation'] ?? '').toString(),
      hint: (json['hint'] ?? '').toString(),
      source: json['source'] is Map<String, dynamic>
          ? QuestionSource.fromJson(json['source'] as Map<String, dynamic>)
          : null,
    );
  }
}

class QuestionSource {
  const QuestionSource({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  factory QuestionSource.fromJson(Map<String, dynamic> json) {
    return QuestionSource(
      title: (json['title'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
    );
  }
}
