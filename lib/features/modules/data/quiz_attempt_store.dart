import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizAttemptResult {
  const QuizAttemptResult({
    required this.moduleId,
    required this.subtopicId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongQuestionIds,
    required this.selectedAnswers,
    required this.completedAt,
  });

  final String moduleId;
  final String subtopicId;
  final double score;
  final int totalQuestions;
  final int correctAnswers;
  final List<String> wrongQuestionIds;
  final Map<String, int> selectedAnswers;
  final DateTime completedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'moduleId': moduleId,
      'subtopicId': subtopicId,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongQuestionIds': wrongQuestionIds,
      'selectedAnswers': selectedAnswers,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}

final quizAttemptStoreProvider = Provider<QuizAttemptStore>((Ref ref) {
  return QuizAttemptStore();
});

class QuizAttemptStore {
  static const String _storageKey = 'lesson_quiz_attempts_v1';

  Future<void> saveAttempt(QuizAttemptResult attempt) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_storageKey) ?? <String>[];
    raw.add(jsonEncode(attempt.toJson()));
    await prefs.setStringList(_storageKey, raw);
  }
}
