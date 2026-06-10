import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.code,
  });

  final String code;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isCheckingCode = true;
  String? _codeError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyCode();
    });
  }

  @override
  void dispose() {
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
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 40),
          IconButton(
            alignment: Alignment.centerLeft,
            onPressed: isLoading ? null : () => context.go('/auth'),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(height: 12),
          Text(
            s.resetPassword,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          if (_isCheckingCode)
            Text(s.checkingResetLink, style: const TextStyle(fontSize: 16))
          else if (_codeError != null)
            _ErrorState(
              message: _codeError!,
              actionLabel: s.backToLogin,
            )
          else ...<Widget>[
            Text(s.resetHint, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 28),
            Text(s.newPassword, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            _Input(controller: _passwordController, hint: s.min8),
            const SizedBox(height: 18),
            Text(s.confirmNewPassword, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            _Input(controller: _confirmController, hint: s.repeatPassword),
            const SizedBox(height: 18),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isLoading ? null : () => _submit(s),
                child: Text(s.resetPassword),
              ),
            ),
            if (isLoading) ...<Widget>[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _verifyCode() async {
    final AppLocalizations s = AppLocalizations.of(context)!;
    final String? error =
        await ref.read(authControllerProvider.notifier).verifyResetCode(widget.code);
    if (!mounted) return;
    setState(() {
      _isCheckingCode = false;
      _codeError = error == null ? null : s.invalidResetLink;
    });
  }

  Future<void> _submit(AppLocalizations s) async {
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(s.passwordInvalid)));
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.passwordsDoNotMatch)),
      );
      return;
    }

    final String? error = await ref
        .read(authControllerProvider.notifier)
        .confirmPasswordReset(widget.code, _passwordController.text.trim());

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    context.go('/auth/success');
  }
}

class _Input extends StatelessWidget {
  const _Input({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        obscureText: true,
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.actionLabel,
  });

  final String message;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => context.go('/auth'),
            child: Text(actionLabel),
          ),
        ),
      ],
    );
  }
}
