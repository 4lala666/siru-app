import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/language_provider.dart';
import '../data/modules_provider.dart';
import '../domain/module_models.dart';
import 'module_topic_page.dart';

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

    return modulesAsync.when(
      data: (List<Module> modules) {
        final Module? module = modules.where((Module m) => m.id == moduleId).cast<Module?>().firstOrNull;
        if (module == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(_t(lang, 'moduleNotFound'), style: AppTextStyles.body)),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: NestedScrollView(
              headerSliverBuilder: (_, __) => <Widget>[
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      tr(module.title, lang),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(
                          module.cover,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: const Color(0xFF123A82)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: <Color>[
                                Colors.black.withValues(alpha: 0.65),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    tabs: <Tab>[
                      Tab(text: _t(lang, 'index')),
                      Tab(text: _t(lang, 'description')),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                children: <Widget>[
                  _IndexTab(module: module, lang: lang),
                  _DescriptionTab(module: module, lang: lang),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (Object e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('${_t(lang, 'failedToLoadModule')}: $e', style: AppTextStyles.body)),
      ),
    );
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
      'index': <String, String>{
        'ru': 'Индекс',
        'en': 'Index',
        'kk': 'Индекс',
      },
      'description': <String, String>{
        'ru': 'Описание',
        'en': 'Description',
        'kk': 'Сипаттама',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

class _IndexTab extends StatelessWidget {
  const _IndexTab({required this.module, required this.lang});

  final Module module;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: module.lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int i) {
        final Lesson lesson = module.lessons[i];
        final String title = tr(lesson.title, lang);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              context.push(
                '/module-topic',
                extra: ModuleTopicArgs(
                  title: title,
                  description: _topicDescription(title),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('${i + 1}. $title', style: AppTextStyles.body),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_lessonMeta(lesson), style: AppTextStyles.secondary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _lessonMeta(Lesson lesson) {
    switch (lang) {
      case 'en':
        return '${lesson.durationMin} min • ${lesson.stepsCount} steps';
      case 'kk':
        return '${lesson.durationMin} мин • ${lesson.stepsCount} қадам';
      case 'ru':
      default:
        return '${lesson.durationMin} мин • ${lesson.stepsCount} шагов';
    }
  }

  String _topicDescription(String title) {
    switch (lang) {
      case 'en':
        return 'A short practical introduction to "$title".';
      case 'kk':
        return '"$title" тақырыбына қысқаша практикалық кіріспе.';
      case 'ru':
      default:
        return 'Краткое практическое введение в тему "$title".';
    }
  }
}

class _DescriptionTab extends StatelessWidget {
  const _DescriptionTab({required this.module, required this.lang});

  final Module module;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: module.descriptionSections.map((DescriptionSection section) {
        final List<String> bullets = section.bullets[lang] ?? section.bullets['ru'] ?? <String>[];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(tr(section.title, lang), style: AppTextStyles.cardTitle),
              const SizedBox(height: 8),
              ...bullets.map((String b) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $b', style: AppTextStyles.body),
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }
}

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}


