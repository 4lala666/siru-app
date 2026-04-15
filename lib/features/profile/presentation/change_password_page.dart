import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/auth_controller.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    final bool isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(_t(lang, 'title'))),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_t(lang, 'subtitle'), style: AppTextStyles.secondary),
                    const SizedBox(height: 14),
                    _passwordField(
                      controller: _currentController,
                      label: _t(lang, 'currentPassword'),
                      hidden: _hideCurrent,
                      onToggle: () => setState(() => _hideCurrent = !_hideCurrent),
                      validator: (String? value) {
                        if ((value ?? '').trim().isEmpty) {
                          return _t(lang, 'currentRequired');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _passwordField(
                      controller: _newController,
                      label: _t(lang, 'newPassword'),
                      hidden: _hideNew,
                      onToggle: () => setState(() => _hideNew = !_hideNew),
                      validator: (String? value) {
                        final String v = (value ?? '').trim();
                        if (v.isEmpty) return _t(lang, 'newRequired');
                        if (v.length < 8) return _t(lang, 'newMin');
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _passwordField(
                      controller: _confirmController,
                      label: _t(lang, 'confirmPassword'),
                      hidden: _hideConfirm,
                      onToggle: () => setState(() => _hideConfirm = !_hideConfirm),
                      validator: (String? value) {
                        if ((value ?? '').trim().isEmpty) {
                          return _t(lang, 'confirmRequired');
                        }
                        if (value!.trim() != _newController.text.trim()) {
                          return _t(lang, 'confirmMismatch');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _submit(context, lang),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_t(lang, 'save')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool hidden,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: hidden,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, String lang) async {
    final FormState? state = _formKey.currentState;
    if (state == null || !state.validate()) return;

    final String? error = await ref.read(authControllerProvider.notifier).changePassword(
          currentPassword: _currentController.text.trim(),
          newPassword: _newController.text.trim(),
        );

    if (!context.mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_t(lang, 'success'))),
    );
    Navigator.of(context).pop();
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'title': <String, String>{
        'ru': 'Изменить пароль',
        'en': 'Change Password',
        'kk': 'Құпиясөзді өзгерту',
      },
      'subtitle': <String, String>{
        'ru': 'Введите текущий пароль и задайте новый.',
        'en': 'Enter current password and set a new one.',
        'kk': 'Ағымдағы құпиясөзді енгізіп, жаңасын орнатыңыз.',
      },
      'currentPassword': <String, String>{
        'ru': 'Текущий пароль',
        'en': 'Current Password',
        'kk': 'Ағымдағы құпиясөз',
      },
      'newPassword': <String, String>{
        'ru': 'Новый пароль',
        'en': 'New Password',
        'kk': 'Жаңа құпиясөз',
      },
      'confirmPassword': <String, String>{
        'ru': 'Подтвердите новый пароль',
        'en': 'Confirm New Password',
        'kk': 'Жаңа құпиясөзді растаңыз',
      },
      'currentRequired': <String, String>{
        'ru': 'Введите текущий пароль',
        'en': 'Enter current password',
        'kk': 'Ағымдағы құпиясөзді енгізіңіз',
      },
      'newRequired': <String, String>{
        'ru': 'Введите новый пароль',
        'en': 'Enter new password',
        'kk': 'Жаңа құпиясөзді енгізіңіз',
      },
      'newMin': <String, String>{
        'ru': 'Минимум 8 символов',
        'en': 'Minimum 8 characters',
        'kk': 'Кемінде 8 таңба',
      },
      'confirmRequired': <String, String>{
        'ru': 'Подтвердите новый пароль',
        'en': 'Confirm new password',
        'kk': 'Жаңа құпиясөзді растаңыз',
      },
      'confirmMismatch': <String, String>{
        'ru': 'Пароли не совпадают',
        'en': 'Passwords do not match',
        'kk': 'Құпиясөздер сәйкес емес',
      },
      'save': <String, String>{
        'ru': 'Сохранить',
        'en': 'Save',
        'kk': 'Сақтау',
      },
      'success': <String, String>{
        'ru': 'Пароль успешно изменен',
        'en': 'Password changed successfully',
        'kk': 'Құпиясөз сәтті өзгертілді',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

