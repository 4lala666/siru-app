import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../l10n/app_localizations.dart';
import 'edit_profile_sheet.dart';

final isDarkModeProvider = StateProvider<bool>((Ref ref) => true);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = ref.watch(isDarkModeProvider);
    final String username = ref.watch(profileNameProvider);
    final IconData avatar = ref.watch(profileAvatarProvider);
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
          _ProfileSummaryCard(username: username, avatar: avatar),
          const SizedBox(height: 16),
          Text(_txt(context, ru: 'Кибер статистика', kk: 'Кибер статистика', en: 'Cyber Statistics'),
              style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          const _StatsGrid(),
          const SizedBox(height: 16),
          Text(_txt(context, ru: 'Последние бейджи', kk: 'Соңғы бейдждер', en: 'Recent Badges'),
              style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          const _RecentBadges(),
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
            onTap: () {},
          ),
          _SettingsTile(
            title: _txt(context, ru: 'Работа над ошибками', kk: 'Қателермен жұмыс', en: 'Work on mistakes'),
            onTap: () => context.push('/app/profile/mistakes'),
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
                    await ref.read(localeControllerProvider.notifier).setLocale('ru');
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
                _LangTile(
                  title: s.kazakh,
                  selected: code == 'kk',
                  onTap: () async {
                    await ref.read(localeControllerProvider.notifier).setLocale('kk');
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
                _LangTile(
                  title: s.english,
                  selected: code == 'en',
                  onTap: () async {
                    await ref.read(localeControllerProvider.notifier).setLocale('en');
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
  const _ProfileSummaryCard({required this.username, required this.avatar});

  final String username;
  final IconData avatar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      child: Text('Rank: Sentinel', style: AppTextStyles.chip),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Member since Jan 2026', style: AppTextStyles.secondary),
          const SizedBox(height: 10),
          Text('Level 6 • 1240 XP', style: AppTextStyles.body),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.62,
              minHeight: 8,
              backgroundColor: Color(0x33FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
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
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> stats = <MapEntry<String, String>>[
      const MapEntry<String, String>('XP earned', '1240'),
      const MapEntry<String, String>('Badges', '18'),
      const MapEntry<String, String>('Streak', '14 days'),
      const MapEntry<String, String>('Rank', 'Sentinel'),
      const MapEntry<String, String>('Threats stopped', '93'),
      const MapEntry<String, String>('Certifications', '4'),
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
  const _RecentBadges();

  @override
  Widget build(BuildContext context) {
    const badges = <String>['Phishing Hunter', 'MFA Expert', 'Blue Teamer', 'Cloud Guard'];

    return SizedBox(
      height: 90,
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
              const Icon(Icons.workspace_premium_outlined, color: AppColors.accent),
              const SizedBox(height: 8),
              Text(badges[i], style: AppTextStyles.chip),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.title, required this.onTap, this.subtitle});

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

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
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
