import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class CheckEmailScreen extends ConsumerWidget {
  const CheckEmailScreen({
    super.key,
    required this.email,
  });

  final String email;
  static const String _resetContinueUrl =
      'https://siru-original.firebaseapp.com/auth/action';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            s.checkYourEmailTitle,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Text(
            s.checkYourEmailBody(email),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            s.openResetLinkHint,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: isLoading ? null : () => _resend(context, ref, s),
              child: Text(s.resendResetEmail),
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

  Future<void> _resend(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations s,
  ) async {
    if (email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.emailInvalid)),
      );
      return;
    }

    final ActionCodeSettings? settings = kIsWeb
        ? null
        : ActionCodeSettings(
            url: _resetContinueUrl,
            handleCodeInApp: true,
            androidPackageName: 'com.example.flutter_1',
            androidInstallApp: true,
            iOSBundleId: 'com.example.flutter1',
          );

    final String? error = await ref.read(authControllerProvider.notifier)
        .sendPasswordReset(email, settings: settings);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? s.passwordResetSent)),
    );
  }
}
