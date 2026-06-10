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
import 'lesson_quiz_screen.dart';
import 'widgets/empty_lesson_state.dart';
import 'widgets/lesson_hero_card.dart';
import 'widgets/lesson_progress_card.dart';
import 'widgets/lesson_section_card.dart';
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

class ModuleTopicPage extends ConsumerStatefulWidget {
  const ModuleTopicPage({
    super.key,
    required this.args,
  });

  final ModuleTopicArgs args;

  @override
  ConsumerState<ModuleTopicPage> createState() => _ModuleTopicPageState();
}

class _ModuleTopicPageState extends ConsumerState<ModuleTopicPage> {
  int _currentStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final AsyncValue<List<QuizQuestion>> quizAsync = ref.watch(_lessonQuizProvider(widget.args.lesson.id));

    return quizAsync.when(
      data: (List<QuizQuestion> quizQuestions) {
        final LessonContent content = LessonContentBuilder.build(
          module: widget.args.module,
          lesson: widget.args.lesson,
          lang: lang,
          quizQuestions: quizQuestions,
          lessonIndex: widget.args.lessonIndex,
        );
        final bool quizEnabled = content.hasRealContent && quizQuestions.isNotEmpty;
        final int totalSteps = content.sections.length;
        final int safeStepIndex = totalSteps == 0 ? 0 : _currentStepIndex.clamp(0, totalSteps - 1);
        final int currentStep = totalSteps == 0 ? 0 : safeStepIndex + 1;
        final bool isLastStep = totalSteps > 0 && safeStepIndex == totalSteps - 1;
        final LessonSection? activeSection = totalSteps == 0 ? null : content.sections[safeStepIndex];

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
                  label: isLastStep ? _t(lang, 'quizCtaLabel') : _t(lang, 'nextStepLabel'),
                  enabledLabel: isLastStep ? _t(lang, 'startQuiz') : _t(lang, 'nextStep'),
                  disabledLabel: isLastStep ? _t(lang, 'quizSoon') : _t(lang, 'nextStep'),
                  enabled: isLastStep ? quizEnabled : totalSteps > 0,
                  onPressed: isLastStep
                      ? (quizEnabled
                          ? () => context.push(
                                '/lesson-quiz/${widget.args.module.id}/${widget.args.lesson.id}',
                                extra: LessonQuizArgs(
                                  moduleId: widget.args.module.id,
                                  lessonId: widget.args.lesson.id,
                                ),
                              )
                          : null)
                      : () {
                          setState(() {
                            _currentStepIndex = (_currentStepIndex + 1).clamp(0, totalSteps - 1);
                          });
                        },
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
                    _lessonStepsMeta(lang, totalSteps),
                    content.difficulty,
                  ],
                ),
                const SizedBox(height: 14),
                if (content.hasRealContent) ...<Widget>[
                  LessonProgressCard(
                    currentStep: currentStep,
                    totalSteps: totalSteps,
                  ),
                  const SizedBox(height: 14),
                  if (activeSection != null) ...<Widget>[
                    ..._buildSections(<LessonSection>[activeSection]),
                    const SizedBox(height: 14),
                    _LessonStepNavigation(
                      canGoBack: safeStepIndex > 0,
                      currentStep: currentStep,
                      totalSteps: totalSteps,
                      previousLabel: _t(lang, 'previousStep'),
                      nextLabel: isLastStep ? _t(lang, 'finalStepReached') : _t(lang, 'nextStep'),
                      onBack: safeStepIndex > 0
                          ? () {
                              setState(() {
                                _currentStepIndex--;
                              });
                            }
                          : null,
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
        appBar: LessonTopBar(title: _t(lang, 'lesson')),
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
        'kk': 'Сабақ',
      },
      'startQuiz': <String, String>{
        'ru': 'Начать тест',
        'en': 'Start Quiz',
        'kk': 'Тесті бастау',
      },
      'quizCtaLabel': <String, String>{
        'ru': 'Финальный шаг урока',
        'en': 'Final lesson step',
        'kk': 'Сабақтың соңғы қадамы',
      },
      'quizSoon': <String, String>{
        'ru': 'Тест для этой подтемы пока готовится',
        'en': 'Quiz for this subtopic is in progress',
        'kk': 'Бұл ішкі тақырыпқа тест әзірленіп жатыр',
      },
      'nextStepLabel': <String, String>{
        'ru': 'Следующий шаг урока',
        'en': 'Next lesson step',
        'kk': 'Сабақтың келесі қадамы',
      },
      'nextStep': <String, String>{
        'ru': 'Далее',
        'en': 'Next',
        'kk': 'Келесі',
      },
      'previousStep': <String, String>{
        'ru': 'Назад',
        'en': 'Back',
        'kk': 'Артқа',
      },
      'finalStepReached': <String, String>{
        'ru': 'Финальный шаг',
        'en': 'Final step',
        'kk': 'Соңғы қадам',
      },
      'emptyStateTitle': <String, String>{
        'ru': 'Контент готовится',
        'en': 'Content is in progress',
        'kk': 'Контент дайындалып жатыр',
      },
      'emptyStateDescription': <String, String>{
        'ru': 'Материал для этой подтемы будет добавлен позже. Пока можно вернуться к списку подтем и выбрать доступный урок.',
        'en': 'Material for this topic will be added later. You can return to the topic list and continue with an available lesson.',
        'kk': 'Бұл тақырыпқа материал кейінірек қосылады. Әзірге қолжетімді сабаққа оралып, ашық тұрған сабақты таңдауға болады.',
      },
      'quizLoadFailed': <String, String>{
        'ru': 'Не удалось подготовить тест для этого урока.',
        'en': 'Failed to prepare the quiz for this lesson.',
        'kk': 'Бұл сабаққа тест дайындау мүмкін болмады.',
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
        return '$steps қадам';
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

class _LessonStepNavigation extends StatelessWidget {
  const _LessonStepNavigation({
    required this.canGoBack,
    required this.currentStep,
    required this.totalSteps,
    required this.previousLabel,
    required this.nextLabel,
    required this.onBack,
  });

  final bool canGoBack;
  final int currentStep;
  final int totalSteps;
  final String previousLabel;
  final String nextLabel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (canGoBack)
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(previousLabel),
          )
        else
          const SizedBox.shrink(),
        const Spacer(),
        Text(
          totalSteps == 0 ? '' : '$currentStep / $totalSteps',
          style: AppTextStyles.secondary,
        ),
        const Spacer(),
        Text(
          nextLabel,
          style: AppTextStyles.secondary,
        ),
      ],
    );
  }
}
