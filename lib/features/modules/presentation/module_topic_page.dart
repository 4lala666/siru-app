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
    final List<String> schemeSteps = _schemeSteps(
      whatYouWillLearn: whatYouWillLearn,
      keyFacts: keyFacts,
      examples: examples,
      lang: lang,
    );

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
            _FactHighlightCard(
              title: _t(lang, 'factCardTitle'),
              fact: _factText(
                keyFacts: keyFacts,
                summary: summary,
                lang: lang,
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
            _WarningCard(
              title: _t(lang, 'warningCardTitle'),
              text: _warningText(
                examples: examples,
                keyFacts: keyFacts,
                lang: lang,
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
            _ComparisonBlock(
              title: _t(lang, 'comparisonTitle'),
              leftTitle: _t(lang, 'comparisonLeft'),
              rightTitle: _t(lang, 'comparisonRight'),
              leftBody: _comparisonLeft(
                whatYouWillLearn: whatYouWillLearn,
                keyFacts: keyFacts,
                lang: lang,
              ),
              rightBody: _comparisonRight(
                examples: examples,
                keyFacts: keyFacts,
                lang: lang,
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
            _SchemePlaceholderCard(
              title: _t(lang, 'schemeTitle'),
              subtitle: _t(lang, 'schemeSubtitle'),
              steps: schemeSteps,
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
      'factCardTitle': <String, String>{
        'ru': 'Факт для запоминания',
        'en': 'Fact to remember',
        'kk': 'Есте сақтайтын факт',
      },
      'warningCardTitle': <String, String>{
        'ru': 'Важное предупреждение',
        'en': 'Important warning',
        'kk': 'Маңызды ескерту',
      },
      'comparisonTitle': <String, String>{
        'ru': 'Сравнение',
        'en': 'Comparison',
        'kk': 'Салыстыру',
      },
      'comparisonLeft': <String, String>{
        'ru': 'Ключевая идея',
        'en': 'Core idea',
        'kk': 'Негізгі идея',
      },
      'comparisonRight': <String, String>{
        'ru': 'Как это выглядит на практике',
        'en': 'How it looks in practice',
        'kk': 'Тәжірибеде қалай көрінеді',
      },
      'schemeTitle': <String, String>{
        'ru': 'Схема урока',
        'en': 'Lesson scheme',
        'kk': 'Сабақ сызбасы',
      },
      'schemeSubtitle': <String, String>{
        'ru': 'Наглядный путь по ключевым шагам темы',
        'en': 'A visual path through the topic steps',
        'kk': 'Тақырыптың негізгі қадамдарының көрнекі жолы',
      },
      'schemeFallbackOne': <String, String>{
        'ru': 'Определить проблему',
        'en': 'Define the problem',
        'kk': 'Мәселені анықтау',
      },
      'schemeFallbackTwo': <String, String>{
        'ru': 'Понять риск',
        'en': 'Understand the risk',
        'kk': 'Тәуекелді түсіну',
      },
      'schemeFallbackThree': <String, String>{
        'ru': 'Применить защиту',
        'en': 'Apply protection',
        'kk': 'Қорғанысты қолдану',
      },
      'comparisonFallbackLeft': <String, String>{
        'ru': 'Сначала разберитесь в терминах и границах темы.',
        'en': 'Start by understanding the terms and boundaries of the topic.',
        'kk': 'Алдымен тақырыптың терминдері мен шекарасын түсініңіз.',
      },
      'comparisonFallbackRight': <String, String>{
        'ru': 'Затем свяжите теорию с рабочим сценарием или реальной ситуацией.',
        'en': 'Then connect the theory to a workflow or real-world scenario.',
        'kk': 'Содан кейін теорияны жұмыс барысымен немесе нақты жағдаймен байланыстырыңыз.',
      },
      'warningFallback': <String, String>{
        'ru': 'Не применяйте материал урока вне учебного и законного контекста.',
        'en': 'Do not use lesson material outside an educational and lawful context.',
        'kk': 'Сабақ материалын оқу және заңды контекстен тыс қолданбаңыз.',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }

  String _factText({
    required List<String> keyFacts,
    required String summary,
    required String lang,
  }) {
    if (keyFacts.isNotEmpty) return keyFacts.first;
    if (summary.isNotEmpty) return summary;
    return _t(lang, 'comingSoonFacts');
  }

  String _warningText({
    required List<String> examples,
    required List<String> keyFacts,
    required String lang,
  }) {
    if (examples.isNotEmpty) return examples.first;
    if (keyFacts.length > 1) return keyFacts[1];
    if (keyFacts.isNotEmpty) return keyFacts.first;
    return _t(lang, 'warningFallback');
  }

  String _comparisonLeft({
    required List<String> whatYouWillLearn,
    required List<String> keyFacts,
    required String lang,
  }) {
    if (whatYouWillLearn.isNotEmpty) return whatYouWillLearn.first;
    if (keyFacts.isNotEmpty) return keyFacts.first;
    return _t(lang, 'comparisonFallbackLeft');
  }

  String _comparisonRight({
    required List<String> examples,
    required List<String> keyFacts,
    required String lang,
  }) {
    if (examples.isNotEmpty) return examples.first;
    if (keyFacts.length > 1) return keyFacts[1];
    return _t(lang, 'comparisonFallbackRight');
  }

  List<String> _schemeSteps({
    required List<String> whatYouWillLearn,
    required List<String> keyFacts,
    required List<String> examples,
    required String lang,
  }) {
    final List<String> pool = <String>[
      ...whatYouWillLearn,
      ...keyFacts,
      ...examples,
    ].where((String item) => item.trim().isNotEmpty).toList();

    if (pool.length >= 3) {
      return pool.take(3).toList();
    }

    return <String>[
      _t(lang, 'schemeFallbackOne'),
      _t(lang, 'schemeFallbackTwo'),
      _t(lang, 'schemeFallbackThree'),
    ];
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

class _FactHighlightCard extends StatelessWidget {
  const _FactHighlightCard({
    required this.title,
    required this.fact,
  });

  final String title;
  final String fact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.65)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.lightbulb_outline, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                Text(fact, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x33FF6B6B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x66FF6B6B)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB4A2)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                Text(text, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonBlock extends StatelessWidget {
  const _ComparisonBlock({
    required this.title,
    required this.leftTitle,
    required this.rightTitle,
    required this.leftBody,
    required this.rightBody,
  });

  final String title;
  final String leftTitle;
  final String rightTitle;
  final String leftBody;
  final String rightBody;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _ComparisonCell(
              title: leftTitle,
              body: leftBody,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ComparisonCell(
              title: rightTitle,
              body: rightBody,
              color: AppColors.primaryButton.withValues(alpha: 0.22),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonCell extends StatelessWidget {
  const _ComparisonCell({
    required this.title,
    required this.body,
    required this.color,
  });

  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.chip),
          const SizedBox(height: 8),
          Text(body, style: AppTextStyles.body),
        ],
      ),
    );
  }
}

class _SchemePlaceholderCard extends StatelessWidget {
  const _SchemePlaceholderCard({
    required this.title,
    required this.subtitle,
    required this.steps,
  });

  final String title;
  final String subtitle;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(subtitle, style: AppTextStyles.secondary),
          const SizedBox(height: 14),
          for (int i = 0; i < steps.length; i++) ...<Widget>[
            _SchemeStep(
              index: i + 1,
              text: steps[i],
              isLast: i == steps.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _SchemeStep extends StatelessWidget {
  const _SchemeStep({
    required this.index,
    required this.text,
    required this.isLast,
  });

  final int index;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primaryButton,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text('$index', style: AppTextStyles.chip),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: Colors.white.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Text(text, style: AppTextStyles.body),
            ),
          ),
        ),
      ],
    );
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
