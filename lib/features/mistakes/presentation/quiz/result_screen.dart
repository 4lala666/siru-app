import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.correct,
    required this.total,
    this.backRoute = '/app/profile/mistakes',
    this.backLabel = 'Back to mistakes',
  });

  final int correct;
  final int total;
  final String backRoute;
  final String backLabel;

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final double ratio = total == 0 ? 0 : correct / total;

    return Scaffold(
      appBar: AppBar(title: Text(_t(lang, 'result'), style: AppTextStyles.cardTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_t(lang, 'quizFinished'), style: AppTextStyles.cardTitle),
              const SizedBox(height: 8),
              Text('${_t(lang, 'correctAnswers')}: $correct / $total', style: AppTextStyles.body),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  backgroundColor: const Color(0x33FFFFFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(backRoute),
                  child: Text(backLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'result': <String, String>{
        'ru': 'Результат',
        'en': 'Result',
        'kk': 'Нәтиже',
      },
      'quizFinished': <String, String>{
        'ru': 'Тест завершён',
        'en': 'Quiz finished',
        'kk': 'Тест аяқталды',
      },
      'correctAnswers': <String, String>{
        'ru': 'Правильные ответы',
        'en': 'Correct answers',
        'kk': 'Дұрыс жауаптар',
      },
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}
