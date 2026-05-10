import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LessonHeroCard extends StatelessWidget {
  const LessonHeroCard({
    super.key,
    required this.title,
    required this.moduleTitle,
    required this.subtitle,
    required this.icon,
    required this.metaLabels,
  });

  final String title;
  final String moduleTitle;
  final String subtitle;
  final IconData icon;
  final List<String> metaLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF103C8C),
            AppColors.cardBackground,
            Color(0xFF0B2555),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(moduleTitle, style: AppTextStyles.secondary),
                const SizedBox(height: 8),
                Text(title, style: AppTextStyles.screenTitle),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(height: 1.4),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List<Widget>.generate(metaLabels.length, (int index) {
                    final List<IconData> icons = <IconData>[
                      Icons.schedule_rounded,
                      Icons.stacked_bar_chart_rounded,
                      Icons.flash_on_rounded,
                    ];
                    return _MetaPill(
                      icon: icons[index.clamp(0, icons.length - 1)],
                      label: metaLabels[index],
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: AppColors.accent, size: 34),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: AppColors.accent),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.chip),
        ],
      ),
    );
  }
}

