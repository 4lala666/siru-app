import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ActivityCalendarCard extends StatelessWidget {
  const ActivityCalendarCard({
    super.key,
    required this.currentDate,
    required this.activeDates,
    required this.streakCount,
  });

  final DateTime currentDate;
  final Set<DateTime> activeDates;
  final int streakCount;

  @override
  Widget build(BuildContext context) {
    final DateTime weekStart = _startOfWeek(currentDate);
    final List<DateTime> days = List<DateTime>.generate(
      7,
      (int i) => weekStart.add(Duration(days: i)),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Активность', style: AppTextStyles.cardTitle),
              const Spacer(),
              const Icon(Icons.bolt_rounded, size: 18, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(
                '$streakCount дней подряд',
                style: AppTextStyles.secondary.copyWith(color: AppColors.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: days
                .map((DateTime day) => Expanded(
                      child: Center(
                        child: Text(
                          _weekdayLabel(day.weekday),
                          style: AppTextStyles.secondary,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: days.map((DateTime day) {
              final bool isToday = _isSameDay(day, currentDate);
              final bool isActive = activeDates.any((DateTime d) => _isSameDay(d, day));
              return Expanded(
                child: Center(
                  child: Container(
                    width: 34,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isToday ? AppColors.accent : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isToday
                            ? AppColors.accent
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Text(
                          '${day.day}',
                          style: AppTextStyles.chip.copyWith(
                            color: isToday ? Colors.black : AppColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isActive && !isToday)
                          const Positioned(
                            bottom: 4,
                            child: _ActiveDot(),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final int offset = date.weekday - DateTime.monday;
    final DateTime d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: offset));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'ПН';
      case DateTime.tuesday:
        return 'ВТ';
      case DateTime.wednesday:
        return 'СР';
      case DateTime.thursday:
        return 'ЧТ';
      case DateTime.friday:
        return 'ПТ';
      case DateTime.saturday:
        return 'СБ';
      case DateTime.sunday:
      default:
        return 'ВС';
    }
  }
}

class _ActiveDot extends StatelessWidget {
  const _ActiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
    );
  }
}
