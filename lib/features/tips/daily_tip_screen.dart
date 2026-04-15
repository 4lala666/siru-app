import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class DailyTipScreen extends StatelessWidget {
  const DailyTipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tip')),
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Daily cyber tip details will appear here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        ),
      ),
    );
  }
}
