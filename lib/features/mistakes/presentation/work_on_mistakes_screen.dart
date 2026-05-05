import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/mistakes_service.dart';
import '../domain/mistake.dart';

class WorkOnMistakesScreen extends ConsumerWidget {
  const WorkOnMistakesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Mistake> mistakes = ref.watch(mistakesServiceProvider);
    final int uniqueLessons = mistakes.map((Mistake m) => m.lessonId).toSet().length;
    final int hardOrMedium = mistakes
        .where((Mistake m) => m.difficulty == 'medium' || m.difficulty == 'hard')
        .length;

    return Scaffold(
      appBar: AppBar(title: Text('Work on mistakes', style: AppTextStyles.cardTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Mistake pool: ${mistakes.length}', style: AppTextStyles.cardTitle),
                const SizedBox(height: 8),
                Text(
                  'Start an adaptive quiz built from your wrong answers, related lessons, and current difficulty level.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _StatChip(label: 'Lessons', value: uniqueLessons.toString()),
                    _StatChip(label: 'Medium/Hard', value: hardOrMedium.toString()),
                    const _StatChip(label: 'Feedback', value: 'On'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final List<QuizQuestion> questions = await ref
                          .read(mistakesServiceProvider.notifier)
                          .getRandom10Questions();

                      if (!context.mounted) return;

                      if (questions.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No mistakes yet to build a test.')),
                        );
                        return;
                      }

                      context.push('/app/profile/mistakes/quiz', extra: questions);
                    },
                    child: const Text('Start 10-question test'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...mistakes.map(
            (Mistake m) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.report_problem_outlined, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${m.moduleId} • ${m.lessonId} • ${_difficultyLabel(m.difficulty)}',
                      style: AppTextStyles.body,
                    ),
                  ),
                  Text('x${m.wrongCount}', style: AppTextStyles.chip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _difficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'hard':
        return 'Hard';
      case 'medium':
        return 'Medium';
      case 'easy':
      default:
        return 'Easy';
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('$label: ', style: AppTextStyles.secondary),
          Text(value, style: AppTextStyles.chip),
        ],
      ),
    );
  }
}

