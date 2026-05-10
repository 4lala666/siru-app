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
    final bool locked = status == LessonTopicStatus.locked;
    final bool completed = status == LessonTopicStatus.completed;
    final bool inProgress = status == LessonTopicStatus.inProgress;
    final Color bg = locked
        ? Colors.white.withValues(alpha: 0.04)
        : completed
            ? const Color(0x1A41D38A)
            : inProgress
                ? AppColors.cardBackground
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
                Text('$minutes РјРёРЅ вЂў $steps С€Р°РіР°', style: AppTextStyles.secondary),
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
                    Text(_statusLabel(status), style: AppTextStyles.chip.copyWith(color: _statusColor(status))),
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

  String _statusLabel(LessonTopicStatus status) {
    switch (status) {
      case LessonTopicStatus.completed:
        return 'Р—Р°РІРµСЂС€РµРЅРѕ';
      case LessonTopicStatus.inProgress:
        return 'РџСЂРѕРґРѕР»Р¶РёС‚СЊ';
      case LessonTopicStatus.locked:
        return 'РЎРєРѕСЂРѕ';
      case LessonTopicStatus.notStarted:
        return 'РќРµ РЅР°С‡Р°С‚Рѕ';
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

