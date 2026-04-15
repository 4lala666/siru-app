import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../profile/profile_state.dart';
import 'data/fact_service.dart';
import 'widgets/continue_learning_card.dart';
import 'widgets/fact_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileBootstrapProvider);
    final String lang = Localizations.localeOf(context).languageCode;
    final String username = ref.watch(effectiveProfileNameProvider);
    final AsyncValue<String> factAsync = ref.watch(factOfTheDayProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Hello, $username', style: AppTextStyles.screenTitle),
                    const SizedBox(height: 4),
                    Text(_t(lang, 'staySharp'), style: AppTextStyles.secondary),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => context.push('/app/notifications'),
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          factAsync.when(
            data: (String fact) => FactCard(
              title: _t(lang, 'factOfDay'),
              text: fact,
            ),
            loading: () => const _LoadingCard(),
            error: (_, __) => FactCard(
              title: _t(lang, 'factOfDay'),
              text: _t(lang, 'factFallback'),
            ),
          ),
          const SizedBox(height: 16),
          ContinueLearningCard(
            courseTitle: _t(lang, 'continueCourseTitle'),
            subtitle: _t(lang, 'continueSubtitle'),
            progress: 0.42,
            onResume: () => context.go('/app/modules'),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.security,
            title: _t(lang, 'dailyTipTitle'),
            text: _t(lang, 'dailyTipText'),
            actionText: _t(lang, 'learnMore'),
            onAction: () => context.push('/app/daily-tip'),
          ),
          const SizedBox(height: 16),
          _ProgressCard(
            title: _t(lang, 'yourProgress'),
            subtitle: _t(lang, 'modulesCompleted'),
            progress: 3 / 14,
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.warning_amber_rounded,
            title: _t(lang, 'threatOfDayTitle'),
            text: _t(lang, 'threatOfDayText'),
            actionText: _t(lang, 'explore'),
            onAction: () => context.push('/app/threat-of-day'),
          ),
          const SizedBox(height: 16),
          _QuickActions(
            title: _t(lang, 'quickActions'),
            actions: <_QuickActionData>[
              _QuickActionData(
                label: _t(lang, 'startQuiz'),
                icon: Icons.quiz_outlined,
                onTap: () => context.push('/app/profile/mistakes'),
              ),
              _QuickActionData(
                label: _t(lang, 'exploreModules'),
                icon: Icons.grid_view_rounded,
                onTap: () => context.go('/app/modules'),
              ),
              _QuickActionData(
                label: _t(lang, 'securityTips'),
                icon: Icons.tips_and_updates_outlined,
                onTap: () => context.push('/app/security-tips'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'staySharp': <String, String>{
        'ru': 'Будь в фокусе сегодня.',
        'en': 'Stay sharp today.',
        'kk': 'Бүгін сергек бол.',
      },
      'factOfDay': <String, String>{
        'ru': 'Интересный факт дня',
        'en': 'Interesting fact of the day',
        'kk': 'Күннің қызықты дерегі',
      },
      'factFallback': <String, String>{
        'ru':
            'Кибербезопасность начинается с привычек: обновляйте приложения, используйте MFA и проверяйте ссылки.',
        'en':
            'Cybersecurity starts with habits: update apps, use MFA, and verify links before opening.',
        'kk':
            'Киберқауіпсіздік әдеттен басталады: қолданбаларды жаңартыңыз, MFA қолданыңыз және сілтемелерді тексеріңіз.',
      },
      'continueCourseTitle': <String, String>{
        'ru': 'Социальная инженерия и человеческий фактор',
        'en': 'Social Engineering and Human Factor',
        'kk': 'Әлеуметтік инженерия және адам факторы',
      },
      'continueSubtitle': <String, String>{
        'ru': 'Модуль 2 • Урок 3',
        'en': 'Module 2 • Lesson 3',
        'kk': '2-модуль • 3-сабақ',
      },
      'dailyTipTitle': <String, String>{
        'ru': 'Ежедневный совет по кибербезопасности',
        'en': 'Daily Cyber Tip',
        'kk': 'Күнделікті киберкеңес',
      },
      'dailyTipText': <String, String>{
        'ru':
            'Никогда не используйте один и тот же пароль для разных сервисов.',
        'en': 'Never reuse the same password across multiple services.',
        'kk': 'Бір парольді бірнеше сервисте ешқашан қайта қолданбаңыз.',
      },
      'learnMore': <String, String>{
        'ru': 'Подробнее',
        'en': 'Learn More',
        'kk': 'Толығырақ',
      },
      'yourProgress': <String, String>{
        'ru': 'Ваш прогресс',
        'en': 'Your Progress',
        'kk': 'Сіздің прогресіңіз',
      },
      'modulesCompleted': <String, String>{
        'ru': '3 / 14 модулей завершено',
        'en': '3 / 14 modules completed',
        'kk': '3 / 14 модуль аяқталды',
      },
      'threatOfDayTitle': <String, String>{
        'ru': 'Угроза дня',
        'en': 'Threat of the Day',
        'kk': 'Күн қатері',
      },
      'threatOfDayText': <String, String>{
        'ru': 'Фишинговые атаки ответственны более чем за 80% утечек данных.',
        'en':
            'Phishing attacks are responsible for more than 80% of data breaches.',
        'kk':
            'Фишинг шабуылдары деректер бұзылуының 80%-дан астамына себеп болады.',
      },
      'explore': <String, String>{
        'ru': 'Изучить',
        'en': 'Explore',
        'kk': 'Зерттеу',
      },
      'quickActions': <String, String>{
        'ru': 'Быстрые действия',
        'en': 'Quick Actions',
        'kk': 'Жылдам әрекеттер',
      },
      'startQuiz': <String, String>{
        'ru': 'Начать тест',
        'en': 'Start Quiz',
        'kk': 'Тестті бастау',
      },
      'exploreModules': <String, String>{
        'ru': 'Открыть модули',
        'en': 'Explore Modules',
        'kk': 'Модульдерді ашу',
      },
      'securityTips': <String, String>{
        'ru': 'Советы по безопасности',
        'en': 'Security Tips',
        'kk': 'Қауіпсіздік кеңестері',
      },
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.actionText,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String text;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: AppColors.accent),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppTextStyles.cardTitle)),
            ],
          ),
          const SizedBox(height: 10),
          Text(text, style: AppTextStyles.body),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: onAction, child: Text(actionText)),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final String title;
  final String subtitle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.28),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTextStyles.secondary),
        ],
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.title,
    required this.actions,
  });

  final String title;
  final List<_QuickActionData> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: AppTextStyles.cardTitle),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, int i) {
              final _QuickActionData item = actions[i];
              return SizedBox(
                width: 160,
                child: Material(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(item.icon, color: AppColors.accent),
                          const SizedBox(height: 8),
                          Text(item.label, style: AppTextStyles.chip),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
