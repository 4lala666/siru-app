import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'module_data.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module});

  final ModuleItem module;

  @override
  Widget build(BuildContext context) {
    final bool completed = module.status == 'Completed';
    final bool locked = module.status == 'Locked';

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
          Row(
            children: <Widget>[
              Icon(
                locked ? Icons.lock_outline : Icons.shield_outlined,
                color: locked ? AppColors.textSecondary : AppColors.accent,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(module.title, style: AppTextStyles.cardTitle)),
              _DifficultyBadge(text: module.difficulty),
              const SizedBox(width: 8),
              Icon(
                completed
                    ? Icons.check_circle_outline
                    : (locked ? Icons.lock_outline : Icons.timelapse_outlined),
                color: completed ? AppColors.accent : AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(module.description, style: AppTextStyles.body),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Icon(Icons.menu_book_outlined, size: 18),
              const SizedBox(width: 4),
              Text('${module.lessons} lessons', style: AppTextStyles.secondary),
              const SizedBox(width: 12),
              const Icon(Icons.schedule_outlined, size: 18),
              const SizedBox(width: 4),
              Text('${module.minutes} min', style: AppTextStyles.secondary),
              const Spacer(),
              Text('${module.xp} XP', style: AppTextStyles.chip),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: module.progress,
              minHeight: 8,
              backgroundColor: const Color(0x33FFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: AppTextStyles.chip),
    );
  }
}

