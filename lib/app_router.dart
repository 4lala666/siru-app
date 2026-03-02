import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/app_shell/app_shell.dart';
import 'features/auth/auth_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/password_changed_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/auth/start_gate.dart';
import 'features/auth/verify_code_screen.dart';
import 'features/home/home_screen.dart';
import 'features/language/language_screen.dart';
import 'features/mistakes/domain/mistake.dart';
import 'features/mistakes/presentation/quiz/question_screen.dart';
import 'features/mistakes/presentation/quiz/result_screen.dart';
import 'features/mistakes/work_on_mistakes_screen.dart';
import 'features/modules/modules_catalog.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/survey/survey_screen.dart';
import 'features/welcome/welcome_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (_, __) => const StartGate()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/language', builder: (_, __) => const LanguageScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/survey', builder: (_, __) => const SurveyScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/auth/forgot', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/auth/verify', builder: (_, __) => const VerifyCodeScreen()),
      GoRoute(path: '/auth/reset', builder: (_, __) => const ResetPasswordScreen()),
      GoRoute(path: '/auth/success', builder: (_, __) => const PasswordChangedScreen()),
      GoRoute(path: '/app', redirect: (_, __) => '/app/home'),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) {
          return AppShell(navigationShell: shell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(path: '/app/home', builder: (_, __) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(path: '/app/modules', builder: (_, __) => const ModulesCatalogView()),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/app/profile',
                builder: (_, __) => const ProfileScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'mistakes',
                    builder: (_, __) => const WorkOnMistakesScreen(),
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'quiz',
                        builder: (_, GoRouterState state) {
                          final Object? extra = state.extra;
                          final List<QuizQuestion> questions =
                              (extra is List<QuizQuestion>) ? extra : const <QuizQuestion>[];
                          return QuestionScreen(questions: questions);
                        },
                      ),
                      GoRoute(
                        path: 'result',
                        builder: (_, GoRouterState state) {
                          final Object? extra = state.extra;
                          final Map<String, int> map = (extra is Map<String, int>)
                              ? extra
                              : const <String, int>{'correct': 0, 'total': 0};
                          return ResultScreen(
                            correct: map['correct'] ?? 0,
                            total: map['total'] ?? 0,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

