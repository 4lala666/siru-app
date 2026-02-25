import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            onPressed: isLoading ? null : () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(height: 12),
          Text(
            s.resetPassword,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Text(
            s.resetPasswordDialogHint,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 28),
          Text(s.email, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
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
          ),
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
              onPressed: isLoading ? null : _sendReset,
              child: Text(s.sendResetEmail),
            ),
          ),
          if (isLoading) ...<Widget>[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Future<void> _sendReset() async {
    final AppLocalizations s = AppLocalizations.of(context)!;
    final String email = _emailController.text.trim();
    if (!email.contains('@')) {
      _showSnack(s.emailInvalid);
      return;
    }

    final String? error =
        await ref.read(authControllerProvider.notifier).sendPasswordReset(email);

    if (!mounted) return;

    if (error != null) {
      _showSnack(error);
      return;
    }

    _showSnack(s.passwordResetSent);
    context.go('/auth/verify');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
