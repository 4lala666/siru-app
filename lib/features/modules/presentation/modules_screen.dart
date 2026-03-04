import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/language_provider.dart';
import '../data/modules_provider.dart';
import '../domain/module_models.dart';
import '../widgets/module_card.dart';

class ModulesScreen extends ConsumerStatefulWidget {
  const ModulesScreen({super.key});

  @override
  ConsumerState<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends ConsumerState<ModulesScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final String lang = ref.watch(languageProvider);
    final AsyncValue<List<Module>> modulesAsync = ref.watch(modulesProvider);

    return SafeArea(
      child: modulesAsync.when(
        data: (List<Module> modules) {
          final int completed = modules.where((Module m) => _progressFor(m.id) >= 1).length;
          final int inProgress = modules.where((Module m) {
            final double p = _progressFor(m.id);
            return p > 0 && p < 1;
          }).length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text('Learning Modules', style: AppTextStyles.screenTitle),
              const SizedBox(height: 6),
              Text('$completed completed • $inProgress in progress', style: AppTextStyles.secondary),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <String>['All', 'In Progress', 'Completed', 'Locked']
                    .map((String label) => ChoiceChip(
                          label: Text(label, style: AppTextStyles.chip),
                          selected: _selectedFilter == label,
                          onSelected: (_) => setState(() => _selectedFilter = label),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              ...modules.map((Module module) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ModuleCard(
                      module: module,
                      lang: lang,
                      progress: _progressFor(module.id),
                      onTap: () => context.push('/module/${module.id}'),
                    ),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Failed to load modules: $e', style: AppTextStyles.body),
          ),
        ),
      ),
    );
  }

  double _progressFor(String id) {
    final int hash = id.codeUnits.fold<int>(0, (int a, int b) => a + b);
    final int percent = hash % 101;
    return percent / 100;
  }
}
