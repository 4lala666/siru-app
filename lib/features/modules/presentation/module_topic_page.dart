import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../mistakes/data/mistakes_service.dart';
import '../../mistakes/domain/mistake.dart';
import '../data/lesson_content_builder.dart';
import '../domain/lesson_content.dart';
import '../domain/module_models.dart';
import 'widgets/empty_lesson_state.dart';
import 'widgets/lesson_hero_card.dart';
import 'widgets/lesson_progress_card.dart';
import 'widgets/lesson_section_card.dart';
import 'widgets/lesson_sources_section.dart';
import 'widgets/lesson_top_bar.dart';
import 'widgets/start_quiz_sticky_button.dart';

class ModuleTopicArgs {
  const ModuleTopicArgs({
    required this.module,
    required this.lesson,
    required this.lessonIndex,
  });

  final Module module;
  final Lesson lesson;
  final int lessonIndex;
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
    final AsyncValue<List<QuizQuestion>> quizAsync = ref.watch(_lessonQuizProvider(args.lesson.id));

    return quizAsync.when(
      data: (List<QuizQuestion> quizQuestions) {
        final LessonContent content = LessonContentBuilder.build(
          module: args.module,
          lesson: args.lesson,
          lang: lang,
          quizQuestions: quizQuestions,
          lessonIndex: args.lessonIndex,
        );
        final bool quizEnabled = content.hasRealContent && quizQuestions.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: LessonTopBar(
            title: _t(lang, 'lesson'),
            action: const IconButton(
              onPressed: null,
              icon: Icon(Icons.auto_graph_rounded, color: AppColors.textSecondary),
            ),
          ),
          bottomNavigationBar: content.hasRealContent
              ? StartQuizStickyButton(
                  label: _t(lang, 'quizCtaLabel'),
                  enabledLabel: _t(lang, 'startQuiz'),
                  disabledLabel: _t(lang, 'quizSoon'),
                  enabled: quizEnabled,
                  onPressed: quizEnabled
                      ? () => context.push('/lesson-quiz', extra: quizQuestions)
                      : null,
                )
              : null,
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, content.hasRealContent ? 120 : 24),
              children: <Widget>[
                LessonHeroCard(
                  title: content.title,
                  moduleTitle: content.moduleTitle,
                  subtitle: content.subtitle,
                  icon: _heroIcon(content.heroIcon),
                  metaLabels: <String>[
                    _lessonMinutesMeta(lang, content.estimatedMinutes),
                    _lessonStepsMeta(lang, content.totalSteps),
                    content.difficulty,
                  ],
                ),
                const SizedBox(height: 14),
                if (content.hasRealContent) ...<Widget>[
                  LessonProgressCard(
                    progress: content.currentProgress,
                    totalSteps: content.totalSteps,
                  ),
                  const SizedBox(height: 14),
                  ..._buildSections(content.sections),
                  if (content.sources.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 14),
                    LessonSourcesSection(
                      title: _t(lang, 'sources'),
                      sources: content.sources,
                    ),
                  ],
                ] else
                  EmptyLessonState(
                    title: _t(lang, 'emptyStateTitle'),
                    description: _t(lang, 'emptyStateDescription'),
                    onBack: () => context.pop(),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: const LessonTopBar(title: 'Урок'),
        body: Center(
          child: Text(_t(lang, 'quizLoadFailed'), style: AppTextStyles.body),
        ),
      ),
    );
  }

  static String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'lesson': <String, String>{
        'ru': 'Урок',
        'en': 'Lesson',
        'kk': 'Саба?',
      },
      'sources': <String, String>{
        'ru': 'Источники',
        'en': 'Sources',
        'kk': 'Дерекк?здер',
      },
      'startQuiz': <String, String>{
        'ru': 'Начать тест',
        'en': 'Start Quiz',
        'kk': 'Тесті бастау',
      },
      'quizCtaLabel': <String, String>{
        'ru': 'Финальный шаг урока',
        'en': 'Final lesson step',
        'kk': 'Саба?ты? со??ы ?адамы',
      },
      'quizSoon': <String, String>{
        'ru': 'Тест скоро будет добавлен',
        'en': 'Quiz coming soon',
        'kk': 'Тест жа?ында ?осылады',
      },
      'emptyStateTitle': <String, String>{
        'ru': 'Контент готовится',
        'en': 'Content is in progress',
        'kk': 'Контент дайындалып жатыр',
      },
      'emptyStateDescription': <String, String>{
        'ru': 'Материал для этой подтемы будет добавлен позже. Пока можно вернуться к списку подтем и выбрать доступный урок.',
        'en': 'Material for this topic will be added later. You can return to the topic list and continue with an available lesson.',
        'kk': 'Б?л та?ырып?а материал кейінірек ?осылады. ?зірге ?олжетімді саба??а оралу?а болады.',
      },
      'quizLoadFailed': <String, String>{
        'ru': 'Не удалось подготовить тест для этого урока.',
        'en': 'Failed to prepare the quiz for this lesson.',
        'kk': 'Б?л саба??а тест дайындау м?мкін болмады.',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }

  IconData _heroIcon(String key) {
    switch (key) {
      case 'triad':
        return Icons.shield_moon_outlined;
      case 'network':
        return Icons.hub_outlined;
      case 'people':
        return Icons.groups_rounded;
      case 'spark':
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  String _lessonMinutesMeta(String lang, int minutes) {
    switch (lang) {
      case 'en':
        return '$minutes min';
      case 'kk':
        return '$minutes мин';
      case 'ru':
      default:
        return '$minutes мин';
    }
  }

  String _lessonStepsMeta(String lang, int steps) {
    switch (lang) {
      case 'en':
        return '$steps steps';
      case 'kk':
        return '$steps ?адам';
      case 'ru':
      default:
        return '$steps шага';
    }
  }

  List<Widget> _buildSections(List<LessonSection> sections) {
    final List<Widget> widgets = <Widget>[];
    for (final LessonSection section in sections) {
      Widget? card;
      switch (section.type) {
        case LessonSectionType.definition:
          card = LessonDefinitionCard(section: section);
          break;
        case LessonSectionType.importance:
          card = LessonImportanceCard(section: section);
          break;
        case LessonSectionType.example:
          card = LessonExampleCard(section: section);
          break;
        case LessonSectionType.warning:
          card = LessonWarningCard(section: section);
          break;
        case LessonSectionType.checklist:
          card = LessonChecklistCard(section: section);
          break;
        case LessonSectionType.comparison:
          card = LessonComparisonCard(section: section);
          break;
        case LessonSectionType.remember:
          card = LessonRememberCard(section: section);
          break;
        case LessonSectionType.selfCheck:
          card = LessonSelfCheckCard(section: section);
          break;
        case LessonSectionType.sources:
          break;
      }
      if (card != null) {
        widgets.add(card);
        widgets.add(const SizedBox(height: 14));
      }
    }
    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }
    return widgets;
  }
}

final _lessonQuizProvider = FutureProvider.family<List<QuizQuestion>, String>((Ref ref, String lessonId) {
  return ref.read(mistakesServiceProvider.notifier).getQuestionsForLesson(lessonId);
});

