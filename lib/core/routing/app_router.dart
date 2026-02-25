import 'package:go_router/go_router.dart';

import '../../features/app_shell/app_shell.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/password_changed_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/verify_code_screen.dart';
import '../../features/language/language_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/survey/survey_screen.dart';
import '../../features/welcome/welcome_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(path: '/', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/language', builder: (_, __) => const LanguageScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/survey', builder: (_, __) => const SurveyScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/auth/forgot', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/auth/verify', builder: (_, __) => const VerifyCodeScreen()),
      GoRoute(path: '/auth/reset', builder: (_, __) => const ResetPasswordScreen()),
      GoRoute(path: '/auth/success', builder: (_, __) => const PasswordChangedScreen()),
      GoRoute(path: '/app', builder: (_, __) => const AppShell()),
    ],
  );
}
