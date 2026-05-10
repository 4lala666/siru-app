import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LessonProgressCard extends StatelessWidget {
  const LessonProgressCard({
    super.key,
    required this.progress,
    required this.totalSteps,
  });

  final double progress;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final int currentStep = totalSteps == 0 ? 0 : (progress * totalSteps).ceil().clamp(1, totalSteps);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(_title(lang), style: AppTextStyles.cardTitle),
              const Spacer(),
              Text('${(progress * 100).round()}%', style: AppTextStyles.chip),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 12),
          Text(_stepLabel(lang, currentStep, totalSteps), style: AppTextStyles.secondary),
          const SizedBox(height: 10),
          Row(
            children: List<Widget>.generate(
              totalSteps,
              (int index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
                  height: 6,
                  decoration: BoxDecoration(
                    color: index < currentStep
                        ? AppColors.accent
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _title(String lang) {
    switch (lang) {
      case 'en':
        return 'Lesson progress';
      case 'kk':
        return 'Сабақ прогресі';
      case 'ru':
      default:
        return 'Прогресс урока';
    }
  }

  String _stepLabel(String lang, int currentStep, int totalSteps) {
    switch (lang) {
      case 'en':
        return 'Step $currentStep of $totalSteps';
      case 'kk':
        return '$currentStep / $totalSteps қадам';
      case 'ru':
      default:
        return 'Шаг $currentStep из $totalSteps';
    }
  }
}
