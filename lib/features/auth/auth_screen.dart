import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoginMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations s = AppLocalizations.of(context)!;
    final bool isLoading = ref.watch(authControllerProvider).isLoading;

    return SiruLayout(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              const SizedBox(height: 84),
              Text(
                _isLoginMode ? s.login : s.register,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 42),
              _Label(s.email),
              const SizedBox(height: 8),
              _InputField(
                controller: _emailController,
                hint: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              _Label(s.password),
              const SizedBox(height: 8),
              _InputField(
                controller: _passwordController,
                hint: s.min8,
                obscureText: true,
              ),
              if (!_isLoginMode) ...<Widget>[
                const SizedBox(height: 18),
                _Label(s.confirmPassword),
                const SizedBox(height: 8),
                _InputField(
                  controller: _confirmController,
                  hint: s.repeatPassword,
                  obscureText: true,
                ),
              ],
              if (_isLoginMode) ...<Widget>[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.go('/auth/forgot'),
                    child: Text(s.forgotPassword),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : (_isLoginMode ? _handleSignIn : _handleSignUp),
                  child: Text(_isLoginMode ? s.login : s.register),
                ),
              ),
              const SizedBox(height: 18),
              _DividerText(text: _isLoginMode ? s.orLoginVia : s.orCreateVia),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _SocialButton(
                    icon: SvgPicture.asset(
                      'assets/images/google_logo.svg',
                      width: 24,
                      height: 24,
                    ),
                    onTap: isLoading ? null : _handleGoogle,
                  ),
                  const SizedBox(width: 18),
                  _SocialButton(
                    icon: SvgPicture.asset(
                      'assets/images/apple_logo.svg',
                      width: 24,
                      height: 24,
                    ),
                    onTap: isLoading
                        ? null
                        : ((!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
                            ? _handleApple
                            : null),
                  ),
                ],
              ),
              const SizedBox(height: 42),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => setState(() {
                          _isLoginMode = !_isLoginMode;
                        }),
                child: Text(_isLoginMode ? s.noAccount : s.hasProfile),
              ),
              const SizedBox(height: 20),
            ],
          ),
          if (isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x33000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSignIn() async {
    final AppLocalizations s = AppLocalizations.of(context)!;
    if (!_validateInputs(s, requireConfirm: false)) {
      return;
    }

    final String? error =
        await ref.read(authControllerProvider.notifier).signInEmail(
              _emailController.text,
              _passwordController.text,
            );

    if (!mounted) return;

    if (error != null) {
      _showSnack(error);
      return;
    }

    context.go('/app');
  }

  Future<void> _handleSignUp() async {
    final AppLocalizations s = AppLocalizations.of(context)!;
    if (!_validateInputs(s, requireConfirm: true)) {
      return;
    }

    final String? error =
        await ref.read(authControllerProvider.notifier).signUpEmail(
              _emailController.text,
              _passwordController.text,
            );

    if (!mounted) return;

    if (error != null) {
      _showSnack(error);
      return;
    }

    context.go('/app');
  }

  Future<void> _handleGoogle() async {
    final String? error =
        await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    if (error != null) {
      _showSnack(error);
      return;
    }
    context.go('/app');
  }

  Future<void> _handleApple() async {
    final String? error =
        await ref.read(authControllerProvider.notifier).signInWithApple();
    if (!mounted) return;
    if (error != null) {
      _showSnack(error);
      return;
    }
    context.go('/app');
  }

  bool _validateInputs(AppLocalizations s, {required bool requireConfirm}) {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (!email.contains('@')) {
      _showSnack(s.emailInvalid);
      return false;
    }

    if (password.length < 6) {
      _showSnack(s.passwordInvalid);
      return false;
    }

    if (requireConfirm && password != _confirmController.text) {
      _showSnack(s.passwordsDoNotMatch);
      return false;
    }

    return true;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0x80000000)),
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFF2F2F2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        child: icon,
      ),
    );
  }
}

class _DividerText extends StatelessWidget {
  const _DividerText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: Color(0xFF5D6A87), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFFC7D3EB)),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFF5D6A87), thickness: 1)),
      ],
    );
  }
}
