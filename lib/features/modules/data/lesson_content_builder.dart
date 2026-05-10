import '../domain/lesson_content.dart';
import '../domain/module_models.dart';
import '../../mistakes/domain/mistake.dart';

class LessonContentBuilder {
  static LessonContent build({
    required Module module,
    required Lesson lesson,
    required String lang,
    required List<QuizQuestion> quizQuestions,
    required int lessonIndex,
  }) {
    if (lesson.id == 'gov_02') {
      return _ciaTriadTemplate(
        module: module,
        lesson: lesson,
        lang: lang,
        quizQuestions: quizQuestions,
        lessonIndex: lessonIndex,
      );
    }

    final bool hasRealContent = hasMeaningfulContent(lesson);
    final LessonTopicStatus status = inferStatus(
      lesson: lesson,
      lessonIndex: lessonIndex,
    );

    final List<LessonSection> sections = hasRealContent
        ? _genericSections(
            lesson: lesson,
            lang: lang,
            quizQuestions: quizQuestions,
          )
        : const <LessonSection>[];

    return LessonContent(
      id: '${module.id}_${lesson.id}',
      moduleId: module.id,
      topicId: lesson.id,
      title: tr(lesson.title, lang),
      moduleTitle: _cleanText(tr(module.title, lang)),
      subtitle: _cleanText(tr(lesson.summary, lang)),
      estimatedMinutes: lesson.durationMin,
      difficulty: module.difficulty,
      totalSteps: sections.where((LessonSection s) => s.type != LessonSectionType.sources).length,
      currentProgress: status == LessonTopicStatus.completed
          ? 1
          : status == LessonTopicStatus.inProgress
              ? 0.4
              : 0,
      heroIcon: _heroIconForModule(module.icon),
      status: status,
      sections: sections,
      quizId: quizQuestions.isEmpty ? null : lesson.id,
      sources: lesson.sources
          .map((LessonSource source) => LessonContentSource(
                title: _cleanText(tr(source.title, lang)),
                url: source.url,
              ))
          .toList(),
      hasRealContent: hasRealContent,
    );
  }

  static bool hasMeaningfulContent(Lesson lesson) {
    final String summary = lesson.summary.values.join(' ').trim();
    return summary.isNotEmpty ||
        lesson.whatYouWillLearn.values.any((List<String> items) => items.isNotEmpty) ||
        lesson.keyFacts.values.any((List<String> items) => items.isNotEmpty) ||
        lesson.examples.values.any((List<String> items) => items.isNotEmpty);
  }

  static LessonTopicStatus inferStatus({
    required Lesson lesson,
    required int lessonIndex,
  }) {
    final bool hasContent = hasMeaningfulContent(lesson);
    if (!hasContent && lessonIndex > 0) {
      return LessonTopicStatus.locked;
    }
    if (lesson.id == 'gov_01') {
      return LessonTopicStatus.completed;
    }
    if (lesson.id == 'gov_02') {
      return LessonTopicStatus.inProgress;
    }
    if (hasContent) {
      return LessonTopicStatus.notStarted;
    }
    return LessonTopicStatus.notStarted;
  }

  static List<LessonSection> _genericSections({
    required Lesson lesson,
    required String lang,
    required List<QuizQuestion> quizQuestions,
  }) {
    final String summary = _cleanText(tr(lesson.summary, lang));
    final List<String> learn = _cleanList(
      lesson.whatYouWillLearn[lang] ?? lesson.whatYouWillLearn['ru'] ?? const <String>[],
    );
    final List<String> facts = _cleanList(
      lesson.keyFacts[lang] ?? lesson.keyFacts['ru'] ?? const <String>[],
    );
    final List<String> examples = _cleanList(
      lesson.examples[lang] ?? lesson.examples['ru'] ?? const <String>[],
    );

    final List<LessonSection> sections = <LessonSection>[
      if (summary.isNotEmpty)
        LessonSection(
          id: '${lesson.id}_definition',
          type: LessonSectionType.definition,
          title: _tr(lang, 'definitionTitle'),
          body: summary,
          icon: 'shield',
        ),
      if (learn.isNotEmpty)
        LessonSection(
          id: '${lesson.id}_checklist',
          type: LessonSectionType.checklist,
          title: _tr(lang, 'checklistTitle'),
          items: learn,
          icon: 'checklist',
        ),
      if (facts.isNotEmpty)
        LessonSection(
          id: '${lesson.id}_remember',
          type: LessonSectionType.remember,
          title: _tr(lang, 'rememberTitle'),
          items: facts,
          icon: 'remember',
        ),
      if (examples.isNotEmpty)
        LessonSection(
          id: '${lesson.id}_example',
          type: LessonSectionType.example,
          title: _tr(lang, 'exampleTitle'),
          items: examples,
          icon: 'example',
        ),
      if (quizQuestions.isNotEmpty)
        LessonSection(
          id: '${lesson.id}_selfcheck',
          type: LessonSectionType.selfCheck,
          title: _tr(lang, 'selfCheckTitle'),
          question: quizQuestions.first.question,
          options: quizQuestions.first.options.take(3).toList(),
          correctIndex: quizQuestions.first.correctIndex < 3 ? quizQuestions.first.correctIndex : 0,
          explanation: quizQuestions.first.explanation,
        ),
    ];

    return sections;
  }

