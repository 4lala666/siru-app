import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String code = Localizations.localeOf(context).languageCode;
    final String welcomeIn = switch (code) {
      'kk' => 'SIRU-ға қош келдіңіз',
      'en' => 'Welcome to',
      _ => 'Добро пожаловать в',
    };
    final String subtitle = switch (code) {
      'kk' => 'Қауіпсіз білім кеңістігіне кіру',
      'en' => 'Enter a safe space of knowledge',
      _ => 'Вход в безопасное пространство знаний',
    };

    return SiruLayout(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go('/survey'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 100),
            Center(child: Text(welcomeIn, style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'SIRU',
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Image.asset(
                'assets/images/welcome_robot.png',
                width: 260,
                height: 260,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.pets, size: 120, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Spacer(),
            const Center(child: Text('siru.org', style: TextStyle(fontSize: 16))),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
