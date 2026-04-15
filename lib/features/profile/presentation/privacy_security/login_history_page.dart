import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LoginHistoryPage extends StatelessWidget {
  const LoginHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login History')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _LoginEntry(
            title: 'Successful login',
            subtitle: 'Today, current device',
          ),
          SizedBox(height: 10),
          _LoginEntry(
            title: 'Successful login',
            subtitle: 'Yesterday, mobile app',
          ),
          SizedBox(height: 10),
          _LoginEntry(
            title: 'Failed attempt',
            subtitle: '2 days ago, unknown browser',
          ),
        ],
      ),
    );
  }
}

class _LoginEntry extends StatelessWidget {
  const _LoginEntry({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.body),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.secondary),
        ],
      ),
    );
  }
}
