import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LessonTopBar extends StatelessWidget implements PreferredSizeWidget {
  const LessonTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.action,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      centerTitle: true,
      title: Text(title, style: AppTextStyles.cardTitle),
      actions: <Widget>[
        action ??
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.auto_graph_rounded, color: AppColors.textSecondary),
            ),
      ],
    );
  }
}

