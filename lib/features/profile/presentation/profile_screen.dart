import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/language_provider.dart';
import '../../auth/auth_controller.dart';
import '../../rewards/data/rewards_service.dart';
import '../../../l10n/app_localizations.dart';
import '../profile_state.dart';
import 'edit_profile_sheet.dart';

final isDarkModeProvider = StateProvider<bool>((Ref ref) => true);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileBootstrapProvider);
    final bool isDark = ref.watch(isDarkModeProvider);
    final String username = ref.watch(effectiveProfileNameProvider);
    final IconData avatar = ref.watch(profileAvatarProvider);
    final bool authLoading = ref.watch(authControllerProvider).isLoading;
    final UserRewards rewards = ref.watch(userRewardsProvider).valueOrNull ?? UserRewards.empty();
    final AppLocalizations s = AppLocalizations.of(context)!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(s.profileTab, style: AppTextStyles.screenTitle),
              const Spacer(),
              _ThemeToggle(
                isDark: isDark,
                onChanged: (bool value) => ref.read(isDarkModeProvider.notifier).state = value,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ProfileSummaryCard(username: username, avatar: avatar, rewards: rewards),
          const SizedBox(height: 16),
          Text(_txt(context, ru: 'Кибер статистика', kk: 'Кибер статистика', en: 'Cyber Statistics'),
              style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          _StatsGrid(rewards: rewards),
          const SizedBox(height: 16),
          Text(s.earnedBadges, style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          _RecentBadges(rewards: rewards),
          const SizedBox(height: 16),
          Text(_txt(context, ru: 'Настройки', kk: 'Баптаулар', en: 'Settings'), style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          _SettingsTile(
            title: _txt(context, ru: 'Язык', kk: 'Тіл', en: 'Language'),
            subtitle: _currentLanguageName(context, s),
            onTap: () => _showLanguageSheet(context, ref, s),
          ),
          _SettingsTile(
            title: _txt(context, ru: 'Приватность и безопасность', kk: 'Құпиялық және қауіпсіздік', en: 'Privacy & Security'),
            onTap: () => context.push('/privacy-security'),
          ),
          _SettingsTile(
            title: _txt(context, ru: 'Работа над ошибками', kk: 'Қателермен жұмыс', en: 'Work on mistakes'),
            onTap: () => context.push('/app/profile/mistakes'),
          ),
          _SettingsTile(
            title: _txt(context, ru: 'Выйти из аккаунта', kk: 'Аккаунттан шығу', en: 'Sign out'),
            trailing: authLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            onTap: authLoading
                ? () {}
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final String? err = await ref.read(authControllerProvider.notifier).signOut();
                    if (!context.mounted) return;
                    if (err != null) {
                      messenger.showSnackBar(SnackBar(content: Text(err)));
                      return;
                    }
                    context.go('/auth');
                  },
          ),
        ],
      ),
    );
  }

  String _currentLanguageName(BuildContext context, AppLocalizations s) {
    final String code = Localizations.localeOf(context).languageCode;
    switch (code) {
      case 'kk':
        return s.kazakh;
      case 'en':
        return s.english;
      default:
        return s.russian;
    }
  }

  Future<void> _showLanguageSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations s,
  ) async {
    final String code = Localizations.localeOf(context).languageCode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(s.chooseLanguageTitle, style: AppTextStyles.cardTitle),
                const SizedBox(height: 10),
                _LangTile(
                  title: s.russian,
                  selected: code == 'ru',
                  onTap: () async {
                    await ref.read(languageProvider.notifier).setLanguage('ru');
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
                _LangTile(
                  title: s.kazakh,
                  selected: code == 'kk',
                  onTap: () async {
                    await ref.read(languageProvider.notifier).setLanguage('kk');
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
                _LangTile(
                  title: s.english,
                  selected: code == 'en',
                  onTap: () async {
                    await ref.read(languageProvider.notifier).setLanguage('en');
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _txt(BuildContext context, {required String ru, required String kk, required String en}) {
  switch (Localizations.localeOf(context).languageCode) {
    case 'kk':
      return kk;
    case 'en':
      return en;
    default:
      return ru;
  }
}

class _LangTile extends StatelessWidget {
  const _LangTile({required this.title, required this.selected, required this.onTap});

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(title, style: AppTextStyles.body),
      trailing: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? AppColors.accent : AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.isDark, required this.onChanged});

  final bool isDark;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _ToggleDot(
            icon: Icons.dark_mode_outlined,
            active: isDark,
            onTap: () => onChanged(true),
          ),
          _ToggleDot(
            icon: Icons.light_mode_outlined,
            active: !isDark,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleDot extends StatelessWidget {
  const _ToggleDot({required this.icon, required this.active, required this.onTap});

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? AppColors.primaryButton : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, size: 18, color: AppColors.text),
      ),
    );
  }
}

class _ProfileSummaryCard extends ConsumerWidget {
  const _ProfileSummaryCard({
    required this.username,
    required this.avatar,
    required this.rewards,
  });

  final String username;
  final IconData avatar;
  final UserRewards rewards;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations s = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryButton,
                child: Icon(avatar, color: AppColors.text),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(username, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0x26FFFFFF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${s.levelLabel}: ${rewards.level}',
                        style: AppTextStyles.chip,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _memberSinceLabel(context, rewards.createdAt),
            style: AppTextStyles.secondary,
          ),
          const SizedBox(height: 10),
          Text('${s.levelLabel} ${rewards.level} • ${rewards.totalXp} XP', style: AppTextStyles.body),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: rewards.progressToNextLevel.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0x33FFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${s.progressToNextLevel}: ${(rewards.progressToNextLevel * 100).round()}%',
            style: AppTextStyles.secondary,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const EditProfileSheet(),
                );
              },
              child: Text(_txt(context, ru: 'Редактировать профиль', kk: 'Профильді өңдеу', en: 'Edit Profile')),
            ),
          ),
        ],
      ),
    );
  }

  String _memberSinceLabel(BuildContext context, DateTime? createdAt) {
    if (createdAt == null) {
      return _txt(
        context,
        ru: 'В системе недавно',
        kk: 'Жүйеде жуырда',
        en: 'Recently joined',
      );
    }

    final String month = createdAt.month.toString().padLeft(2, '0');
    final String year = createdAt.year.toString();
    return _txt(
      context,
      ru: 'В системе с $month.$year',
      kk: 'Жүйеде: $month.$year',
      en: 'Member since $month.$year',
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.rewards});

  final UserRewards rewards;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations s = AppLocalizations.of(context)!;
    final List<MapEntry<String, String>> stats = <MapEntry<String, String>>[
      MapEntry<String, String>(s.xpLabel, '${rewards.totalXp}'),
      MapEntry<String, String>(s.levelLabel, '${rewards.level}'),
      MapEntry<String, String>(s.badgesLabel, '${rewards.badgeCount}'),
      MapEntry<String, String>(s.completedQuizzes, '${rewards.completedQuizzes}'),
      MapEntry<String, String>(s.averageScore, '${rewards.averageScore.toStringAsFixed(0)}%'),
      MapEntry<String, String>(
        s.streakLabel,
        _txt(context, ru: '${rewards.currentStreak} дней', kk: '${rewards.currentStreak} күн', en: '${rewards.currentStreak} days'),
      ),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.65,
      ),
      itemBuilder: (BuildContext context, int index) {
        final item = stats[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(item.key, style: AppTextStyles.secondary),
              const SizedBox(height: 4),
              Text(item.value, style: AppTextStyles.cardTitle),
            ],
          ),
        );
      },
    );
  }
}

