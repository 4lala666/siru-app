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
            moduleId: 'governance',
            wrongCount: 2,
            lastWrongAt: DateTime(2026, 1, 10),
          ),
          Mistake(
            questionId: 'q3',
            moduleId: 'social',
            wrongCount: 1,
            lastWrongAt: DateTime(2026, 1, 11),
          ),
          Mistake(
            questionId: 'q5',
            moduleId: 'network',
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

  void addMistake(String questionId, String moduleId) {
    final int index = state.indexWhere((Mistake m) => m.questionId == questionId);
    if (index == -1) {
      state = <Mistake>[
        ...state,
        Mistake(
          questionId: questionId,
          moduleId: moduleId,
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
    );

    final List<Mistake> clone = <Mistake>[...state];
    clone[index] = updated;
    state = clone;
  }

  Future<List<QuizQuestion>> getRandom10Questions() async {
    final List<QuizQuestion> bank = await _loadQuestions();
    final Set<String> mistakeIds = state.map((Mistake m) => m.questionId).toSet();

    final List<QuizQuestion> pool = bank
        .where((QuizQuestion q) => mistakeIds.contains(q.questionId))
        .toList();

    if (pool.isEmpty) {
      return <QuizQuestion>[];
    }

    final Random rng = Random();
    pool.shuffle(rng);

    if (pool.length <= 10) return pool;
    return pool.take(10).toList();
  }
}

