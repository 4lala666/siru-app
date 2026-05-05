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
import 'features/modules/domain/module_models.dart';
import 'features/modules/modules_catalog.dart';
import 'features/modules/presentation/module_detail_page.dart';
import 'features/modules/presentation/module_topic_page.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/presentation/change_password_page.dart';
import 'features/profile/presentation/privacy_security/active_sessions_page.dart';
import 'features/profile/presentation/privacy_security/data_usage_page.dart';
import 'features/profile/presentation/privacy_security/delete_account_page.dart';
import 'features/profile/presentation/privacy_security/login_history_page.dart';
import 'features/profile/presentation/privacy_security/manage_email_page.dart';
import 'features/profile/presentation/privacy_security/two_factor_page.dart';
import 'features/profile/presentation/privacy_security_page.dart';
import 'features/profile/presentation/privacy_policy_page.dart';
import 'features/profile/presentation/terms_of_service_page.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/threats/threat_of_day_screen.dart';
import 'features/tips/daily_tip_screen.dart';
import 'features/tips/security_tips_screen.dart';
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
      GoRoute(path: '/change-password', builder: (_, __) => const ChangePasswordPage()),
      GoRoute(
        path: '/privacy-security',
        builder: (_, __) => const PrivacySecurityPage(),
        routes: <RouteBase>[
          GoRoute(path: 'email', builder: (_, __) => const ManageEmailPage()),
          GoRoute(path: '2fa', builder: (_, __) => const TwoFactorPage()),
          GoRoute(path: 'sessions', builder: (_, __) => const ActiveSessionsPage()),
          GoRoute(path: 'login-history', builder: (_, __) => const LoginHistoryPage()),
          GoRoute(path: 'data-usage', builder: (_, __) => const DataUsagePage()),
          GoRoute(path: 'delete-account', builder: (_, __) => const DeleteAccountPage()),
        ],
      ),
      GoRoute(path: '/privacy-policy', builder: (_, __) => const PrivacyPolicyPage()),
      GoRoute(path: '/terms-of-service', builder: (_, __) => const TermsOfServicePage()),
      GoRoute(
        path: '/module/:id',
        builder: (_, GoRouterState state) => ModuleDetailScreen(
          moduleId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/module-topic',
        builder: (_, GoRouterState state) {
          final Object? extra = state.extra;
          final ModuleTopicArgs args = extra is ModuleTopicArgs
              ? extra
              : const ModuleTopicArgs(
                  moduleTitle: 'Module',
                  lesson: Lesson(
                    id: 'placeholder',
                    durationMin: 0,
                    stepsCount: 0,
                    title: <String, String>{'ru': 'Урок', 'en': 'Lesson', 'kk': 'Сабақ'},
                    summary: <String, String>{},
                    whatYouWillLearn: <String, List<String>>{},
                    keyFacts: <String, List<String>>{},
                    examples: <String, List<String>>{},
                    sources: <LessonSource>[],
                  ),
                );
          return ModuleTopicPage(args: args);
        },
      ),
      GoRoute(path: '/app', redirect: (_, __) => '/app/home'),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) {
          return AppShell(navigationShell: shell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(path: '/app/home', builder: (_, __) => const HomeScreen()),
              GoRoute(path: '/app/notifications', builder: (_, __) => const NotificationsScreen()),
              GoRoute(path: '/app/security-tips', builder: (_, __) => const SecurityTipsScreen()),
              GoRoute(path: '/app/daily-tip', builder: (_, __) => const DailyTipScreen()),
              GoRoute(path: '/app/threat-of-day', builder: (_, __) => const ThreatOfDayScreen()),
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
                          final Map<String, int> map =
                              (extra is Map<String, int>) ? extra : const <String, int>{'correct': 0, 'total': 0};
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
