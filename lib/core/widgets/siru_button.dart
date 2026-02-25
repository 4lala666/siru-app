import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SiruButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SiruButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          foregroundColor: AppColors.text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontFamily: 'IBMPlexSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
