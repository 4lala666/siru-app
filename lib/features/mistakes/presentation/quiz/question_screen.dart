import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/mistakes_service.dart';
import '../../domain/mistake.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key, required this.questions});

  final List<QuizQuestion> questions;

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  int _index = 0;
  final Map<String, int> _answers = <String, int>{};

  @override
  Widget build(BuildContext context) {
    final QuizQuestion q = widget.questions[_index];

    return Scaffold(
      appBar: AppBar(title: Text('Question ${_index + 1}/${widget.questions.length}', style: AppTextStyles.cardTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(q.question, style: AppTextStyles.body),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < q.options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _answers[q.questionId] == i
                        ? AppColors.primaryButton
                        : AppColors.cardBackground,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onPressed: () {
                    setState(() {
                      _answers[q.questionId] = i;
                    });
                  },
                  child: Text(q.options[i]),
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _answers.containsKey(q.questionId) ? _next : null,
              child: Text(_index == widget.questions.length - 1 ? 'Finish' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }

  void _next() {
    if (_index < widget.questions.length - 1) {
      setState(() => _index++);
      return;
    }

    int correct = 0;
    for (final QuizQuestion q in widget.questions) {
      final int selected = _answers[q.questionId] ?? -1;
      if (selected == q.correctIndex) {
        correct++;
      } else {
        ref.read(mistakesServiceProvider.notifier).addMistake(q.questionId, q.moduleId);
      }
    }

    context.go('/app/profile/mistakes/result', extra: <String, int>{
      'correct': correct,
      'total': widget.questions.length,
    });
  }
}

