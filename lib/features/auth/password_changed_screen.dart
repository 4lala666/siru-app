import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations s = AppLocalizations.of(context)!;

    return SiruLayout(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/galochka.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                s.passwordChanged,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                s.passwordChangedSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => context.go('/auth'),
                  child: Text(s.backToLogin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
