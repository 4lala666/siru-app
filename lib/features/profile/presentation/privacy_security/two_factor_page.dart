import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class TwoFactorPage extends StatelessWidget {
  const TwoFactorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two-Factor Authentication')),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            '2FA setup flow will be connected in the next iteration.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 8),
          Text(
            'Recommended target: Firebase MFA with proper enrollment UX.',
            style: AppTextStyles.secondary,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('ps.2fa.setup'),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Setup pending'),
                  content: const Text('MFA enrollment flow is planned next.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Configure 2FA'),
          ),
        ],
      ),
    );
  }
}
