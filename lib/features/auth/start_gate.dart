import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_shell/app_shell.dart';
import 'auth_screen.dart';
import '../language/language_screen.dart';

class StartGate extends StatelessWidget {
  const StartGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final doneOnboarding = snap.data!;

        // 1) Первый запуск: обязательно ведём на ваш flow (язык/приветствие/опрос)
        if (!doneOnboarding) {
          return const LanguageScreen(); // дальше вы ведёте на welcome -> survey -> auth
        }

        // 2) Если онбординг пройден: решаем по авторизации
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return const AuthScreen();
        return const AppShell();
      },
    );
  }

  Future<bool> _load() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool('onboarding_done') ?? false;
  }
}