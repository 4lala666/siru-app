import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/mistake.dart';

final mistakesServiceProvider =
    StateNotifierProvider<MistakesService, List<Mistake>>((Ref ref) {
  return MistakesService();
});

class MistakesService extends StateNotifier<List<Mistake>> {
  MistakesService()
      : super(<Mistake>[
          Mistake(
            questionId: 'q1',
            moduleId: 'gov_risk',
            lessonId: 'gov_02',
            difficulty: 'easy',
            wrongCount: 2,
            lastWrongAt: DateTime(2026, 1, 10),
          ),
          Mistake(
            questionId: 'q3',
            moduleId: 'social_eng',
            lessonId: 'se_02',
            difficulty: 'easy',
            wrongCount: 1,
            lastWrongAt: DateTime(2026, 1, 11),
          ),
          Mistake(
            questionId: 'q5',
            moduleId: 'network_sec',
            lessonId: 'net_05',
            difficulty: 'easy',
            wrongCount: 1,
            lastWrongAt: DateTime(2026, 1, 12),
          ),
        ]);

  Future<List<QuizQuestion>> _loadQuestions() async {
    final String raw = await rootBundle.loadString('assets/data/questions.json');
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((dynamic item) => QuizQuestion.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  void addMistake(
    String questionId,
    String moduleId,
    String lessonId,
    String difficulty,
  ) {
    final int index = state.indexWhere((Mistake m) => m.questionId == questionId);
    if (index == -1) {
      state = <Mistake>[
        ...state,
        Mistake(
          questionId: questionId,
          moduleId: moduleId,
          lessonId: lessonId,
          difficulty: difficulty,
          wrongCount: 1,
          lastWrongAt: DateTime.now(),
        ),
      ];
      return;
    }

    final Mistake old = state[index];
    final Mistake updated = old.copyWith(
      wrongCount: old.wrongCount + 1,
      lastWrongAt: DateTime.now(),
      lessonId: lessonId,
      difficulty: difficulty,
    );

    final List<Mistake> clone = <Mistake>[...state];
    clone[index] = updated;
    state = clone;
  }

  Future<List<QuizQuestion>> getRandom10Questions() async {
    final List<QuizQuestion> bank = await _loadQuestions();
    final Set<String> lessonIds = state.map((Mistake m) => m.lessonId).toSet();
    final Random rng = Random();

    final Map<String, QuizQuestion> bankById = <String, QuizQuestion>{
      for (final QuizQuestion question in bank) question.questionId: question,
    };

    final List<Mistake> selectedMistakes = state
        .where((Mistake m) => bankById.containsKey(m.questionId))
        .toList()
      ..sort((Mistake a, Mistake b) {
        final int byWrongCount = b.wrongCount.compareTo(a.wrongCount);
        if (byWrongCount != 0) return byWrongCount;
        final int byDifficulty =
            _difficultyWeight(b.difficulty).compareTo(_difficultyWeight(a.difficulty));
        if (byDifficulty != 0) return byDifficulty;
        return b.lastWrongAt.compareTo(a.lastWrongAt);
      });

    final List<QuizQuestion> chosen = selectedMistakes
        .map((Mistake mistake) => bankById[mistake.questionId]!)
        .take(10)
        .toList();

    final Set<String> chosenIds = chosen.map((QuizQuestion q) => q.questionId).toSet();

    if (chosen.length < 10) {
      final List<QuizQuestion> lessonPool = bank
          .where((QuizQuestion q) => lessonIds.contains(q.lessonId) && !chosenIds.contains(q.questionId))
          .toList()
        ..sort((QuizQuestion a, QuizQuestion b) {
          final int byDifficulty =
              _difficultyWeight(b.difficulty).compareTo(_difficultyWeight(a.difficulty));
          if (byDifficulty != 0) return byDifficulty;
          return rng.nextInt(3) - 1;
        });
      for (final QuizQuestion q in lessonPool) {
        if (chosen.length >= 10) break;
        chosen.add(q);
        chosenIds.add(q.questionId);
      }
    }

    if (chosen.length < 10) {
      final List<QuizQuestion> fallbackPool = bank
          .where((QuizQuestion q) => !chosenIds.contains(q.questionId))
          .toList()
        ..sort((QuizQuestion a, QuizQuestion b) {
          final int byDifficulty =
              _difficultyWeight(b.difficulty).compareTo(_difficultyWeight(a.difficulty));
          if (byDifficulty != 0) return byDifficulty;
          return rng.nextInt(3) - 1;
        });
      for (final QuizQuestion q in fallbackPool) {
        if (chosen.length >= 10) break;
        chosen.add(q);
      }
    }

    return chosen;
  }

  Future<List<QuizQuestion>> getQuestionsForLesson(String lessonId) async {
    final List<QuizQuestion> bank = await _loadQuestions();
    final List<QuizQuestion> lessonQuestions =
        bank.where((QuizQuestion q) => q.lessonId == lessonId).toList();

    if (lessonQuestions.isEmpty) {
      return <QuizQuestion>[];
    }

    final Random rng = Random();
    lessonQuestions.shuffle(rng);
    return lessonQuestions;
  }

  int _difficultyWeight(String difficulty) {
    switch (difficulty) {
      case 'hard':
        return 3;
      case 'medium':
        return 2;
      case 'easy':
      default:
        return 1;
    }
  }
}
