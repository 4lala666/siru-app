import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/lesson_content.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.number,
    required this.title,
    required this.minutes,
    required this.steps,
    required this.status,
    required this.progress,
    required this.onTap,
  });

  final int number;
  final String title;
  final int minutes;
  final int steps;
  final LessonTopicStatus status;
  final double progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final bool locked = status == LessonTopicStatus.locked;
    final bool completed = status == LessonTopicStatus.completed;
    final bool inProgress = status == LessonTopicStatus.inProgress;
    final Color bg = locked
        ? Colors.white.withValues(alpha: 0.04)
        : completed
            ? const Color(0x1A41D38A)
            : AppColors.cardBackground;

    return Opacity(
      opacity: locked ? 0.65 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: completed
                    ? const Color(0x6641D38A)
                    : inProgress
                        ? AppColors.accent.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: completed
                            ? const Color(0x3341D38A)
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text('$number', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _StatusIcon(status: status),
                  ],
                ),
                const SizedBox(height: 10),
                Text(_metaLabel(lang), style: AppTextStyles.secondary),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completed ? const Color(0xFF41D38A) : AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text(
                      _statusLabel(lang, status),
                      style: AppTextStyles.chip.copyWith(color: _statusColor(status)),
                    ),
                    const Spacer(),
                    Icon(
                      locked ? Icons.lock_outline_rounded : Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: _statusColor(status),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _metaLabel(String lang) {
    switch (lang) {
      case 'en':
        return '$minutes min • $steps steps';
      case 'kk':
        return '$minutes мин • $steps қадам';
      case 'ru':
      default:
        return '$minutes мин • $steps шага';
    }
  }

  String _statusLabel(String lang, LessonTopicStatus status) {
    switch (status) {
      case LessonTopicStatus.completed:
        return switch (lang) {
          'en' => 'Completed',
          'kk' => 'Аяқталды',
          _ => 'Завершено',
        };
      case LessonTopicStatus.inProgress:
        return switch (lang) {
          'en' => 'Continue',
          'kk' => 'Жалғастыру',
          _ => 'Продолжить',
        };
      case LessonTopicStatus.locked:
        return switch (lang) {
          'en' => 'Locked',
          'kk' => 'Жабық',
          _ => 'Скоро',
        };
      case LessonTopicStatus.notStarted:
        return switch (lang) {
          'en' => 'Not started',
          'kk' => 'Басталмаған',
          _ => 'Не начато',
        };
    }
  }

  Color _statusColor(LessonTopicStatus status) {
    switch (status) {
      case LessonTopicStatus.completed:
        return const Color(0xFF41D38A);
      case LessonTopicStatus.inProgress:
        return AppColors.accent;
      case LessonTopicStatus.locked:
        return Colors.white54;
      case LessonTopicStatus.notStarted:
        return AppColors.textSecondary;
    }
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});
  final LessonTopicStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LessonTopicStatus.completed:
        return const Icon(Icons.check_circle_rounded, color: Color(0xFF41D38A));
      case LessonTopicStatus.inProgress:
        return const Icon(Icons.play_circle_fill_rounded, color: AppColors.accent);
      case LessonTopicStatus.locked:
        return const Icon(Icons.lock_outline_rounded, color: Colors.white54);
      case LessonTopicStatus.notStarted:
        return const Icon(Icons.radio_button_unchecked_rounded, color: AppColors.textSecondary);
    }
  }
}
