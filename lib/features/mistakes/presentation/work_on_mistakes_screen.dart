import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/mistakes_service.dart';
import '../domain/mistake.dart';

class WorkOnMistakesScreen extends ConsumerWidget {
  const WorkOnMistakesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String lang = Localizations.localeOf(context).languageCode;
    final List<Mistake> mistakes = ref.watch(mistakesServiceProvider);
    final int uniqueLessons = mistakes.map((Mistake m) => m.lessonId).toSet().length;
    final int hardOrMedium = mistakes.where((Mistake m) => m.difficulty == 'medium' || m.difficulty == 'hard').length;

    return Scaffold(
      appBar: AppBar(title: Text(_t(lang, 'title'), style: AppTextStyles.cardTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
                Text('${_t(lang, 'pool')}: ${mistakes.length}', style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                Text(_t(lang, 'desc'), style: AppTextStyles.body),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _StatChip(label: _t(lang, 'lessons'), value: uniqueLessons.toString()),
                    _StatChip(label: _t(lang, 'mediumHard'), value: hardOrMedium.toString()),
                    _StatChip(label: _t(lang, 'feedback'), value: _t(lang, 'on')),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final List<QuizQuestion> questions = await ref.read(mistakesServiceProvider.notifier).getRandom10Questions();

                      if (!context.mounted) return;

                      if (questions.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_t(lang, 'noMistakesYet'))));
                        return;
                      }

                      context.push('/app/profile/mistakes/quiz', extra: questions);
                    },
                    child: Text(_t(lang, 'startTest10')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...mistakes.map(
            (Mistake m) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.report_problem_outlined, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('${m.moduleId} • ${m.lessonId} • ${_difficultyLabel(lang, m.difficulty)}', style: AppTextStyles.body),
                  ),
                  Text('x${m.wrongCount}', style: AppTextStyles.chip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _difficultyLabel(String lang, String difficulty) {
    switch (difficulty) {
      case 'hard':
        return _t(lang, 'hard');
      case 'medium':
        return _t(lang, 'medium');
      case 'easy':
      default:
        return _t(lang, 'easy');
    }
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'title': <String, String>{'ru': 'Работа над ошибками', 'en': 'Work on mistakes', 'kk': 'Қателермен жұмыс'},
      'pool': <String, String>{'ru': 'Пул ошибок', 'en': 'Mistake pool', 'kk': 'Қателер пулы'},
      'desc': <String, String>{
        'ru': 'Запустите адаптивный тест по вашим ошибкам, связанным урокам и текущему уровню сложности.',
        'en': 'Start an adaptive quiz built from your wrong answers, related lessons, and current difficulty level.',
        'kk': 'Қателеріңізге, байланысты сабақтарға және ағымдағы күрделілік деңгейіне негізделген бейімделмелі тестті бастаңыз.',
      },
      'lessons': <String, String>{'ru': 'Уроки', 'en': 'Lessons', 'kk': 'Сабақтар'},
      'mediumHard': <String, String>{'ru': 'Средний/Сложный', 'en': 'Medium/Hard', 'kk': 'Орташа/Қиын'},
      'feedback': <String, String>{'ru': 'Фидбек', 'en': 'Feedback', 'kk': 'Кері байланыс'},
      'on': <String, String>{'ru': 'Вкл', 'en': 'On', 'kk': 'Қосулы'},
      'noMistakesYet': <String, String>{'ru': 'Пока нет ошибок для сборки теста.', 'en': 'No mistakes yet to build a test.', 'kk': 'Тест құруға қателер әлі жоқ.'},
      'startTest10': <String, String>{'ru': 'Начать тест из 10 вопросов', 'en': 'Start 10-question test', 'kk': '10 сұрақтық тестті бастау'},
      'easy': <String, String>{'ru': 'Лёгкий', 'en': 'Easy', 'kk': 'Жеңіл'},
      'medium': <String, String>{'ru': 'Средний', 'en': 'Medium', 'kk': 'Орташа'},
      'hard': <String, String>{'ru': 'Сложный', 'en': 'Hard', 'kk': 'Қиын'},
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('$label: ', style: AppTextStyles.secondary),
          Text(value, style: AppTextStyles.chip),
        ],
      ),
    );
  }
}
