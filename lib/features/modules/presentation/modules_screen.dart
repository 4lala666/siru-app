import 'package:flutter/material.dart';

import '../../../core/constants/app_text_styles.dart';
import '../widgets/module_card.dart';
import '../widgets/module_data.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final List<ModuleItem> items = _applyFilter(mockModules, _filter);
    final int completed = mockModules.where((ModuleItem m) => m.status == 'Completed').length;
    final int inProgress = mockModules.where((ModuleItem m) => m.status == 'In Progress').length;

    return SafeArea(
      child: ListView(
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
                      selected: _filter == label,
                      onSelected: (_) => setState(() => _filter = label),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          ...items.map((ModuleItem item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ModuleCard(module: item),
              )),
        ],
      ),
    );
  }

  List<ModuleItem> _applyFilter(List<ModuleItem> source, String filter) {
    if (filter == 'All') return source;
    return source.where((ModuleItem module) => module.status == filter).toList();
  }
}

