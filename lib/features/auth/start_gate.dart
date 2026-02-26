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
    return FutureBuilder<bool>(
      future: _load(),
      builder: (BuildContext context, AsyncSnapshot<bool> snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool doneOnboarding = snap.data!;

        // 1) First launch: onboarding flow.
        if (!doneOnboarding) {
          return const LanguageScreen();
        }

        // 2) Onboarding passed: react to auth session state.
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> authSnap) {
            if (authSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final User? user = authSnap.data;
            if (user == null) return const AuthScreen();
            return const AppShell();
          },
        );
      },
    );
  }

  Future<bool> _load() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('onboarding_done') ?? false;
  }
}
