import 'package:flutter/foundation.dart';

class Mistake {
  const Mistake({
    required this.questionId,
    required this.moduleId,
    required this.lessonId,
    required this.difficulty,
    required this.wrongCount,
    required this.lastWrongAt,
  });

  final String questionId;
  final String moduleId;
  final String lessonId;
  final String difficulty;
  final int wrongCount;
  final DateTime lastWrongAt;

  Mistake copyWith({
    String? questionId,
    String? moduleId,
    String? lessonId,
    String? difficulty,
    int? wrongCount,
    DateTime? lastWrongAt,
  }) {
    return Mistake(
      questionId: questionId ?? this.questionId,
      moduleId: moduleId ?? this.moduleId,
      lessonId: lessonId ?? this.lessonId,
      difficulty: difficulty ?? this.difficulty,
      wrongCount: wrongCount ?? this.wrongCount,
      lastWrongAt: lastWrongAt ?? this.lastWrongAt,
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.questionId,
    required this.moduleId,
    required this.lessonId,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.questionLocalized,
    required this.optionsLocalized,
    required this.correctIndex,
    required this.explanation,
    required this.explanationLocalized,
    required this.hint,
    required this.source,
  });

  final String questionId;
  final String moduleId;
  final String lessonId;
  final String type;
  final String difficulty;
  final String question;
  final List<String> options;
  final Map<String, String> questionLocalized;
  final Map<String, List<String>> optionsLocalized;
  final int correctIndex;
  final String explanation;
  final Map<String, String> explanationLocalized;
  final String hint;
  final QuestionSource? source;

  static const String _missingText = '—';

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final String question = _readLocalizedString(json['question'], fallback: _missingText);
    final List<String> options = _readLocalizedOptions(json['options']);
    final String explanation = _readLocalizedString(json['explanation'], fallback: '');

