import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../mistakes/data/mistakes_service.dart';
import '../../mistakes/domain/mistake.dart';
import '../data/quiz_attempt_store.dart';
import '../data/quiz_results_firestore_service.dart';

class LessonQuizArgs {
  const LessonQuizArgs({
    required this.moduleId,
    required this.lessonId,
  });

  final String moduleId;
  final String lessonId;
}

final _lessonQuizProvider = FutureProvider.family<List<QuizQuestion>, LessonQuizArgs>(
  (Ref ref, LessonQuizArgs args) {
    return ref.read(mistakesServiceProvider.notifier).getQuestionsForSubtopic(
          moduleId: args.moduleId,
          lessonId: args.lessonId,
          limit: 10,
        );
  },
);

class LessonQuizScreen extends ConsumerStatefulWidget {
  const LessonQuizScreen({
    super.key,
    required this.args,
  });

  final LessonQuizArgs args;

  @override
  ConsumerState<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends ConsumerState<LessonQuizScreen> {
  int _index = 0;
  final Map<String, int> _answers = <String, int>{};

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<QuizQuestion>> quizAsync = ref.watch(_lessonQuizProvider(widget.args));

    return quizAsync.when(
      data: (List<QuizQuestion> questions) {
        if (questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Тест', style: AppTextStyles.cardTitle)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Тест для этой подтемы пока готовится',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ),
            ),
          );
        }

        final QuizQuestion q = questions[_index];
        final int selectedIndex = _answers[q.questionId] ?? -1;
        final bool hasAnswer = selectedIndex >= 0;

        return Scaffold(
          appBar: AppBar(
            title: Text('Вопрос ${_index + 1} из ${questions.length}', style: AppTextStyles.cardTitle),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(q.question, style: AppTextStyles.body),
                      const SizedBox(height: 10),
                      Text(
                        '${_difficultyLabel(q.difficulty)} • ${_typeLabel(q.type)}',
                        style: AppTextStyles.secondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      for (int i = 0; i < q.options.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  selectedIndex == i ? AppColors.primaryButton : AppColors.cardBackground,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            onPressed: () {
                              setState(() {
                                _answers[q.questionId] = i;
                              });
                            },
                            child: Text(q.options[i]),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: hasAnswer ? () => _nextOrFinish(questions) : null,
                  child: Text(_index == questions.length - 1 ? 'Завершить' : 'Далее'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (Object e, _) => Scaffold(
        appBar: AppBar(title: Text('Тест', style: AppTextStyles.cardTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Не удалось загрузить тест: $e', style: AppTextStyles.body),
          ),
        ),
      ),
    );
  }

  Future<void> _nextOrFinish(List<QuizQuestion> questions) async {
    if (_index < questions.length - 1) {
      setState(() {
        _index++;
      });
      return;
    }

    int correct = 0;
    final List<String> wrongQuestionIds = <String>[];
    for (final QuizQuestion q in questions) {
      final int selected = _answers[q.questionId] ?? -1;
      if (selected == q.correctIndex) {
        correct++;
      } else {
        wrongQuestionIds.add(q.questionId);
        ref
            .read(mistakesServiceProvider.notifier)
            .addMistake(q.questionId, q.moduleId, q.lessonId, q.difficulty);
      }
    }

    final int total = questions.length;
    final double score = total == 0 ? 0 : correct / total;
    final QuizAttemptResult attempt = QuizAttemptResult(
      moduleId: widget.args.moduleId,
      subtopicId: widget.args.lessonId,
      score: score,
      totalQuestions: total,
      correctAnswers: correct,
      wrongQuestionIds: wrongQuestionIds,
      selectedAnswers: Map<String, int>.from(_answers),
      completedAt: DateTime.now(),
    );

    await ref.read(quizAttemptStoreProvider).saveAttempt(
          attempt,
        );
    await ref.read(quizResultsFirestoreServiceProvider).saveQuizAttempt(attempt);

    if (!mounted) return;
    context.go('/lesson-quiz/result', extra: <String, dynamic>{
      'correct': correct,
      'total': total,
      'backRoute': '/app/modules',
      'backLabel': 'Назад к модулям',
    });
  }

  String _difficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return difficulty;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'single_choice':
      case 'multiple_choice':
        return 'Multiple choice';
      case 'true_false':
        return 'True / False';
      case 'scenario':
      case 'mini_case':
        return 'Scenario';
      default:
        return type;
    }
  }
}