  static LessonContent _ciaTriadTemplate({
    required Module module,
    required Lesson lesson,
    required String lang,
    required List<QuizQuestion> quizQuestions,
    required int lessonIndex,
  }) {
    final _LocalizedContent localized = _ciaLocalized(lang);
    return LessonContent(
      id: '${module.id}_${lesson.id}',
      moduleId: module.id,
      topicId: lesson.id,
      title: localized.title,
      moduleTitle: localized.moduleTitle,
      subtitle: localized.subtitle,
      estimatedMinutes: 5,
      difficulty: 'easy',
      totalSteps: 7,
      currentProgress: 0.35,
      heroIcon: 'triad',
      status: inferStatus(lesson: lesson, lessonIndex: lessonIndex),
      sections: <LessonSection>[
        LessonSection(
          id: 'gov_02_definition',
          type: LessonSectionType.definition,
          title: localized.definitionTitle,
          body: localized.definitionBody,
          icon: 'definition',
        ),
        LessonSection(
          id: 'gov_02_importance',
          type: LessonSectionType.importance,
          title: localized.importanceTitle,
          body: localized.importanceBody,
          icon: 'importance',
        ),
        LessonSection(
          id: 'gov_02_example',
          type: LessonSectionType.example,
          title: localized.exampleTitle,
          body: localized.exampleBody,
          icon: 'example',
        ),
        LessonSection(
          id: 'gov_02_warning',
          type: LessonSectionType.warning,
          title: localized.warningTitle,
          body: localized.warningBody,
          icon: 'warning',
        ),
        LessonSection(
          id: 'gov_02_comparison',
          type: LessonSectionType.comparison,
          title: localized.comparisonTitle,
          items: localized.comparisonItems,
          icon: 'comparison',
        ),
        LessonSection(
          id: 'gov_02_checklist',
          type: LessonSectionType.checklist,
          title: localized.checklistTitle,
          items: localized.checklistItems,
          icon: 'checklist',
        ),
        LessonSection(
          id: 'gov_02_remember',
          type: LessonSectionType.remember,
          title: localized.rememberTitle,
          body: localized.rememberBody,
          icon: 'remember',
        ),
        LessonSection(
          id: 'gov_02_selfcheck',
          type: LessonSectionType.selfCheck,
          title: localized.selfCheckTitle,
          question: localized.selfCheckQuestion,
          options: localized.selfCheckOptions,
          correctIndex: 2,
          explanation: localized.selfCheckExplanation,
        ),
      ],
      quizId: quizQuestions.isEmpty ? null : lesson.id,
      sources: <LessonContentSource>[
        for (final LessonSource source in lesson.sources)
          LessonContentSource(
            title: _cleanText(tr(source.title, lang)),
            url: source.url,
          ),
      ],
      hasRealContent: true,
    );
  }

