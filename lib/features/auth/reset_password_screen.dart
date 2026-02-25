import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations s = AppLocalizations.of(context)!;

    return SiruLayout(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 40),
          IconButton(
            alignment: Alignment.centerLeft,
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(height: 12),
          Text(
            s.resetPassword,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
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
              onPressed: () {
                if (_passwordController.text.length < 6) {
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
                context.go('/auth/success');
              },
              child: Text(s.resetPassword),
            ),
          ),
        ],
      ),
    );
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
