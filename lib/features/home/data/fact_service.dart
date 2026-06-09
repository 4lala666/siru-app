import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final factOfTheDayProvider = FutureProvider.family<String, String>((Ref ref, String lang) async {
  final FactService service = FactService();
  return service.getFactOfTheDay(lang: lang);
});

class FactService {
  Future<String> getFactOfTheDay({required String lang}) async {
    final String raw = await rootBundle.loadString('assets/data/facts.json');
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    if (decoded.isEmpty) return _fallbackFact(lang);

    final DateTime now = DateTime.now();
    final int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final int index = dayOfYear % decoded.length;
    final String englishFact = decoded[index].toString();

    final Map<String, List<String>> localized = <String, List<String>>{
      'ru': <String>[
        'Фишинговые кампании часто усиливаются по понедельникам, когда почта перегружена.',
        'MFA может блокировать более 99% автоматизированных атак на аккаунты.',
        'Большинство взломов начинаются с действий человека, а не с zero-day.',
        'Публичный Wi-Fi без VPN может раскрыть сессионные токены.',
        'Задержка с установкой патчей остаётся одной из главных причин компрометации.',
        'Принцип минимальных привилегий снижает ущерб даже после кражи учётных данных.',
        'DNS-спуфинг может перенаправлять пользователей на поддельные страницы входа.',
        'Повторное использование паролей остаётся одной из самых частых уязвимостей.',
        'Обучение по безопасности эффективнее в коротких и регулярных сессиях.',
        'Стратегия резервного копирования 3-2-1 остаётся базовым стандартом устойчивости.',
      ],
      'kk': <String>[
        'Фишинг науқандары көбіне дүйсенбіде, пошта көп болғанда күшейеді.',
        'MFA аккаунтқа жасалатын автоматтандырылған шабуылдардың 99%-дан астамын тоқтата алады.',
        'Бұзылулардың көбі zero-day-дан емес, адамның әрекетінен басталады.',
        'VPN-сыз ашық Wi-Fi сессия токендерінің ұсталып қалуына әкелуі мүмкін.',
        'Патчтарды кеш орнату әлі де сәтті шабуылдардың негізгі себептерінің бірі.',
        'Ең аз артықшылық қағидасы деректер ұрланғаннан кейін де зиянды азайтады.',
        'DNS spoofing қолданушыны жалған кіру бетіне бағыттауы мүмкін.',
        'Бір парольді қайталап қолдану әлі де ең жиі кездесетін қауіптердің бірі.',
        'Қауіпсіздік бойынша қысқа әрі жиі қайталанатын оқу ең тиімді.',
        '3-2-1 резервтік көшіру стратегиясы әлі де негізгі стандарт болып саналады.',
      ],
    };

    if (lang == 'en') {
      return englishFact;
    }
    final List<String>? list = localized[lang];
    if (list != null && index < list.length) {
      return list[index];
    }
    return _fallbackFact(lang);
  }

  String _fallbackFact(String lang) {
    switch (lang) {
      case 'kk':
        return 'Бір парольді бірнеше сервисте қолдану әлі де жиі кездесетін қауіптердің бірі.';
      case 'en':
        return 'Password reuse is still one of the most exploited user habits.';
      case 'ru':
      default:
        return 'Повторное использование пароля всё ещё остаётся одной из самых частых ошибок пользователей.';
    }
  }
}