  static _LocalizedContent _ciaLocalized(String lang) {
    switch (lang) {
      case 'en':
        return const _LocalizedContent(
          moduleTitle: 'Governance & Risk',
          title: 'CIA triad and core security properties',
          subtitle:
              'A lesson about the three core security properties: confidentiality, integrity, and availability.',
          definitionTitle: 'What is it?',
          definitionBody:
              'CIA stands for Confidentiality, Integrity, and Availability. These three properties are the foundation of most information security conversations.',
          importanceTitle: 'Why is it important?',
          importanceBody:
              'If even one CIA element is broken, the system becomes unsafe. Data can be stolen, altered without permission, or become unavailable to users.',
          exampleTitle: 'Real-life example',
          exampleBody:
              'A company did not patch a server and lost access to its CRM after a ransomware attack. That impacted availability. If the attacker had changed customer data, integrity would also be affected. If data leaked, confidentiality would be affected too.',
          warningTitle: 'Typical mistake',
          warningBody:
              'Thinking security is only about preventing data theft. In reality, integrity and availability must be protected too.',
          comparisonTitle: 'Comparison',
          comparisonItems: <String>[
            'Confidentiality вЂ” only approved people can access the data.',
            'Integrity вЂ” data stays correct and is not changed without permission.',
            'Availability вЂ” systems and data are accessible when they are needed.',
          ],
          checklistTitle: 'How to protect it',
          checklistItems: <String>[
            'Restrict access to sensitive data.',
            'Use backups.',
            'Keep systems updated.',
            'Configure user permissions.',
            'Review event logs.',
          ],
          rememberTitle: 'Remember',
          rememberBody:
              'Information security is not only about secrecy. Data must remain protected, accurate, and available.',
          selfCheckTitle: 'Check yourself',
          selfCheckQuestion:
              'Which CIA element is affected if a user cannot open the system they need?',
          selfCheckOptions: <String>[
            'Confidentiality',
            'Integrity',
            'Availability',
          ],
          selfCheckExplanation:
              'If the system is not reachable when the user needs it, availability is broken.',
        );
      case 'kk':
        return const _LocalizedContent(
          moduleTitle: 'Р‘Р°СЃТ›Р°СЂСѓ Р¶У™РЅРµ С‚У™СѓРµРєРµР»',
          title: 'CIA С‚СЂРёР°РґР°СЃС‹ Р¶У™РЅРµ РЅРµРіС–Р·РіС– Т›Р°СѓС–РїСЃС–Р·РґС–Рє Т›Р°СЃРёРµС‚С‚РµСЂС–',
          subtitle:
              'ТљТ±РїРёСЏР»С‹Р»С‹Т›, С‚Т±С‚Р°СЃС‚С‹Т› Р¶У™РЅРµ Т›РѕР»Р¶РµС‚С–РјРґС–Р»С–Рє С‚СѓСЂР°Р»С‹ РЅРµРіС–Р·РіС– СЃР°Р±Р°Т›.',
          definitionTitle: 'Р‘Т±Р» РЅРµ?',
          definitionBody:
              'CIA вЂ” Confidentiality, Integrity, Availability СЃУ©Р·РґРµСЂС–РЅС–ТЈ Т›С‹СЃТ›Р°СЂС‚С‹Р»СѓС‹. Р‘Т±Р» ТЇС€ Т›Р°СЃРёРµС‚ Р°Т›РїР°СЂР°С‚С‚С‹Т› Т›Р°СѓС–РїСЃС–Р·РґС–Рє С‚Р°Т›С‹СЂС‹РїС‚Р°СЂС‹РЅС‹ТЈ РЅРµРіС–Р·С– Р±РѕР»С‹Рї СЃР°РЅР°Р»Р°РґС‹.',
          importanceTitle: 'РќРµРіРµ РјР°ТЈС‹Р·РґС‹?',
          importanceBody:
              'CIA СЌР»РµРјРµРЅС‚С‚РµСЂС–РЅС–ТЈ Р±С–СЂРµСѓС– Р±Т±Р·С‹Р»СЃР° РґР°, Р¶ТЇР№Рµ Т›Р°СѓС–РїСЃС–Р· Р±РѕР»РјР°Р№РґС‹. Р”РµСЂРµРєС‚РµСЂ Т±СЂР»Р°РЅСѓС‹, СЂТ±Т›СЃР°С‚СЃС‹Р· У©Р·РіРµСЂС‚С–Р»СѓС– РЅРµРјРµСЃРµ РїР°Р№РґР°Р»Р°РЅСѓС€С‹Т“Р° Т›РѕР»Р¶РµС‚С–РјСЃС–Р· Р±РѕР»СѓС‹ РјТЇРјРєС–РЅ.',
          exampleTitle: 'УЁРјС–СЂР»С–Рє РјС‹СЃР°Р»',
          exampleBody:
              'РљРѕРјРїР°РЅРёСЏ СЃРµСЂРІРµСЂРґС– СѓР°Т›С‹С‚С‹РЅРґР° Р¶Р°ТЈР°СЂС‚РїР°РґС‹ РґР°, С€РёС„СЂР»Р°СѓС€С‹ С€Р°Р±СѓС‹Р»С‹РЅР°РЅ РєРµР№С–РЅ CRM-РіРµ РєС–СЂРµ Р°Р»РјР°РґС‹. Р‘Т±Р» вЂ” Т›РѕР»Р¶РµС‚С–РјРґС–Р»С–РєРєРµ СЃРѕТ›Т›С‹. Р•РіРµСЂ С€Р°Р±СѓС‹Р»С€С‹ РєР»РёРµРЅС‚ РґРµСЂРµРєС‚РµСЂС–РЅ У©Р·РіРµСЂС‚СЃРµ, С‚Т±С‚Р°СЃС‚С‹Т› С‚Р° Р±Т±Р·С‹Р»Р°СЂ РµРґС–. Р•РіРµСЂ РґРµСЂРµРєС‚РµСЂ СЃС‹СЂС‚Т›Р° С€С‹Т›СЃР°, Т›Т±РїРёСЏР»С‹Р»С‹Т› Р±Т±Р·С‹Р»Р°РґС‹.',
          warningTitle: 'Р–РёС– Т›Р°С‚Рµ',
          warningBody:
              'ТљР°СѓС–РїСЃС–Р·РґС–РєС‚С– С‚РµРє РґРµСЂРµРє Т±СЂР»Р°РЅСѓРґР°РЅ Т›РѕСЂТ“Р°Сѓ РґРµРї РѕР№Р»Р°Сѓ. Р†СЃ Р¶ТЇР·С–РЅРґРµ С‚Т±С‚Р°СЃС‚С‹Т› РїРµРЅ Т›РѕР»Р¶РµС‚С–РјРґС–Р»С–РєС‚С– РґРµ Т›РѕСЂТ“Р°Сѓ РєРµСЂРµРє.',
          comparisonTitle: 'РЎР°Р»С‹СЃС‚С‹СЂСѓ',
          comparisonItems: <String>[
            'ТљТ±РїРёСЏР»С‹Р»С‹Т› вЂ” РґРµСЂРµРєС‚РµСЂРіРµ С‚РµРє СЂТ±Т›СЃР°С‚С‹ Р±Р°СЂ Р°РґР°РјРґР°СЂ Т“Р°РЅР° Т›РѕР» Р¶РµС‚РєС–Р·РµРґС–.',
            'РўТ±С‚Р°СЃС‚С‹Т› вЂ” РґРµСЂРµРєС‚РµСЂ РґТ±СЂС‹СЃ РєТЇР№С–РЅРґРµ СЃР°Т›С‚Р°Р»С‹Рї, СЂТ±Т›СЃР°С‚СЃС‹Р· У©Р·РіРµСЂРјРµР№РґС–.',
            'ТљРѕР»Р¶РµС‚С–РјРґС–Р»С–Рє вЂ” Р¶ТЇР№Рµ РјРµРЅ РґРµСЂРµРєС‚РµСЂ Т›Р°Р¶РµС‚ РєРµР·РґРµ Р°С€С‹Т› Р±РѕР»Р°РґС‹.',
          ],
          checklistTitle: 'ТљР°Р»Р°Р№ Т›РѕСЂТ“Р°СѓТ“Р° Р±РѕР»Р°РґС‹?',
          checklistItems: <String>[
            'Р”РµСЂРµРєС‚РµСЂРіРµ Т›РѕР»Р¶РµС‚С–РјРґС–Р»С–РєС‚С– С€РµРєС‚РµСѓ.',
            'Р РµР·РµСЂРІС‚С–Рє РєУ©С€С–СЂРјРµР»РµСЂ Т›РѕР»РґР°РЅСѓ.',
            'Р–ТЇР№РµР»РµСЂРґС– СѓР°Т›С‚С‹Р»С‹ Р¶Р°ТЈР°СЂС‚Сѓ.',
            'РџР°Р№РґР°Р»Р°РЅСѓС€С‹ Т›Т±Т›С‹Т›С‚Р°СЂС‹РЅ Р±Р°РїС‚Р°Сѓ.',
            'РћТ›РёТ“Р°Р»Р°СЂ Р¶СѓСЂРЅР°Р»С‹РЅ С‚РµРєСЃРµСЂСѓ.',
          ],
          rememberTitle: 'Р•СЃС‚Рµ СЃР°Т›С‚Р°',
          rememberBody:
              'РђТ›РїР°СЂР°С‚С‚С‹Т› Т›Р°СѓС–РїСЃС–Р·РґС–Рє С‚РµРє Т›Т±РїРёСЏ СЃР°Т›С‚Р°Сѓ РµРјРµСЃ. Р”РµСЂРµРєС‚РµСЂ Т›РѕСЂТ“Р°Р»Т“Р°РЅ, РґТ±СЂС‹СЃ Р¶У™РЅРµ Т›РѕР»Р¶РµС‚С–РјРґС– Р±РѕР»СѓС‹ С‚РёС–СЃ.',
          selfCheckTitle: 'УЁР·С–ТЈРґС– С‚РµРєСЃРµСЂ',
          selfCheckQuestion:
              'РџР°Р№РґР°Р»Р°РЅСѓС€С‹ РєРµСЂРµРє Р¶ТЇР№РµРЅС– Р°С€Р° Р°Р»РјР°СЃР°, CIA С‚СЂРёР°РґР°СЃС‹РЅС‹ТЈ Т›Р°Р№ СЌР»РµРјРµРЅС‚С– Р±Т±Р·С‹Р»Р°РґС‹?',
          selfCheckOptions: <String>[
            'ТљТ±РїРёСЏР»С‹Р»С‹Т›',
            'РўТ±С‚Р°СЃС‚С‹Т›',
            'ТљРѕР»Р¶РµС‚С–РјРґС–Р»С–Рє',
          ],
          selfCheckExplanation:
              'Р•РіРµСЂ Р¶ТЇР№Рµ РєРµСЂРµРє СЃУ™С‚С‚Рµ Т›РѕР»Р¶РµС‚С–РјСЃС–Р· Р±РѕР»СЃР°, РѕРЅРґР° Т›РѕР»Р¶РµС‚С–РјРґС–Р»С–Рє Р±Т±Р·С‹Р»Р°РґС‹.',
        );
      case 'ru':
      default:
        return const _LocalizedContent(
          moduleTitle: 'РћСЃРЅРѕРІС‹, СѓРїСЂР°РІР»РµРЅРёРµ Рё СЂРёСЃРє',
          title: 'CIA-С‚СЂРёР°РґР° Рё Р±Р°Р·РѕРІС‹Рµ СЃРІРѕР№СЃС‚РІР° Р±РµР·РѕРїР°СЃРЅРѕСЃС‚Рё',
          subtitle:
              'РЈСЂРѕРє Рѕ С‚СЂС‘С… Р±Р°Р·РѕРІС‹С… СЃРІРѕР№СЃС‚РІР°С… Р±РµР·РѕРїР°СЃРЅРѕСЃС‚Рё: РєРѕРЅС„РёРґРµРЅС†РёР°Р»СЊРЅРѕСЃС‚СЊ, С†РµР»РѕСЃС‚РЅРѕСЃС‚СЊ Рё РґРѕСЃС‚СѓРїРЅРѕСЃС‚СЊ.',
          definitionTitle: 'Р§С‚Рѕ СЌС‚Рѕ?',
          definitionBody:
              'CIA вЂ” СЌС‚Рѕ СЃРѕРєСЂР°С‰РµРЅРёРµ РѕС‚ Confidentiality, Integrity, Availability. РќР° СЂСѓСЃСЃРєРѕРј: РєРѕРЅС„РёРґРµРЅС†РёР°Р»СЊРЅРѕСЃС‚СЊ, С†РµР»РѕСЃС‚РЅРѕСЃС‚СЊ Рё РґРѕСЃС‚СѓРїРЅРѕСЃС‚СЊ. Р­С‚Рё С‚СЂРё СЃРІРѕР№СЃС‚РІР° СЃС‡РёС‚Р°СЋС‚СЃСЏ РѕСЃРЅРѕРІРѕР№ Р±РѕР»СЊС€РёРЅСЃС‚РІР° СЂР°Р·РіРѕРІРѕСЂРѕРІ РѕР± РёРЅС„РѕСЂРјР°С†РёРѕРЅРЅРѕР№ Р±РµР·РѕРїР°СЃРЅРѕСЃС‚Рё.',
          importanceTitle: 'РџРѕС‡РµРјСѓ СЌС‚Рѕ РІР°Р¶РЅРѕ?',
          importanceBody:
              'Р•СЃР»Рё РЅР°СЂСѓС€Р°РµС‚СЃСЏ С…РѕС‚СЏ Р±С‹ РѕРґРёРЅ СЌР»РµРјРµРЅС‚ CIA-С‚СЂРёР°РґС‹, СЃРёСЃС‚РµРјР° СЃС‚Р°РЅРѕРІРёС‚СЃСЏ РЅРµР±РµР·РѕРїР°СЃРЅРѕР№. РќР°РїСЂРёРјРµСЂ, РґР°РЅРЅС‹Рµ РјРѕРіСѓС‚ Р±С‹С‚СЊ СѓРєСЂР°РґРµРЅС‹, РёР·РјРµРЅРµРЅС‹ Р±РµР· СЂР°Р·СЂРµС€РµРЅРёСЏ РёР»Рё СЃС‚Р°С‚СЊ РЅРµРґРѕСЃС‚СѓРїРЅС‹РјРё РґР»СЏ РїРѕР»СЊР·РѕРІР°С‚РµР»РµР№.',
          exampleTitle: 'РџСЂРёРјРµСЂ РёР· Р¶РёР·РЅРё',
          exampleBody:
              'РљРѕРјРїР°РЅРёСЏ РЅРµ РѕР±РЅРѕРІРёР»Р° СЃРµСЂРІРµСЂ Рё РїРѕС‚РµСЂСЏР»Р° РґРѕСЃС‚СѓРї Рє CRM РїРѕСЃР»Рµ Р°С‚Р°РєРё С€РёС„СЂРѕРІР°Р»СЊС‰РёРєР°. Р’ СЌС‚РѕРј СЃР»СѓС‡Р°Рµ РїРѕСЃС‚СЂР°РґР°Р»Р° РґРѕСЃС‚СѓРїРЅРѕСЃС‚СЊ. Р•СЃР»Рё Р±С‹ Р·Р»РѕСѓРјС‹С€Р»РµРЅРЅРёРє РµС‰С‘ РёР·РјРµРЅРёР» РґР°РЅРЅС‹Рµ РєР»РёРµРЅС‚РѕРІ, РїРѕСЃС‚СЂР°РґР°Р»Р° Р±С‹ С†РµР»РѕСЃС‚РЅРѕСЃС‚СЊ. Р•СЃР»Рё Р±С‹ РґР°РЅРЅС‹Рµ СѓС‚РµРєР»Рё РЅР°СЂСѓР¶Сѓ, РїРѕСЃС‚СЂР°РґР°Р»Р° Р±С‹ РєРѕРЅС„РёРґРµРЅС†РёР°Р»СЊРЅРѕСЃС‚СЊ.',
          warningTitle: 'РўРёРїРёС‡РЅР°СЏ РѕС€РёР±РєР°',
          warningBody:
              'РЎС‡РёС‚Р°С‚СЊ, С‡С‚Рѕ Р±РµР·РѕРїР°СЃРЅРѕСЃС‚СЊ вЂ” СЌС‚Рѕ С‚РѕР»СЊРєРѕ Р·Р°С‰РёС‚Р° РѕС‚ РєСЂР°Р¶Рё РґР°РЅРЅС‹С…. РќР° РїСЂР°РєС‚РёРєРµ РІР°Р¶РЅРѕ Р·Р°С‰РёС‰Р°С‚СЊ РЅРµ С‚РѕР»СЊРєРѕ РєРѕРЅС„РёРґРµРЅС†РёР°Р»СЊРЅРѕСЃС‚СЊ, РЅРѕ Рё С†РµР»РѕСЃС‚РЅРѕСЃС‚СЊ, Рё РґРѕСЃС‚СѓРїРЅРѕСЃС‚СЊ.',
          comparisonTitle: 'РЎСЂР°РІРЅРµРЅРёРµ',
          comparisonItems: <String>[
            'РљРѕРЅС„РёРґРµРЅС†РёР°Р»СЊРЅРѕСЃС‚СЊ вЂ” РґРѕСЃС‚СѓРї Рє РґР°РЅРЅС‹Рј РµСЃС‚СЊ С‚РѕР»СЊРєРѕ Сѓ С‚РµС…, РєРѕРјСѓ СЂР°Р·СЂРµС€РµРЅРѕ.',
            'Р¦РµР»РѕСЃС‚РЅРѕСЃС‚СЊ вЂ” РґР°РЅРЅС‹Рµ РѕСЃС‚Р°СЋС‚СЃСЏ РїСЂР°РІРёР»СЊРЅС‹РјРё Рё РЅРµ РёР·РјРµРЅСЏСЋС‚СЃСЏ Р±РµР· СЂР°Р·СЂРµС€РµРЅРёСЏ.',
            'Р”РѕСЃС‚СѓРїРЅРѕСЃС‚СЊ вЂ” СЃРёСЃС‚РµРјР° Рё РґР°РЅРЅС‹Рµ РґРѕСЃС‚СѓРїРЅС‹ С‚РѕРіРґР°, РєРѕРіРґР° РѕРЅРё РЅСѓР¶РЅС‹.',
          ],
          checklistTitle: 'РљР°Рє Р·Р°С‰РёС‚РёС‚СЊСЃСЏ?',
          checklistItems: <String>[
            'РћРіСЂР°РЅРёС‡РёРІР°С‚СЊ РґРѕСЃС‚СѓРї Рє РґР°РЅРЅС‹Рј.',
            'РСЃРїРѕР»СЊР·РѕРІР°С‚СЊ СЂРµР·РµСЂРІРЅС‹Рµ РєРѕРїРёРё.',
            'РЎР»РµРґРёС‚СЊ Р·Р° РѕР±РЅРѕРІР»РµРЅРёСЏРјРё СЃРёСЃС‚РµРј.',
            'РќР°СЃС‚СЂР°РёРІР°С‚СЊ РїСЂР°РІР° РїРѕР»СЊР·РѕРІР°С‚РµР»РµР№.',
            'РџСЂРѕРІРµСЂСЏС‚СЊ Р¶СѓСЂРЅР°Р»С‹ СЃРѕР±С‹С‚РёР№.',
          ],
          rememberTitle: 'Р—Р°РїРѕРјРЅРё',
          rememberBody:
              'РРЅС„РѕСЂРјР°С†РёРѕРЅРЅР°СЏ Р±РµР·РѕРїР°СЃРЅРѕСЃС‚СЊ вЂ” СЌС‚Рѕ РЅРµ С‚РѕР»СЊРєРѕ СЃРµРєСЂРµС‚РЅРѕСЃС‚СЊ. Р’Р°Р¶РЅРѕ, С‡С‚РѕР±С‹ РґР°РЅРЅС‹Рµ Р±С‹Р»Рё Р·Р°С‰РёС‰РµРЅС‹, РЅРµ РёСЃРєР°Р¶Р°Р»РёСЃСЊ Рё РѕСЃС‚Р°РІР°Р»РёСЃСЊ РґРѕСЃС‚СѓРїРЅС‹РјРё.',
          selfCheckTitle: 'РџСЂРѕРІРµСЂСЊ СЃРµР±СЏ',
          selfCheckQuestion:
              'РљР°РєРѕР№ СЌР»РµРјРµРЅС‚ CIA-С‚СЂРёР°РґС‹ РЅР°СЂСѓС€Р°РµС‚СЃСЏ, РµСЃР»Рё РїРѕР»СЊР·РѕРІР°С‚РµР»СЊ РЅРµ РјРѕР¶РµС‚ РѕС‚РєСЂС‹С‚СЊ РЅСѓР¶РЅСѓСЋ СЃРёСЃС‚РµРјСѓ?',
          selfCheckOptions: <String>[
            'РљРѕРЅС„РёРґРµРЅС†РёР°Р»СЊРЅРѕСЃС‚СЊ',
            'Р¦РµР»РѕСЃС‚РЅРѕСЃС‚СЊ',
            'Р”РѕСЃС‚СѓРїРЅРѕСЃС‚СЊ',
          ],
          selfCheckExplanation:
              'Р•СЃР»Рё СЃРёСЃС‚РµРјР° РЅРµРґРѕСЃС‚СѓРїРЅР° РїРѕР»СЊР·РѕРІР°С‚РµР»СЋ РІ РЅСѓР¶РЅС‹Р№ РјРѕРјРµРЅС‚, РЅР°СЂСѓС€Р°РµС‚СЃСЏ РґРѕСЃС‚СѓРїРЅРѕСЃС‚СЊ.',
        );
    }
  }

