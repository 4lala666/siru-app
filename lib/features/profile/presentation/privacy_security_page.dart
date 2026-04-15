import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(_t(lang, 'title'))),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _SectionTitle(title: _t(lang, 'account')),
          _SettingTile(
            tileKey: const Key('ps.changePassword'),
            icon: Icons.lock_outline,
            title: _t(lang, 'changePassword'),
            onTap: () => context.push('/change-password'),
          ),
          _SettingTile(
            tileKey: const Key('ps.manageEmail'),
            icon: Icons.alternate_email,
            title: _t(lang, 'manageEmail'),
            onTap: () => context.push('/privacy-security/email'),
          ),
          const SizedBox(height: 12),
          _SectionTitle(title: _t(lang, 'security')),
          _SettingTile(
            tileKey: const Key('ps.twoFactor'),
            icon: Icons.verified_user_outlined,
            title: _t(lang, 'twoFactor'),
            onTap: () => context.push('/privacy-security/2fa'),
          ),
          _SettingTile(
            tileKey: const Key('ps.activeSessions'),
            icon: Icons.devices_outlined,
            title: _t(lang, 'activeSessions'),
            onTap: () => context.push('/privacy-security/sessions'),
          ),
          _SettingTile(
            tileKey: const Key('ps.loginHistory'),
            icon: Icons.history,
            title: _t(lang, 'loginHistory'),
            onTap: () => context.push('/privacy-security/login-history'),
          ),
          const SizedBox(height: 12),
          _SectionTitle(title: _t(lang, 'privacy')),
          _SettingTile(
            tileKey: const Key('ps.dataUsage'),
            icon: Icons.data_usage_outlined,
            title: _t(lang, 'dataUsage'),
            onTap: () => context.push('/privacy-security/data-usage'),
          ),
          _SettingTile(
            tileKey: const Key('ps.appPermissions'),
            icon: Icons.app_settings_alt_outlined,
            title: _t(lang, 'appPermissions'),
            onTap: () => _showAppPermissionsSheet(context, lang),
          ),
          _SettingTile(
            tileKey: const Key('ps.deleteAccount'),
            icon: Icons.delete_outline,
            title: _t(lang, 'deleteAccount'),
            onTap: () => context.push('/privacy-security/delete-account'),
          ),
          const SizedBox(height: 12),
          _SectionTitle(title: _t(lang, 'about')),
          _SettingTile(
            tileKey: const Key('ps.terms'),
            icon: Icons.description_outlined,
            title: _t(lang, 'terms'),
            onTap: () => context.push('/terms-of-service'),
          ),
          _SettingTile(
            tileKey: const Key('ps.privacyPolicy'),
            icon: Icons.privacy_tip_outlined,
            title: _t(lang, 'privacyPolicy'),
            onTap: () => context.push('/privacy-policy'),
          ),
        ],
      ),
    );
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'title': <String, String>{
        'ru': 'Приватность и безопасность',
        'en': 'Privacy & Security',
        'kk': 'Құпиялық және қауіпсіздік',
      },
      'account': <String, String>{
        'ru': 'Аккаунт',
        'en': 'Account',
        'kk': 'Аккаунт',
      },
      'changePassword': <String, String>{
        'ru': 'Изменить пароль',
        'en': 'Change Password',
        'kk': 'Құпиясөзді өзгерту',
      },
      'manageEmail': <String, String>{
        'ru': 'Управление почтой',
        'en': 'Manage Email',
        'kk': 'Email басқару',
      },
      'security': <String, String>{
        'ru': 'Безопасность',
        'en': 'Security',
        'kk': 'Қауіпсіздік',
      },
      'twoFactor': <String, String>{
        'ru': 'Двухфакторная аутентификация',
        'en': 'Two-Factor Authentication',
        'kk': 'Екі факторлы аутентификация',
      },
      'activeSessions': <String, String>{
        'ru': 'Активные сессии',
        'en': 'Active Sessions',
        'kk': 'Белсенді сессиялар',
      },
      'loginHistory': <String, String>{
        'ru': 'История входов',
        'en': 'Login History',
        'kk': 'Кіру тарихы',
      },
      'privacy': <String, String>{
        'ru': 'Приватность',
        'en': 'Privacy',
        'kk': 'Құпиялық',
      },
      'dataUsage': <String, String>{
        'ru': 'Использование данных',
        'en': 'Data Usage',
        'kk': 'Деректерді пайдалану',
      },
      'appPermissions': <String, String>{
        'ru': 'Разрешения приложения',
        'en': 'App Permissions',
        'kk': 'Қолданба рұқсаттары',
      },
      'deleteAccount': <String, String>{
        'ru': 'Удалить аккаунт',
        'en': 'Delete Account',
        'kk': 'Аккаунтты жою',
      },
      'about': <String, String>{
        'ru': 'О приложении',
        'en': 'About',
        'kk': 'Қосымша туралы',
      },
      'terms': <String, String>{
        'ru': 'Условия использования',
        'en': 'Terms of Service',
        'kk': 'Қызмет көрсету шарттары',
      },
      'privacyPolicy': <String, String>{
        'ru': 'Политика конфиденциальности',
        'en': 'Privacy Policy',
        'kk': 'Құпиялық саясаты',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }

  void _showAppPermissionsSheet(BuildContext context, String lang) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_t(lang, 'appPermissions'), style: AppTextStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              'Open OS Settings -> Apps -> Siru -> Permissions.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('ps.appPermissions.close'),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTextStyles.cardTitle),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.tileKey,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Key? tileKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          key: tileKey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Icon(icon, color: AppColors.text),
          title: Text(title, style: AppTextStyles.body),
          trailing:
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: onTap,
        ),
      ),
    );
  }
}
