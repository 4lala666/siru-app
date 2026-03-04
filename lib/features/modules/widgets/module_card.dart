import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../domain/module_models.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.module,
    required this.lang,
    required this.onTap,
    required this.progress,
  });

  final Module module;
  final String lang; // 'ru' | 'en' | 'kk'
  final VoidCallback onTap;
  final double progress;

  String _getText(Object? field) {
    if (field is Map<String, String>) {
      return field[lang] ?? field['ru'] ?? '';
    }
    if (field is Map) {
      final Object? fallback = field.isNotEmpty ? field.values.first : null;
      final Object? value = field[lang] ?? field['ru'] ?? fallback;
      return value?.toString() ?? '';
    }
    return field?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final int lessonsCount = module.lessons.length;
    final int totalMinutes = module.lessons.fold<int>(0, (int sum, Lesson l) => sum + l.durationMin);
    final int xp = lessonsCount * 25;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 210,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.softShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  module.cover,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFF123A82)),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Colors.black.withValues(alpha: 0.65),
                        Colors.black.withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _iconFor(module.icon),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getText(module.title),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.cardTitle,
                            ),
                          ),
                          _difficultyChip(module.difficulty),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getText(module.subtitle),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.secondary,
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.menu_book_outlined, size: 16, color: AppColors.text),
                          const SizedBox(width: 4),
                          Text('$lessonsCount lessons', style: AppTextStyles.chip),
                          const SizedBox(width: 12),
                          const Icon(Icons.schedule_outlined, size: 16, color: AppColors.text),
                          const SizedBox(width: 4),
                          Text('$totalMinutes min', style: AppTextStyles.chip),
                          const Spacer(),
                          Text('$xp XP', style: AppTextStyles.chip),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.28),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _difficultyChip(String difficulty) {
    final String label = difficulty.isNotEmpty
        ? '${difficulty[0].toUpperCase()}${difficulty.substring(1)}'
        : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.chip,
      ),
    );
  }

  Widget _iconFor(String icon) {
    switch (icon) {
      case 'shield':
        return const Icon(Icons.shield_outlined, color: AppColors.accent);
      case 'users':
        return const Icon(Icons.groups_outlined, color: AppColors.accent);
      case 'network':
        return const Icon(Icons.hub_outlined, color: AppColors.accent);
      case 'lock':
        return const Icon(Icons.lock_outline, color: AppColors.accent);
      default:
        return const Icon(Icons.extension_outlined, color: AppColors.accent);
    }
  }
}
