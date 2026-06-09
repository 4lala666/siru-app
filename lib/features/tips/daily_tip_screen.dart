import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class DailyTipScreen extends StatelessWidget {
  const DailyTipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(_t(lang, 'title'))),
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _t(lang, 'body'),
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        ),
      ),
    );
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'title': <String, String>{
        'ru': 'Совет дня',
        'en': 'Daily Tip',
        'kk': 'Күн кеңесі',
      },
      'body': <String, String>{
        'ru': 'Подробности ежедневного совета по кибербезопасности появятся здесь.',
        'en': 'Daily cyber tip details will appear here.',
        'kk': 'Күнделікті киберкеңес туралы мәліметтер осында көрсетіледі.',
      },
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}
