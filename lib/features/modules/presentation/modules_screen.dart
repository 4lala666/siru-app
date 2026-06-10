import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/language_provider.dart';
import '../data/module_progress_repository.dart';
import '../data/modules_provider.dart';
import '../domain/module_models.dart';
import '../widgets/module_card.dart';

class ModulesScreen extends ConsumerStatefulWidget {
  const ModulesScreen({super.key});

  @override
  ConsumerState<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends ConsumerState<ModulesScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final String lang = ref.watch(languageProvider);
    final AsyncValue<List<Module>> modulesAsync = ref.watch(modulesProvider);
    final Map<String, ModuleProgressRecord> progressMap = ref.watch(userModuleProgressProvider).maybeWhen(
          data: (Map<String, ModuleProgressRecord> data) => data,
          orElse: () => const <String, ModuleProgressRecord>{},
        );

    return SafeArea(
      child: modulesAsync.when(
        data: (List<Module> modules) {
          final int completed = modules.where((Module m) => _progressFor(m, progressMap) >= 1).length;
          final int inProgress = modules.where((Module m) {
            final double p = _progressFor(m, progressMap);
            return p > 0 && p < 1;
          }).length;
          final List<MapEntry<int, Module>> filteredModules = modules.asMap().entries.where((MapEntry<int, Module> entry) {
            final double progress = _progressFor(entry.value, progressMap);
            switch (_selectedFilter) {
              case 'completed':
                return progress >= 1;
              case 'inProgress':
                return progress > 0 && progress < 1;
              case 'all':
              default:
                return true;
            }
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(_t(lang, 'learningModules'), style: AppTextStyles.screenTitle),
              const SizedBox(height: 6),
              Text(
                '$completed ${_t(lang, 'completed')} • $inProgress ${_t(lang, 'inProgress')}',
                style: AppTextStyles.secondary,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <String>['all', 'inProgress', 'completed']
                    .map((String key) => ChoiceChip(
                          label: Text(_t(lang, key), style: AppTextStyles.chip),
                          selected: _selectedFilter == key,
                          onSelected: (_) => setState(() => _selectedFilter = key),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              ...filteredModules.map((MapEntry<int, Module> entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ModuleCard(
                      module: entry.value,
                      moduleNumber: entry.key + 1,
                      lang: lang,
                      progress: _progressFor(entry.value, progressMap),
                      onTap: () => context.push('/module/${entry.value.id}'),
                    ),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('${_t(lang, 'failedToLoadModules')}: $e', style: AppTextStyles.body),
          ),
        ),
      ),
    );
  }

  double _progressFor(Module module, Map<String, ModuleProgressRecord> progressMap) {
    final ModuleProgressRecord record =
        progressMap[module.id] ?? ModuleProgressRecord.empty(module.id);
    return record.progressFor(totalLessons: module.lessons.length);
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'learningModules': <String, String>{
        'ru': 'Модули обучения',
        'en': 'Learning Modules',
        'kk': 'Оқу модульдері',
      },
      'completed': <String, String>{
        'ru': 'завершено',
        'en': 'completed',
        'kk': 'аяқталды',
      },
      'inProgress': <String, String>{
        'ru': 'в процессе',
        'en': 'in progress',
        'kk': 'орындалуда',
      },
      'all': <String, String>{
        'ru': 'Все',
        'en': 'All',
        'kk': 'Барлығы',
      },
      'failedToLoadModules': <String, String>{
        'ru': 'Не удалось загрузить модули',
        'en': 'Failed to load modules',
        'kk': 'Модульдерді жүктеу мүмкін болмады',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}
