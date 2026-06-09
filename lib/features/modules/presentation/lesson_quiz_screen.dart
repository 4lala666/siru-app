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
    final String lang = Localizations.localeOf(context).languageCode;
    final AsyncValue<List<QuizQuestion>> quizAsync = ref.watch(_lessonQuizProvider(widget.args));

    return quizAsync.when(
      data: (List<QuizQuestion> questions) {
        if (questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(_t(lang, 'quiz'), style: AppTextStyles.cardTitle)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _t(lang, 'quizPreparing'),
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
            title: Text(
              '${_t(lang, 'question')} ${_index + 1} ${_t(lang, 'of')} ${questions.length}',
              style: AppTextStyles.cardTitle,
            ),
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
                      Text(q.localizedQuestion(lang), style: AppTextStyles.body),
                      const SizedBox(height: 10),
                      Text(
                        '${_difficultyLabel(lang, q.difficulty)} • ${_typeLabel(lang, q.type)}',
                        style: AppTextStyles.secondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      for (int i = 0; i < q.localizedOptions(lang).length; i++)
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
                            child: Text(q.localizedOptions(lang)[i]),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: hasAnswer ? () => _nextOrFinish(questions, lang) : null,
                  child: Text(_index == questions.length - 1 ? _t(lang, 'finish') : _t(lang, 'next')),
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
        appBar: AppBar(title: Text(_t(lang, 'quiz'), style: AppTextStyles.cardTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('${_t(lang, 'quizLoadFailed')}: $e', style: AppTextStyles.body),
          ),
        ),
      ),
    );
  }

  Future<void> _nextOrFinish(List<QuizQuestion> questions, String lang) async {
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
        ref.read(mistakesServiceProvider.notifier).addMistake(q.questionId, q.moduleId, q.lessonId, q.difficulty);
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

    await ref.read(quizAttemptStoreProvider).saveAttempt(attempt);
    String? attemptId;
    try {
      attemptId = await ref.read(quizResultsFirestoreServiceProvider).saveQuizAttempt(attempt);
      await ref.read(quizResultsFirestoreServiceProvider).saveWrongAnswers(
            moduleId: widget.args.moduleId,
            subtopicId: widget.args.lessonId,
            questions: questions,
            selectedAnswers: Map<String, int>.from(_answers),
            completedAt: attempt.completedAt,
            attemptId: attemptId,
            localeCode: lang,
          );
      await ref.read(quizResultsFirestoreServiceProvider).markLearningActivity(activityAt: attempt.completedAt);
      await ref.read(quizResultsFirestoreServiceProvider).updateModuleProgress(
            moduleId: widget.args.moduleId,
            subtopicId: widget.args.lessonId,
            lastQuizScore: attempt.score,
            activityAt: attempt.completedAt,
          );
      await ref.read(quizResultsFirestoreServiceProvider).updateUserStatsAfterQuiz(
            score: attempt.score,
            wrongAnswersCount: wrongQuestionIds.length,
            completedAt: attempt.completedAt,
          );
    } catch (e, st) {
      debugPrint('Failed to save quiz analytics to Firestore: $e');
      debugPrint('$st');
    }

    if (!mounted) return;
    context.go('/lesson-quiz/result', extra: <String, dynamic>{
      'correct': correct,
      'total': total,
      'backRoute': '/app/modules',
      'backLabel': _t(lang, 'backToModules'),
    });
  }

  String _difficultyLabel(String lang, String difficulty) {
    switch (difficulty) {
      case 'easy':
        return _t(lang, 'easy');
      case 'medium':
        return _t(lang, 'medium');
      case 'hard':
        return _t(lang, 'hard');
      default:
        return difficulty;
    }
  }

  String _typeLabel(String lang, String type) {
    switch (type) {
      case 'single_choice':
      case 'multiple_choice':
        return _t(lang, 'multipleChoice');
      case 'true_false':
        return _t(lang, 'trueFalse');
      case 'scenario':
      case 'mini_case':
        return _t(lang, 'scenario');
      default:
        return type;
    }
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'quiz': <String, String>{
        'ru': 'Тест',
        'en': 'Quiz',
        'kk': 'Тест',
      },
      'quizPreparing': <String, String>{
        'ru': 'Тест для этой подтемы пока готовится',
        'en': 'Quiz for this subtopic is in progress',
        'kk': 'Бұл ішкі тақырыпқа тест әзірленіп жатыр',
      },
      'question': <String, String>{
        'ru': 'Вопрос',
        'en': 'Question',
        'kk': 'Сұрақ',
      },
      'of': <String, String>{
        'ru': 'из',
        'en': 'of',
        'kk': '/',
      },
      'next': <String, String>{
        'ru': 'Далее',
        'en': 'Next',
        'kk': 'Келесі',
      },
      'finish': <String, String>{
        'ru': 'Завершить',
        'en': 'Finish',
        'kk': 'Аяқтау',
      },
      'quizLoadFailed': <String, String>{
        'ru': 'Не удалось загрузить тест',
        'en': 'Failed to load quiz',
        'kk': 'Тестті жүктеу мүмкін болмады',
      },
      'easy': <String, String>{
        'ru': 'Лёгкий',
        'en': 'Easy',
        'kk': 'Жеңіл',
      },
      'medium': <String, String>{
        'ru': 'Средний',
        'en': 'Medium',
        'kk': 'Орташа',
      },
      'hard': <String, String>{
        'ru': 'Сложный',
        'en': 'Hard',
        'kk': 'Қиын',
      },
      'multipleChoice': <String, String>{
        'ru': 'Выбор ответа',
        'en': 'Multiple choice',
        'kk': 'Жауап таңдау',
      },
      'trueFalse': <String, String>{
        'ru': 'Верно / Неверно',
        'en': 'True / False',
        'kk': 'Дұрыс / Бұрыс',
      },
      'scenario': <String, String>{
        'ru': 'Сценарий',
        'en': 'Scenario',
        'kk': 'Сценарий',
      },
      'backToModules': <String, String>{
        'ru': 'Назад к модулям',
        'en': 'Back to modules',
        'kk': 'Модульдерге оралу',
      },
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}
