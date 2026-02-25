import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_shell/app_shell.dart';
import '../onboarding/onboarding_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // Не залогинен → показываем ваш onboarding (а там уже дальше будет /auth)
        if (user == null) {
          return const OnboardingScreen();
        }

        // Залогинен → сразу в главное приложение
        return const AppShell();
      },
    );
  }
}