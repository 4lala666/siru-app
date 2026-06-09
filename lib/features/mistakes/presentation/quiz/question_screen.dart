import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/mistakes_service.dart';
import '../../domain/mistake.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({
    super.key,
    required this.questions,
    this.resultRoute = '/app/profile/mistakes/result',
    this.resultBackRoute = '/app/profile/mistakes',
    this.resultBackLabel = 'Back to mistakes',
  });

  final List<QuizQuestion> questions;
  final String resultRoute;
  final String resultBackRoute;
  final String resultBackLabel;

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  int _index = 0;
  final Map<String, int> _answers = <String, int>{};
  final Set<String> _revealed = <String>{};

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final QuizQuestion q = widget.questions[_index];
    final bool hasAnswer = _answers.containsKey(q.questionId);
    final bool isRevealed = _revealed.contains(q.questionId);
    final int selectedIndex = _answers[q.questionId] ?? -1;
    final bool isCorrect = selectedIndex == q.correctIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_t(lang, 'question')} ${_index + 1}/${widget.questions.length}',
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
                  ..._buildQuestionOptions(q, isRevealed, lang),
                  if (isRevealed) ...<Widget>[
                    const SizedBox(height: 6),
                    _ExplanationCard(
                      lang: lang,
                      isCorrect: isCorrect,
                      explanation: q.localizedExplanation(lang),
                      hint: q.hint,
                      source: q.source,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: !hasAnswer
                  ? null
                  : isRevealed
                      ? _next
                      : () => _reveal(q.questionId),
              child: Text(
                isRevealed
                    ? (_index == widget.questions.length - 1 ? _t(lang, 'finish') : _t(lang, 'next'))
                    : _t(lang, 'checkAnswer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuestionOptions(QuizQuestion question, bool isRevealed, String lang) {
    switch (question.type) {
      case 'true_false':
      case 'single_choice':
        return _buildChoiceButtons(question, isRevealed, lang);
      case 'matching':
      case 'mini_case':
      default:
        return <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.55)),
            ),
            child: Text(_t(lang, 'fallbackType'), style: AppTextStyles.body),
          ),
          const SizedBox(height: 12),
          ..._buildChoiceButtons(question, isRevealed, lang),
        ];
    }
  }

  List<Widget> _buildChoiceButtons(QuizQuestion q, bool isRevealed, String lang) {
    final List<String> options = q.localizedOptions(lang);
    return <Widget>[
      for (int i = 0; i < options.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _optionColor(q, i, isRevealed),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onPressed: isRevealed
                ? null
                : () {
                    setState(() {
                      _answers[q.questionId] = i;
                    });
                  },
            child: Text(options[i]),
          ),
        ),
    ];
  }

  void _reveal(String questionId) {
    setState(() {
      _revealed.add(questionId);
    });
  }

  Color _optionColor(QuizQuestion q, int optionIndex, bool isRevealed) {
    final int selected = _answers[q.questionId] ?? -1;
    if (!isRevealed) {
      return selected == optionIndex ? AppColors.primaryButton : AppColors.cardBackground;
    }
    if (optionIndex == q.correctIndex) {
      return Colors.green.withValues(alpha: 0.85);
    }
    if (optionIndex == selected && selected != q.correctIndex) {
      return Colors.red.withValues(alpha: 0.85);
    }
    return AppColors.cardBackground;
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
      case 'matching':
        return _t(lang, 'matching');
      case 'mini_case':
      case 'scenario':
        return _t(lang, 'scenario');
      default:
        return type;
    }
  }

  void _next() {
    if (_index < widget.questions.length - 1) {
      setState(() => _index++);
      return;
    }

    int correct = 0;
    for (final QuizQuestion q in widget.questions) {
      final int selected = _answers[q.questionId] ?? -1;
      if (selected == q.correctIndex) {
        correct++;
      } else {
        ref.read(mistakesServiceProvider.notifier).addMistake(q.questionId, q.moduleId, q.lessonId, q.difficulty);
      }
    }

    context.go(widget.resultRoute, extra: <String, dynamic>{
      'correct': correct,
      'total': widget.questions.length,
      'backRoute': widget.resultBackRoute,
      'backLabel': widget.resultBackLabel,
    });
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'question': <String, String>{'ru': 'Вопрос', 'en': 'Question', 'kk': 'Сұрақ'},
      'finish': <String, String>{'ru': 'Завершить', 'en': 'Finish', 'kk': 'Аяқтау'},
      'next': <String, String>{'ru': 'Далее', 'en': 'Next', 'kk': 'Келесі'},
      'checkAnswer': <String, String>{'ru': 'Проверить ответ', 'en': 'Check answer', 'kk': 'Жауапты тексеру'},
      'fallbackType': <String, String>{
        'ru': 'Этот тип вопроса пока реализован частично. Ниже показан временный формат single-choice.',
        'en': 'This question type is not fully implemented yet. A temporary single-choice fallback is shown below.',
        'kk': 'Бұл сұрақ түрі әзірге толық іске асырылмаған. Төменде уақытша single-choice форматы көрсетілген.',
      },
      'easy': <String, String>{'ru': 'Лёгкий', 'en': 'Easy', 'kk': 'Жеңіл'},
      'medium': <String, String>{'ru': 'Средний', 'en': 'Medium', 'kk': 'Орташа'},
      'hard': <String, String>{'ru': 'Сложный', 'en': 'Hard', 'kk': 'Қиын'},
      'multipleChoice': <String, String>{'ru': 'Выбор ответа', 'en': 'Multiple choice', 'kk': 'Жауап таңдау'},
      'trueFalse': <String, String>{'ru': 'Верно / Неверно', 'en': 'True / False', 'kk': 'Дұрыс / Бұрыс'},
      'matching': <String, String>{'ru': 'Сопоставление', 'en': 'Matching', 'kk': 'Сәйкестендіру'},
      'scenario': <String, String>{'ru': 'Сценарий', 'en': 'Scenario', 'kk': 'Сценарий'},
      'correctAnswer': <String, String>{'ru': 'Верный ответ', 'en': 'Correct answer', 'kk': 'Дұрыс жауап'},
      'wrongAnswer': <String, String>{'ru': 'Неверный ответ', 'en': 'Wrong answer', 'kk': 'Қате жауап'},
      'hint': <String, String>{'ru': 'Подсказка', 'en': 'Hint', 'kk': 'Кеңес'},
      'source': <String, String>{'ru': 'Источник', 'en': 'Source', 'kk': 'Дереккөз'},
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({
    required this.lang,
    required this.isCorrect,
    required this.explanation,
    required this.hint,
    required this.source,
  });

  final String lang;
  final bool isCorrect;
  final String explanation;
  final String hint;
  final QuestionSource? source;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? Colors.greenAccent.withValues(alpha: 0.7) : Colors.redAccent.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined, color: isCorrect ? Colors.greenAccent : Colors.redAccent),
              const SizedBox(width: 8),
              Text(isCorrect ? _t('correctAnswer') : _t('wrongAnswer'), style: AppTextStyles.cardTitle),
            ],
          ),
          const SizedBox(height: 12),
          Text(explanation, style: AppTextStyles.body),
          if (hint.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(_t('hint'), style: AppTextStyles.cardTitle),
            const SizedBox(height: 6),
            Text(hint, style: AppTextStyles.body),
          ],
          if (source != null && source!.title.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Text(_t('source'), style: AppTextStyles.cardTitle),
            const SizedBox(height: 6),
            Text(source!.title, style: AppTextStyles.body),
            if (source!.url.isNotEmpty) ...<Widget>[
              const SizedBox(height: 4),
              Text(source!.url, style: AppTextStyles.secondary),
            ],
          ],
        ],
      ),
    );
  }

  String _t(String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'correctAnswer': <String, String>{'ru': 'Верный ответ', 'en': 'Correct answer', 'kk': 'Дұрыс жауап'},
      'wrongAnswer': <String, String>{'ru': 'Неверный ответ', 'en': 'Wrong answer', 'kk': 'Қате жауап'},
      'hint': <String, String>{'ru': 'Подсказка', 'en': 'Hint', 'kk': 'Кеңес'},
      'source': <String, String>{'ru': 'Источник', 'en': 'Source', 'kk': 'Дереккөз'},
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}
