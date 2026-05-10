import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/lesson_content.dart';

class LessonSourcesSection extends StatelessWidget {
  const LessonSourcesSection({
    super.key,
    required this.title,
    required this.sources,
  });

  final String title;
  final List<LessonContentSource> sources;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppColors.softShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.source_outlined, color: AppColors.accent),
          ),
          title: Text(title, style: AppTextStyles.cardTitle),
          subtitle: Text('${sources.length} СЃСЃС‹Р»РѕРє', style: AppTextStyles.secondary),
          children: sources
              .map(
                (LessonContentSource source) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(source.title, style: AppTextStyles.body),
                      if (source.url.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 6),
                        Text(source.url, style: AppTextStyles.secondary),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