  static String _heroIconForModule(String icon) {
    switch (icon) {
      case 'shield':
        return 'shield';
      case 'network':
        return 'network';
      case 'users':
        return 'people';
      default:
        return 'spark';
    }
  }

  static List<String> _cleanList(List<String> raw) {
    return raw.map(_cleanText).where((String item) => item.isNotEmpty).toList();
  }

  static String _cleanText(String raw) {
    return raw
        .replaceAll('РІР‚вЂќ', 'вЂ”')
        .replaceAll('РІР‚вЂњ', 'вЂ“')
        .replaceAll('РІР‚в„ў', 'вЂ™')
        .replaceAll('РІР‚В', 'вЂ')
        .replaceAll('РІР‚Сљ', 'вЂњ')
        .replaceAll('РІР‚Сњ', 'вЂќ')
        .replaceAll('Р В ', '')
        .trim();
  }

  static String _tr(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'definitionTitle': <String, String>{
        'ru': 'Р§С‚Рѕ СЌС‚Рѕ?',
        'en': 'What is it?',
        'kk': 'Р‘Т±Р» РЅРµ?',
      },
      'checklistTitle': <String, String>{
        'ru': 'РљР°Рє Р·Р°С‰РёС‚РёС‚СЊСЃСЏ?',
        'en': 'How to protect it',
        'kk': 'ТљР°Р»Р°Р№ Т›РѕСЂТ“Р°СѓТ“Р° Р±РѕР»Р°РґС‹?',
      },
      'rememberTitle': <String, String>{
        'ru': 'Р—Р°РїРѕРјРЅРё',
        'en': 'Remember',
        'kk': 'Р•СЃС‚Рµ СЃР°Т›С‚Р°',
      },
      'exampleTitle': <String, String>{
        'ru': 'РџСЂРёРјРµСЂ',
        'en': 'Example',
        'kk': 'РњС‹СЃР°Р»',
      },
      'selfCheckTitle': <String, String>{
        'ru': 'РџСЂРѕРІРµСЂСЊ СЃРµР±СЏ',
        'en': 'Check yourself',
        'kk': 'УЁР·С–ТЈРґС– С‚РµРєСЃРµСЂ',
      },
    };
    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

class _LocalizedContent {
  const _LocalizedContent({
    required this.moduleTitle,
    required this.title,
    required this.subtitle,
    required this.definitionTitle,
    required this.definitionBody,
    required this.importanceTitle,
    required this.importanceBody,
    required this.exampleTitle,
    required this.exampleBody,
    required this.warningTitle,
    required this.warningBody,
    required this.comparisonTitle,
    required this.comparisonItems,
    required this.checklistTitle,
    required this.checklistItems,
    required this.rememberTitle,
    required this.rememberBody,
    required this.selfCheckTitle,
    required this.selfCheckQuestion,
    required this.selfCheckOptions,
    required this.selfCheckExplanation,
  });

  final String moduleTitle;
  final String title;
  final String subtitle;
  final String definitionTitle;
  final String definitionBody;
  final String importanceTitle;
  final String importanceBody;
  final String exampleTitle;
  final String exampleBody;
  final String warningTitle;
  final String warningBody;
  final String comparisonTitle;
  final List<String> comparisonItems;
  final String checklistTitle;
  final List<String> checklistItems;
  final String rememberTitle;
  final String rememberBody;
  final String selfCheckTitle;
  final String selfCheckQuestion;
  final List<String> selfCheckOptions;
  final String selfCheckExplanation;
}