    return QuizQuestion(
      questionId: json['questionId'] as String,
      moduleId: json['moduleId'] as String,
      lessonId: (json['lessonId'] ?? '').toString(),
      type: (json['type'] ?? 'single_choice').toString(),
      difficulty: (json['difficulty'] ?? 'easy').toString(),
      question: question,
      options: options,
      questionLocalized: _readLocalizedStringMap(json['question'], fallback: question),
      optionsLocalized: _readLocalizedOptionsMap(json['options'], fallback: options),
      correctIndex: (json['correctIndex'] ?? json['correctAnswer'] ?? 0) as int,
      explanation: explanation,
      explanationLocalized: _readLocalizedStringMap(json['explanation'], fallback: explanation),
      hint: (json['hint'] ?? '').toString(),
      source: json['source'] is Map<String, dynamic>
          ? QuestionSource.fromJson(json['source'] as Map<String, dynamic>)
          : null,
    );
  }

  String localizedQuestion(String localeCode) {
    if (questionLocalized[localeCode]?.trim().isNotEmpty != true && localeCode != 'ru') {
      debugPrint('[quiz_l10n] missing $localeCode for questionId=$questionId field=question, fallback to ru');
    }
    final String base = _pickLocalized(questionLocalized, localeCode, fallback: question);
    return _ensureLocalized(base, localeCode, question);
  }

  List<String> localizedOptions(String localeCode) {
    if (optionsLocalized.isEmpty) return options;
    final List<String> raw = optionsLocalized[localeCode]?.isNotEmpty == true
        ? optionsLocalized[localeCode]!
        : (optionsLocalized['ru']?.isNotEmpty == true ? optionsLocalized['ru']! : options);
    if (optionsLocalized[localeCode]?.isNotEmpty != true && localeCode != 'ru') {
      debugPrint('[quiz_l10n] missing $localeCode for questionId=$questionId field=options, fallback to ru');
    }
    final List<String> ruBase = optionsLocalized['ru']?.isNotEmpty == true ? optionsLocalized['ru']! : options;
    return List<String>.generate(
      raw.length,
      (int i) => _ensureLocalized(
        raw[i],
        localeCode,
        i < ruBase.length ? ruBase[i] : raw[i],
      ),
    );
  }

  String localizedExplanation(String localeCode) {
    if (explanationLocalized[localeCode]?.trim().isNotEmpty != true && localeCode != 'ru') {
      debugPrint('[quiz_l10n] missing $localeCode for questionId=$questionId field=explanation, fallback to ru');
    }
    final String base = _pickLocalized(explanationLocalized, localeCode, fallback: explanation);
    return _ensureLocalized(base, localeCode, explanation);
  }

  static String _ensureLocalized(String candidate, String localeCode, String ruFallback) {
    if (localeCode == 'ru') return candidate;
    final String value = candidate.trim().isNotEmpty ? candidate : ruFallback;
    final bool looksRussian = RegExp(r'[А-Яа-яЁё]').hasMatch(value);
    if (!looksRussian) return value;
    return _autoTranslateFromRu(value, localeCode);
  }

  static String _autoTranslateFromRu(String text, String localeCode) {
    final List<MapEntry<String, String>> enRules = <MapEntry<String, String>>[
      const MapEntry<String, String>('Неверно', 'False'),
      const MapEntry<String, String>('Верно', 'True'),
      const MapEntry<String, String>('Сценарий: ', 'Scenario: '),
      const MapEntry<String, String>('Какой тезис относится к содержанию этой подтемы?', 'Which statement belongs to this subtopic content?'),
      const MapEntry<String, String>('Какое действие в этой теме является базово правильным?', 'Which action is a basic correct practice in this topic?'),
      const MapEntry<String, String>('Что из списка соответствует обучающему материалу подтемы?', 'Which option matches the learning material of this subtopic?'),
      const MapEntry<String, String>('Какое действие является ошибкой с точки зрения практик этой подтемы?', 'Which action is a mistake from the perspective of this subtopic practices?'),
      const MapEntry<String, String>('Какой итог правильно отражает практическое применение подтемы?', 'Which conclusion best reflects the practical use of this subtopic?'),
      const MapEntry<String, String>('Что сделать сначала?', 'What should be done first?'),
      const MapEntry<String, String>('Какое решение наиболее безопасно?', 'Which decision is the safest?'),
      const MapEntry<String, String>('Верно ли, что ', 'Is it true that '),
      const MapEntry<String, String>('вы заметили подозрительный признак.', 'you noticed a suspicious sign.'),
      const MapEntry<String, String>('коллега просит пропустить обязательную проверку ради скорости.', 'a colleague asks to skip a mandatory check to save time.'),
      const MapEntry<String, String>('Подтема подводит к комбинированному подходу: оценить риск, проверить контекст и действовать по правилу.', 'The subtopic leads to a combined approach: assess risk, verify context, and act by policy.'),
      const MapEntry<String, String>('Неверно. Если есть сомнение или риск, нужна дополнительная проверка.', 'False. If there is doubt or risk, additional verification is required.'),
      const MapEntry<String, String>('Верно. Подтема учит снижать риск за счет проверки и корректных действий.', 'True. The subtopic teaches reducing risk through verification and correct actions.'),
      const MapEntry<String, String>('Следовать регламенту.', 'Follow the procedure.'),
      const MapEntry<String, String>('Проверять контекст перед действием.', 'Check the context before acting.'),
      const MapEntry<String, String>('Документировать сомнительные ситуации.', 'Document suspicious situations.'),
      const MapEntry<String, String>('Игнорировать признаки риска и обходить проверку.', 'Ignore risk signs and bypass verification.'),
      const MapEntry<String, String>('Быстро выполнить действие без проверки.', 'Perform an action quickly without verification.'),
      const MapEntry<String, String>('Игнорировать риск ради удобства.', 'Ignore risk for convenience.'),
      const MapEntry<String, String>('Отключить защиту для ускорения.', 'Disable protection to speed things up.'),
      const MapEntry<String, String>('Сверять признаки риска перед действием.', 'Verify risk signs before acting.'),
      const MapEntry<String, String>('Действовать сразу без уточнений.', 'Act immediately without clarification.'),
      const MapEntry<String, String>('Передавать доступ без проверки.', 'Share access without verification.'),
      const MapEntry<String, String>('Игнорировать правила при нехватке времени.', 'Ignore rules when time is short.'),
      const MapEntry<String, String>('Продолжить как обычно.', 'Continue as usual.'),
      const MapEntry<String, String>('Отключить проверку для скорости.', 'Disable verification for speed.'),
      const MapEntry<String, String>('Проверить признак по безопасной процедуре и только потом действовать.', 'Verify the sign using a safe procedure and act only after that.'),
      const MapEntry<String, String>('Сразу передать данные без подтверждения.', 'Send the data immediately without confirmation.'),
      const MapEntry<String, String>('Согласиться, чтобы уложиться в срок.', 'Agree to meet the deadline.'),
      const MapEntry<String, String>('Зафиксировать риск и выполнить обязательную проверку.', 'Record the risk and complete the mandatory verification.'),
      const MapEntry<String, String>('Сделать исключение без подтверждения.', 'Make an exception without confirmation.'),
      const MapEntry<String, String>('Отключить проверку только на этот раз.', 'Disable verification just this once.'),
      const MapEntry<String, String>('Главное — скорость, а не проверка.', 'Speed matters more than verification.'),
      const MapEntry<String, String>('Достаточно одной меры без анализа.', 'One measure is enough without analysis.'),
      const MapEntry<String, String>('Оценка риска, проверка контекста и действие по процедуре.', 'Risk assessment, context verification, and action by procedure.'),
      const MapEntry<String, String>('Можно пропускать контроль в нестандартной ситуации.', 'You can skip controls in non-standard situations.'),
    ];

    final List<MapEntry<String, String>> kkRules = <MapEntry<String, String>>[
      const MapEntry<String, String>('Неверно', 'Бұрыс'),
      const MapEntry<String, String>('Верно', 'Дұрыс'),
      const MapEntry<String, String>('Сценарий: ', 'Сценарий: '),
      const MapEntry<String, String>('Какой тезис относится к содержанию этой подтемы?', 'Бұл ішкі тақырып мазмұнына қай тұжырым жатады?'),
      const MapEntry<String, String>('Какое действие в этой теме является базово правильным?', 'Бұл тақырыпта қандай әрекет базалық тұрғыдан дұрыс?'),
      const MapEntry<String, String>('Что из списка соответствует обучающему материалу подтемы?', 'Тізімдегі қайсысы ішкі тақырыптың оқу материалына сәйкес келеді?'),
      const MapEntry<String, String>('Какое действие является ошибкой с точки зрения практик этой подтемы?', 'Осы ішкі тақырып тәжірибесі тұрғысынан қай әрекет қате?'),
      const MapEntry<String, String>('Какой итог правильно отражает практическое применение подтемы?', 'Қай қорытынды ішкі тақырыптың практикалық қолданылуын дұрыс көрсетеді?'),
      const MapEntry<String, String>('Что сделать сначала?', 'Алдымен не істеу керек?'),
      const MapEntry<String, String>('Какое решение наиболее безопасно?', 'Ең қауіпсіз шешім қайсы?'),
      const MapEntry<String, String>('Верно ли, что ', 'Мына тұжырым дұрыс па: '),
      const MapEntry<String, String>('Подтема подводит к комбинированному подходу: оценить риск, проверить контекст и действовать по правилу.', 'Бұл ішкі тақырып біріктірілген тәсілді ұсынады: тәуекелді бағалау, контексті тексеру және ереже бойынша әрекет ету.'),
      const MapEntry<String, String>('Неверно. Если есть сомнение или риск, нужна дополнительная проверка.', 'Бұрыс. Егер күмән немесе тәуекел болса, қосымша тексеру қажет.'),
      const MapEntry<String, String>('Верно. Подтема учит снижать риск за счет проверки и корректных действий.', 'Дұрыс. Ішкі тақырып тексеру және дұрыс әрекет арқылы тәуекелді азайтуды үйретеді.'),
      const MapEntry<String, String>('Следовать регламенту.', 'Регламентті сақтау.'),
      const MapEntry<String, String>('Проверять контекст перед действием.', 'Әрекет жасамас бұрын жағдайды тексеру.'),
      const MapEntry<String, String>('Документировать сомнительные ситуации.', 'Күмәнді жағдайларды құжаттау.'),
      const MapEntry<String, String>('Игнорировать признаки риска и обходить проверку.', 'Қауіп белгілерін елемей, тексеруді айналып өту.'),
      const MapEntry<String, String>('Быстро выполнить действие без проверки.', 'Тексерусіз әрекетті жылдам орындау.'),
      const MapEntry<String, String>('Игнорировать риск ради удобства.', 'Ыңғай үшін тәуекелді елемеу.'),
      const MapEntry<String, String>('Отключить защиту для ускорения.', 'Жылдамдату үшін қорғауды өшіру.'),
      const MapEntry<String, String>('Сверять признаки риска перед действием.', 'Әрекет алдында тәуекел белгілерін тексеру.'),
      const MapEntry<String, String>('Действовать сразу без уточнений.', 'Нақтыламай бірден әрекет ету.'),
      const MapEntry<String, String>('Передавать доступ без проверки.', 'Тексерусіз қолжетімділік беру.'),
      const MapEntry<String, String>('Игнорировать правила при нехватке времени.', 'Уақыт жетпегенде ережені елемеу.'),
      const MapEntry<String, String>('Продолжить как обычно.', 'Әдеттегідей жалғастыру.'),
      const MapEntry<String, String>('Отключить проверку для скорости.', 'Жылдамдық үшін тексеруді өшіру.'),
      const MapEntry<String, String>('Проверить признак по безопасной процедуре и только потом действовать.', 'Белгіні қауіпсіз рәсіммен тексеріп, содан кейін ғана әрекет ету.'),
      const MapEntry<String, String>('Сразу передать данные без подтверждения.', 'Растамай бірден деректерді жіберу.'),
      const MapEntry<String, String>('Согласиться, чтобы уложиться в срок.', 'Мерзімге үлгеру үшін келісу.'),
      const MapEntry<String, String>('Зафиксировать риск и выполнить обязательную проверку.', 'Тәуекелді тіркеп, міндетті тексеруді орындау.'),
      const MapEntry<String, String>('Сделать исключение без подтверждения.', 'Растамай ерекшелік жасау.'),
      const MapEntry<String, String>('Отключить проверку только на этот раз.', 'Тек осы жолы тексеруді өшіру.'),
      const MapEntry<String, String>('Главное — скорость, а не проверка.', 'Бастысы — тексеру емес, жылдамдық.'),
      const MapEntry<String, String>('Достаточно одной меры без анализа.', 'Талдаусыз бір шараның өзі жеткілікті.'),
      const MapEntry<String, String>('Оценка риска, проверка контекста и действие по процедуре.', 'Тәуекелді бағалау, контексті тексеру және рәсім бойынша әрекет ету.'),
      const MapEntry<String, String>('Можно пропускать контроль в нестандартной ситуации.', 'Стандартты емес жағдайда бақылауды өткізіп жіберуге болады.'),
    ];

    final List<MapEntry<String, String>> rules = localeCode == 'en' ? enRules : kkRules;
    String out = text;
    for (final MapEntry<String, String> r in rules) {
      out = out.replaceAll(r.key, r.value);
    }
    return out;
  }

  static String _pickLocalized(Map<String, String> map, String localeCode, {required String fallback}) {
    if (map[localeCode]?.trim().isNotEmpty == true) return map[localeCode]!;
    if (map['ru']?.trim().isNotEmpty == true) return map['ru']!;
    if (fallback.trim().isNotEmpty) return fallback;
    return _missingText;
  }

  static String _readLocalizedString(dynamic raw, {required String fallback}) {
    if (raw is String && raw.trim().isNotEmpty) return raw;
    if (raw is Map) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(raw);
      final String ru = (map['ru'] ?? '').toString();
      final String en = (map['en'] ?? '').toString();
      final String kk = (map['kk'] ?? '').toString();
      if (ru.trim().isNotEmpty) return ru;
      if (en.trim().isNotEmpty) return en;
      if (kk.trim().isNotEmpty) return kk;
    }
    return fallback;
  }

  static Map<String, String> _readLocalizedStringMap(dynamic raw, {required String fallback}) {
    if (raw is Map) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(raw);
      return <String, String>{
        'ru': (map['ru'] ?? fallback).toString(),
        'en': (map['en'] ?? map['ru'] ?? fallback).toString(),
        'kk': (map['kk'] ?? map['ru'] ?? fallback).toString(),
      };
    }
    final String value = raw?.toString() ?? fallback;
    return <String, String>{'ru': value, 'en': value, 'kk': value};
  }

  static List<String> _readLocalizedOptions(dynamic raw) {
    if (raw is List) {
      return raw.map((dynamic e) => e.toString()).toList();
    }
    if (raw is Map) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(raw);
      final dynamic ru = map['ru'] ?? map['en'] ?? map['kk'] ?? const <dynamic>[];
      if (ru is List) {
        return ru.map((dynamic e) => e.toString()).toList();
      }
    }
    return const <String>[];
  }

  static Map<String, List<String>> _readLocalizedOptionsMap(dynamic raw, {required List<String> fallback}) {
    if (raw is Map) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(raw);
      List<String> asList(dynamic value) {
        if (value is List) return value.map((dynamic e) => e.toString()).toList();
        return fallback;
      }

      final List<String> ru = asList(map['ru']);
      return <String, List<String>>{
        'ru': ru,
        'en': asList(map['en']),
        'kk': asList(map['kk']),
      };
    }
    return <String, List<String>>{'ru': fallback, 'en': fallback, 'kk': fallback};
  }
}

class QuestionSource {
  const QuestionSource({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  factory QuestionSource.fromJson(Map<String, dynamic> json) {
    return QuestionSource(
      title: (json['title'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
    );
  }
}
