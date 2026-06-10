import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/language_provider.dart';
import '../data/module_progress_repository.dart';
import '../data/modules_provider.dart';
import '../domain/lesson_content.dart';
import '../domain/module_models.dart';
import 'module_topic_page.dart';
import 'widgets/module_hero_header.dart';
import 'widgets/topic_card.dart';

class ModuleDetailScreen extends ConsumerWidget {
  const ModuleDetailScreen({
    super.key,
    required this.moduleId,
  });

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String lang = ref.watch(languageProvider);
    final AsyncValue<List<Module>> modulesAsync = ref.watch(modulesProvider);
    final ModuleProgressRecord moduleProgress = ref.watch(moduleProgressForModuleProvider(moduleId));

    return modulesAsync.when(
      data: (List<Module> modules) {
        final Module? module =
            modules.where((Module m) => m.id == moduleId).cast<Module?>().firstOrNull;
        if (module == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(_t(lang, 'moduleNotFound'), style: AppTextStyles.body)),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            scrolledUnderElevation: 0,
            title: Text(_t(lang, 'module'), style: AppTextStyles.cardTitle),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              ModuleHeroHeader(
                title: _displayTitle(module, lang),
                subtitle: _displaySubtitle(module, lang),
                heroImagePath: module.heroImagePath,
                alignmentX: module.alignmentX,
                alignmentY: module.alignmentY,
                lessonCount: module.lessons.length,
                difficulty: module.difficulty,
              ),
              const SizedBox(height: 18),
              Text(_t(lang, 'learningPath'), style: AppTextStyles.screenTitle),
              const SizedBox(height: 8),
              Text(_t(lang, 'learningPathSubtitle'), style: AppTextStyles.secondary),
              const SizedBox(height: 14),
              ...module.lessons.asMap().entries.map((MapEntry<int, Lesson> entry) {
                final int index = entry.key;
                final Lesson lesson = entry.value;
                final LessonTopicStatus status = _statusForLesson(
                  module: module,
                  lesson: lesson,
                  lessonIndex: index,
                  progress: moduleProgress,
                );
                final double lessonProgress = switch (status) {
                  LessonTopicStatus.completed => 1,
                  LessonTopicStatus.inProgress => 0.5,
                  LessonTopicStatus.locked => 0,
                  LessonTopicStatus.notStarted => 0,
                };

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TopicCard(
                    number: index + 1,
                    title: _displayLessonTitle(module, lesson, lang),
                    minutes: lesson.durationMin,
                    steps: lesson.stepsCount,
                    status: status,
                    progress: lessonProgress,
                    onTap: status == LessonTopicStatus.locked
                        ? null
                        : () {
                            context.push(
                              '/module-topic',
                              extra: ModuleTopicArgs(
                                module: module,
                                lesson: lesson,
                                lessonIndex: index,
                              ),
                            );
                          },
                  ),
                );
              }),
              const SizedBox(height: 12),
              Text(_t(lang, 'aboutModule'), style: AppTextStyles.screenTitle),
              const SizedBox(height: 12),
              ...module.descriptionSections.map((DescriptionSection section) {
                final List<String> bullets =
                    section.bullets[lang] ?? section.bullets['ru'] ?? <String>[];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_clean(tr(section.title, lang)), style: AppTextStyles.cardTitle),
                      const SizedBox(height: 10),
                      ...bullets.map(
                        (String bullet) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('• ${_clean(bullet)}', style: AppTextStyles.body),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (Object e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('${_t(lang, 'failedToLoadModule')}: $e', style: AppTextStyles.body),
        ),
      ),
    );
  }

  String _displayTitle(Module module, String lang) {
    if (module.id == 'gov_risk') return _t(lang, 'govRiskTitle');
    return _clean(tr(module.title, lang));
  }

  String _displaySubtitle(Module module, String lang) {
    if (module.id == 'gov_risk') return _t(lang, 'govRiskSubtitle');
    return _clean(tr(module.subtitle, lang));
  }

  String _displayLessonTitle(Module module, Lesson lesson, String lang) {
    if (module.id == 'gov_risk' && lesson.id == 'gov_02') {
      return _t(lang, 'ciaLessonTitle');
    }
    return _clean(tr(lesson.title, lang));
  }

  LessonTopicStatus _statusForLesson({
    required Module module,
    required Lesson lesson,
    required int lessonIndex,
    required ModuleProgressRecord progress,
  }) {
    if (progress.containsLesson(lesson.id)) {
      return LessonTopicStatus.completed;
    }

    if ((progress.lastSubtopicId == lesson.id) && !progress.containsLesson(lesson.id)) {
      return LessonTopicStatus.inProgress;
    }

    final int firstUncompletedIndex = module.lessons.indexWhere(
      (Lesson item) => !progress.containsLesson(item.id),
    );
    if (progress.hasStarted && firstUncompletedIndex == lessonIndex) {
      return LessonTopicStatus.inProgress;
    }

    return LessonTopicStatus.notStarted;
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'moduleNotFound': <String, String>{
        'ru': 'Модуль не найден',
        'en': 'Module not found',
        'kk': 'Модуль табылмады',
      },
      'failedToLoadModule': <String, String>{
        'ru': 'Не удалось загрузить модуль',
        'en': 'Failed to load module',
        'kk': 'Модульді жүктеу мүмкін болмады',
      },
      'module': <String, String>{
        'ru': 'Модуль',
        'en': 'Module',
        'kk': 'Модуль',
      },
      'learningPath': <String, String>{
        'ru': 'Подтемы и путь обучения',
        'en': 'Topics and learning path',
        'kk': 'Сабақтар және оқу жолы',
      },
      'learningPathSubtitle': <String, String>{
        'ru': 'Продвигайтесь по подтемам по шагам: видно, что завершено, что доступно и что готовится.',
        'en': 'Move through topics step by step: see what is complete, active, and coming next.',
        'kk': 'Сабақтарды кезең-кезеңімен өтіңіз: не аяқталғанын және не ашық екенін көресіз.',
      },
      'aboutModule': <String, String>{
        'ru': 'О модуле',
        'en': 'About the module',
        'kk': 'Модуль туралы',
      },
      'govRiskTitle': <String, String>{
        'ru': 'Основы, управление и риск',
        'en': 'Governance & Risk',
        'kk': 'Басқару және тәуекел',
      },
      'govRiskSubtitle': <String, String>{
        'ru': 'База ИБ: цели, риски, политики и стандарты.',
        'en': 'Security fundamentals: goals, risks, policies, and standards.',
        'kk': 'Ақпараттық қауіпсіздік негіздері: мақсаттар, тәуекелдер, саясаттар және стандарттар.',
      },
      'ciaLessonTitle': <String, String>{
        'ru': 'CIA-триада и базовые свойства безопасности',
        'en': 'CIA triad and core security properties',
        'kk': 'CIA триадасы және негізгі қауіпсіздік қасиеттері',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }

  String _clean(String value) {
    return value
        .replaceAll('вЂ”', '—')
        .replaceAll('вЂ“', '–')
        .replaceAll('вЂ™', '’')
        .replaceAll('вЂ', '‘')
        .replaceAll('вЂњ', '“')
        .replaceAll('вЂќ', '”')
        .trim();
  }
}

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
