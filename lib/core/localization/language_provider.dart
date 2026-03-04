import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider =
    StateNotifierProvider<LanguageNotifier, String>((Ref ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('ru') {
    loadLanguage();
  }

  static const String _key = 'app_language_code';

  Future<void> loadLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_key);
    if (saved == null || saved.isEmpty) {
      state = 'ru';
      return;
    }
    state = saved;
  }

  Future<void> setLanguage(String lang) async {
    state = lang;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, lang);
  }
}
