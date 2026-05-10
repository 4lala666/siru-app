import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class StartQuizStickyButton extends StatelessWidget {
  const StartQuizStickyButton({
    super.key,
    required this.label,
    required this.enabledLabel,
    required this.disabledLabel,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final String enabledLabel;
  final String disabledLabel;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.94),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(label, style: AppTextStyles.secondary),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: enabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: enabled ? AppColors.accent : Colors.white.withValues(alpha: 0.12),
                  foregroundColor: enabled ? Colors.black : Colors.white54,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(enabled ? enabledLabel : disabledLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

