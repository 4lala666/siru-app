import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmptyLessonState extends StatelessWidget {
  const EmptyLessonState({
    super.key,
    required this.title,
    required this.description,
    required this.onBack,
  });

  final String title;
  final String description;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_stories_outlined, color: AppColors.accent, size: 34),
          ),
          const SizedBox(height: 18),
          Text(title, style: AppTextStyles.screenTitle, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('РќР°Р·Р°Рґ Рє РїРѕРґС‚РµРјР°Рј'),
          ),
        ],
      ),
    );
  }
}

