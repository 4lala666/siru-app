import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ModuleHeroHeader extends StatelessWidget {
  const ModuleHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cover,
    required this.lessonCount,
    required this.difficulty,
  });

  final String title;
  final String subtitle;
  final String cover;
  final int lessonCount;
  final String difficulty;

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            cover,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF123A82)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
                  Colors.black.withValues(alpha: 0.82),
                  Colors.black.withValues(alpha: 0.34),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(),
                Text(title, style: AppTextStyles.screenTitle),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(height: 1.35),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _HeaderChip(icon: Icons.layers_outlined, label: _topicsLabel(lang, lessonCount)),
                    _HeaderChip(icon: Icons.flash_on_rounded, label: difficulty),
                    _HeaderChip(icon: Icons.route_rounded, label: _pathLabel(lang)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _topicsLabel(String lang, int lessonCount) {
    switch (lang) {
      case 'en':
        return '$lessonCount topics';
      case 'kk':
        return '$lessonCount тақырып';
      case 'ru':
      default:
        return '$lessonCount тем';
    }
  }

  String _pathLabel(String lang) {
    switch (lang) {
      case 'en':
        return 'Learning path';
      case 'kk':
        return 'Оқу жолы';
      case 'ru':
      default:
        return 'Путь обучения';
    }
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
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
        color: Colors.white.withValues(alpha: 0.12),
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
