import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/siru_layout.dart';
import '../../l10n/app_localizations.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations s = AppLocalizations.of(context)!;

    return SiruLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 140),
          const Text(
            'SIRU',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            s.chooseLanguageTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          _LanguageButton(
            label: s.kazakh,
            onTap: () => _selectLanguage(context, ref, 'kk'),
          ),
          const SizedBox(height: 12),
          _LanguageButton(
            label: s.russian,
            onTap: () => _selectLanguage(context, ref, 'ru'),
          ),
          const SizedBox(height: 12),
          _LanguageButton(
            label: s.english,
            onTap: () => _selectLanguage(context, ref, 'en'),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    WidgetRef ref,
    String code,
  ) async {
    await ref.read(languageProvider.notifier).setLanguage(code);
    if (context.mounted) {
      context.go('/welcome');
    }
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
