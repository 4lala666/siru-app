import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../mistakes/data/mistakes_service.dart';
import '../../mistakes/domain/mistake.dart';
import '../domain/module_models.dart';

class ModuleTopicArgs {
  const ModuleTopicArgs({
    required this.moduleTitle,
    required this.lesson,
  });

  final String moduleTitle;
  final Lesson lesson;
}

class ModuleTopicPage extends ConsumerWidget {
  const ModuleTopicPage({
    super.key,
    required this.args,
  });

  final ModuleTopicArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String lang = Localizations.localeOf(context).languageCode;
    final String lessonTitle = tr(args.lesson.title, lang);
    final String summary = tr(args.lesson.summary, lang);
    final List<String> whatYouWillLearn =
        args.lesson.whatYouWillLearn[lang] ?? args.lesson.whatYouWillLearn['ru'] ?? const <String>[];
    final List<String> keyFacts =
        args.lesson.keyFacts[lang] ?? args.lesson.keyFacts['ru'] ?? const <String>[];
    final List<String> examples =
        args.lesson.examples[lang] ?? args.lesson.examples['ru'] ?? const <String>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(_t(lang, 'lesson')),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(
              args.moduleTitle,
              style: AppTextStyles.secondary,
            ),
            const SizedBox(height: 6),
            Text(lessonTitle, style: AppTextStyles.screenTitle),
            const SizedBox(height: 12),
            _SectionCard(
              title: _t(lang, 'description'),
              child: Text(
                summary.isNotEmpty ? summary : _t(lang, 'comingSoonDescription'),
                style: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: _t(lang, 'whatYouWillLearn'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildBulletList(
                  whatYouWillLearn.isNotEmpty
                      ? whatYouWillLearn
                      : <String>[_t(lang, 'comingSoonBullet')],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: _t(lang, 'keyFacts'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildBulletList(
                  keyFacts.isNotEmpty ? keyFacts : <String>[_t(lang, 'comingSoonFacts')],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: _t(lang, 'examples'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildBulletList(
                  examples.isNotEmpty ? examples : <String>[_t(lang, 'comingSoonExamples')],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: _t(lang, 'sources'),
              child: args.lesson.sources.isEmpty
                  ? Text(_t(lang, 'comingSoonSources'), style: AppTextStyles.body)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: args.lesson.sources
                          .map(
                            (LessonSource source) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('• ${tr(source.title, lang)}', style: AppTextStyles.body),
                                  const SizedBox(height: 4),
                                  Text(source.url, style: AppTextStyles.secondary),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startLessonQuiz(context, ref, lang),
                child: Text(_t(lang, 'startQuiz')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startLessonQuiz(BuildContext context, WidgetRef ref, String lang) async {
    final List<QuizQuestion> questions =
        await ref.read(mistakesServiceProvider.notifier).getQuestionsForLesson(args.lesson.id);

    if (!context.mounted) return;

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t(lang, 'noQuizYet'))),
      );
      return;
    }

    context.push('/lesson-quiz', extra: questions);
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'lesson': <String, String>{
        'ru': 'Урок',
        'en': 'Lesson',
        'kk': 'Сабақ',
      },
      'description': <String, String>{
        'ru': 'Описание',
        'en': 'Description',
        'kk': 'Сипаттама',
      },
      'whatYouWillLearn': <String, String>{
        'ru': 'Что вы изучите',
        'en': 'What you will learn',
        'kk': 'Нені үйренесіз',
      },
      'keyFacts': <String, String>{
        'ru': 'Ключевые факты',
        'en': 'Key facts',
        'kk': 'Негізгі фактілер',
      },
      'examples': <String, String>{
        'ru': 'Примеры',
        'en': 'Examples',
        'kk': 'Мысалдар',
      },
      'sources': <String, String>{
        'ru': 'Источники',
        'en': 'Sources',
        'kk': 'Дереккөздер',
      },
      'startQuiz': <String, String>{
        'ru': 'Начать тест',
        'en': 'Start Quiz',
        'kk': 'Тесті бастау',
      },
      'comingSoonDescription': <String, String>{
        'ru': 'Подробное описание урока скоро будет добавлено.',
        'en': 'A detailed lesson description will be added soon.',
        'kk': 'Сабақтың толық сипаттамасы жақында қосылады.',
      },
      'comingSoonBullet': <String, String>{
        'ru': 'Цели обучения для этого урока будут добавлены следующим этапом.',
        'en': 'Learning goals for this lesson will be added in the next iteration.',
        'kk': 'Бұл сабақтың оқу мақсаттары келесі кезеңде қосылады.',
      },
      'comingSoonFacts': <String, String>{
        'ru': 'Ключевые факты для этого урока будут добавлены следующим этапом.',
        'en': 'Key facts for this lesson will be added in the next iteration.',
        'kk': 'Бұл сабақтың негізгі фактілері келесі кезеңде қосылады.',
      },
      'comingSoonExamples': <String, String>{
        'ru': 'Практические примеры для этого урока будут добавлены следующим этапом.',
        'en': 'Practical examples for this lesson will be added in the next iteration.',
        'kk': 'Бұл сабақтың практикалық мысалдары келесі кезеңде қосылады.',
      },
      'comingSoonSources': <String, String>{
        'ru': 'Источники для этого урока будут добавлены следующим этапом.',
        'en': 'Sources for this lesson will be added in the next iteration.',
        'kk': 'Бұл сабақтың дереккөздері келесі кезеңде қосылады.',
      },
      'noQuizYet': <String, String>{
        'ru': 'Для этого урока пока нет вопросов.',
        'en': 'There are no questions for this lesson yet.',
        'kk': 'Бұл сабаққа арналған сұрақтар әзірге жоқ.',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }

  List<Widget> _buildBulletList(List<String> items) {
    return items
        .map(
          (String item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('• $item', style: AppTextStyles.body),
          ),
        )
        .toList();
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