class _RecentBadges extends StatelessWidget {
  const _RecentBadges({required this.rewards});

  final UserRewards rewards;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations s = AppLocalizations.of(context)!;
    final List<String> badges = rewards.badges;

    if (badges.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(s.noBadgesYet, style: AppTextStyles.secondary),
      );
    }

    return SizedBox(
      height: 176,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, int i) => Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(_badgeMeta(context, badges[i]).icon, color: AppColors.accent),
              const SizedBox(height: 8),
              Tooltip(
                message: _badgeMeta(context, badges[i]).title,
                child: Text(
                  _badgeMeta(context, badges[i]).title,
                  style: AppTextStyles.chip,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Tooltip(
                  message: _badgeMeta(context, badges[i]).description,
                  child: Text(
                    _badgeMeta(context, badges[i]).description,
                    style: AppTextStyles.secondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeMeta {
  const _BadgeMeta({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

_BadgeMeta _badgeMeta(BuildContext context, String badgeId) {
  final AppLocalizations s = AppLocalizations.of(context)!;
  switch (badgeId) {
    case 'first_test_completed':
      return _BadgeMeta(
        icon: Icons.flag_outlined,
        title: s.badgeFirstTestTitle,
        description: s.badgeFirstTestDescription,
      );
    case 'first_subtopic_completed':
      return _BadgeMeta(
        icon: Icons.school_outlined,
        title: s.badgeFirstSubtopicTitle,
        description: s.badgeFirstSubtopicDescription,
      );
    case 'xp_1000':
      return _BadgeMeta(
        icon: Icons.bolt_outlined,
        title: s.badgeXp1000Title,
        description: s.badgeXp1000Description,
      );
    case 'xp_3000':
      return _BadgeMeta(
        icon: Icons.auto_awesome_outlined,
        title: s.badgeXp3000Title,
        description: s.badgeXp3000Description,
      );
    case 'module_master':
      return _BadgeMeta(
        icon: Icons.workspace_premium_outlined,
        title: s.badgeModuleMasterTitle,
        description: s.badgeModuleMasterDescription,
      );
    case 'no_mistake_quiz':
      return _BadgeMeta(
        icon: Icons.verified_outlined,
        title: s.badgeNoMistakeTitle,
        description: s.badgeNoMistakeDescription,
      );
    case 'streak_3':
      return _BadgeMeta(
        icon: Icons.local_fire_department_outlined,
        title: s.badgeStreak3Title,
        description: s.badgeStreak3Description,
      );
    case 'streak_7':
      return _BadgeMeta(
        icon: Icons.whatshot_outlined,
        title: s.badgeStreak7Title,
        description: s.badgeStreak7Description,
      );
    default:
      return _BadgeMeta(
        icon: Icons.workspace_premium_outlined,
        title: s.badgesLabel,
        description: '',
      );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.title, required this.onTap, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title, style: AppTextStyles.body),
          subtitle: subtitle == null ? null : Text(subtitle!, style: AppTextStyles.secondary),
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
