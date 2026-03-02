import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

        if (!doneOnboarding) {
          return const LanguageScreen();
        }

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
            return const _AppRedirect();
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

class _AppRedirect extends StatefulWidget {
  const _AppRedirect();

  @override
  State<_AppRedirect> createState() => _AppRedirectState();
}

class _AppRedirectState extends State<_AppRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go('/app/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

