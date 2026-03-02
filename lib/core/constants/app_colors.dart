import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF071A3D);
  static const Color cardBackground = Color(0xFF0A2D6F);
  static const Color primaryButton = Color(0xFF1D3EAD);
  static const Color accent = Color(0xFFFFF700);
  static const Color text = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color questionBg = Color(0xFFFFF700);

  // Backward-compat names used by older screens.
  static const Color bg = background;
  static const Color card = cardBackground;

  static List<BoxShadow> get softShadow => const <BoxShadow>[
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ];
}

