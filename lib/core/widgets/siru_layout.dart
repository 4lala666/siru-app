import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SiruLayout extends StatelessWidget {
  const SiruLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class SiruOptionButton extends StatelessWidget {
  const SiruOptionButton({
    super.key,
    required this.text,
    this.selected = false,
    this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryButton : AppColors.card,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}

class SurveyProgressBar extends StatelessWidget {
  const SurveyProgressBar({
    super.key,
    required this.current,
    this.total = 6,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        total,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == total - 1 ? 0 : 8),
            height: 10,
            decoration: BoxDecoration(
              color: index < current ? const Color(0xFF47B1FF) : const Color(0xFFC7D3EB),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
