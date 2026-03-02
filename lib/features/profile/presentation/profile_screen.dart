import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'edit_profile_sheet.dart';

final isDarkModeProvider = StateProvider<bool>((Ref ref) => true);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = ref.watch(isDarkModeProvider);
    final String username = ref.watch(profileNameProvider);
    final IconData avatar = ref.watch(profileAvatarProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Profile', style: AppTextStyles.screenTitle),
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
          Text('Cyber Statistics', style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          const _StatsGrid(),
          const SizedBox(height: 16),
          Text('Recent Badges', style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          const _RecentBadges(),
          const SizedBox(height: 16),
          Text('Settings', style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          _SettingsTile(title: 'Language', onTap: () {}),
          _SettingsTile(title: 'Privacy & Security', onTap: () {}),
          _SettingsTile(
            title: 'Work on mistakes',
            onTap: () => context.push('/app/profile/mistakes'),
          ),
        ],
      ),
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
  const _SettingsTile({required this.title, required this.onTap});

  final String title;
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
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

