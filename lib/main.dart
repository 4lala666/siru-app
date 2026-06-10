import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_links/uni_links.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/localization/language_provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: SiruApp()));
}

class SiruApp extends ConsumerWidget {
  const SiruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String language = ref.watch(languageProvider);
    final Locale locale = Locale(language);

    return _DeepLinkHost(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        routerConfig: AppRouter.router,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}

class _DeepLinkHost extends StatefulWidget {
  const _DeepLinkHost({required this.child});

  final Widget child;

  @override
  State<_DeepLinkHost> createState() => _DeepLinkHostState();
}

class _DeepLinkHostState extends State<_DeepLinkHost> {
  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _listenForLinks();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  Future<void> _listenForLinks() async {
    try {
      final Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Initial deep link failed: $e');
    }

    _sub = uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (Object err) {
        debugPrint('Deep link stream error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    final Map<String, String> params = uri.queryParameters;
    final String? mode = params['mode'];
    final String? code = params['oobCode'];
    if (mode == 'resetPassword' && code != null && code.isNotEmpty) {
      AppRouter.router.go('/auth/reset/${Uri.encodeComponent(code)}');
      return;
    }

    final String? continueUrl = params['continueUrl'];
    if (continueUrl == null || continueUrl.isEmpty) {
      return;
    }

    final Uri? nestedUri = Uri.tryParse(continueUrl);
    if (nestedUri == null) {
      return;
    }

    final String? nestedMode = nestedUri.queryParameters['mode'];
    final String? nestedCode = nestedUri.queryParameters['oobCode'];
    if (nestedMode == 'resetPassword' &&
        nestedCode != null &&
        nestedCode.isNotEmpty) {
      AppRouter.router.go('/auth/reset/${Uri.encodeComponent(nestedCode)}');
    }
  }
}
