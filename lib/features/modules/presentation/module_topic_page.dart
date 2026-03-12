import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ModuleTopicArgs {
  const ModuleTopicArgs({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class ModuleTopicPage extends StatelessWidget {
  const ModuleTopicPage({
    super.key,
    required this.args,
  });

  final ModuleTopicArgs args;

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(_t(lang, 'topic')),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(args.title, style: AppTextStyles.screenTitle),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_t(lang, 'description'), style: AppTextStyles.cardTitle),
                  const SizedBox(height: 8),
                  Text(args.description, style: AppTextStyles.body),
                  const SizedBox(height: 18),
                  Text(_t(lang, 'whatYouWillLearn'), style: AppTextStyles.cardTitle),
                  const SizedBox(height: 10),
                  Text('• ${_t(lang, 'bullet1')}', style: AppTextStyles.body),
                  const SizedBox(height: 6),
                  Text('• ${_t(lang, 'bullet2')}', style: AppTextStyles.body),
                  const SizedBox(height: 6),
                  Text('• ${_t(lang, 'bullet3')}', style: AppTextStyles.body),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_t(lang, 'lessonWillBeAvailable'))),
                  );
                },
                child: Text(_t(lang, 'startLesson')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'topic': <String, String>{
        'ru': 'Тема',
        'en': 'Topic',
        'kk': 'Тақырып',
      },
      'description': <String, String>{
        'ru': 'Описание',
        'en': 'Description',
        'kk': 'Сипаттама',
      },
      'whatYouWillLearn': <String, String>{
        'ru': 'What you will learn:',
        'en': 'What you will learn:',
        'kk': 'What you will learn:',
      },
      'bullet1': <String, String>{
        'ru': 'Что такое фишинг',
        'en': 'What phishing is',
        'kk': 'Фишинг деген не',
      },
      'bullet2': <String, String>{
        'ru': 'Как злоумышленники крадут учетные данные',
        'en': 'How attackers steal credentials',
        'kk': 'Шабуылдаушылар аккаунт деректерін қалай ұрлайды',
      },
      'bullet3': <String, String>{
        'ru': 'Как распознавать фишинговые письма',
        'en': 'How to detect phishing emails',
        'kk': 'Фишинг хаттарды қалай анықтау керек',
      },
      'startLesson': <String, String>{
        'ru': 'Начать урок',
        'en': 'Start Lesson',
        'kk': 'Сабақты бастау',
      },
      'lessonWillBeAvailable': <String, String>{
        'ru': 'Скоро здесь будет полный урок.',
        'en': 'The full lesson will be available soon.',
        'kk': 'Толық сабақ жақында қосылады.',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

