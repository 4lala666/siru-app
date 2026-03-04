import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/language_provider.dart';
import '../data/modules_provider.dart';
import '../domain/module_models.dart';

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
            body: Center(child: Text('Module not found', style: AppTextStyles.body)),
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
                  bottom: const TabBar(
                    tabs: <Tab>[
                      Tab(text: 'Index'),
                      Tab(text: 'Description'),
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
        body: Center(child: Text('Failed to load module: $e', style: AppTextStyles.body)),
      ),
    );
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
      itemBuilder: (_, int i) {
        final lesson = module.lessons[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${i + 1}. ${tr(lesson.title, lang)}', style: AppTextStyles.body),
              const SizedBox(height: 8),
              Text('${lesson.durationMin} min • ${lesson.stepsCount} steps', style: AppTextStyles.secondary),
            ],
          ),
        );
      },
    );
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
