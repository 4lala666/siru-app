import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>(
  (Ref ref) => LocaleController(),
);

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('ru')) {
    _load();
  }

  static const String _key = 'app_locale_code';

  Future<void> _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_key);
    if (code != null && code.isNotEmpty) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(String code) async {
    state = Locale(code);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}
