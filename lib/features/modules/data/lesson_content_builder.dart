import '../../mistakes/domain/mistake.dart';
import '../domain/lesson_content.dart';
import '../domain/module_models.dart';

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
              'CIA describes the three foundational properties of information security: confidentiality, integrity, and availability.',
          definitionTitle: 'What is it?',
          definitionBody:
              'CIA stands for Confidentiality, Integrity, and Availability. These three properties form the basis of most discussions about information security.',
          importanceTitle: 'Why is it important?',
          importanceBody:
              'If even one CIA element is broken, the system becomes unsafe. Data can be stolen, altered without permission, or become unavailable to users.',
          exampleTitle: 'Real-life example',
          exampleBody:
              'A company did not patch a server and lost access to its CRM after a ransomware attack. That affected availability. If the attacker had changed customer data, integrity would be affected too. If data leaked, confidentiality would also be broken.',
          warningTitle: 'Typical mistake',
          warningBody:
              'Thinking security is only about preventing data theft. In practice, integrity and availability must be protected too.',
          comparisonTitle: 'Comparison',
          comparisonItems: <String>[
            'Confidentiality — only approved people can access the data.',
            'Integrity — data stays correct and is not changed without permission.',
            'Availability — systems and data are accessible when they are needed.',
          ],
          checklistTitle: 'How to protect yourself',
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
          moduleTitle: 'Басқару және тәуекел',
          title: 'CIA триадасы және негізгі қауіпсіздік қасиеттері',
          subtitle:
              'Бұл сабақ ақпараттық қауіпсіздіктің үш негізгі қасиетін түсіндіреді: құпиялылық, тұтастық және қолжетімділік.',
          definitionTitle: 'Бұл не?',
          definitionBody:
              'CIA — Confidentiality, Integrity, Availability сөздерінің қысқартылуы. Қазақша айтқанда: құпиялылық, тұтастық және қолжетімділік. Бұл үш қасиет ақпараттық қауіпсіздік туралы негізгі түсінікті қалыптастырады.',
          importanceTitle: 'Неге бұл маңызды?',
          importanceBody:
              'Егер CIA элементтерінің біреуі бұзылса, жүйе қауіпсіз болмайды. Деректер ұрлануы, рұқсатсыз өзгертілуі немесе пайдаланушыға қолжетімсіз болуы мүмкін.',
          exampleTitle: 'Өмірлік мысал',
          exampleBody:
              'Компания серверді уақытында жаңартпады да, шифрлаушы шабуылынан кейін CRM-ге кіре алмады. Бұл — қолжетімділіктің бұзылуы. Егер шабуылшы клиент деректерін өзгерткенде, тұтастық та бұзылар еді. Ал деректер сыртқа шықса, құпиялылық бұзылады.',
          warningTitle: 'Жиі қате',
          warningBody:
              'Қауіпсіздік тек деректердің ұрлануынан қорғау деп ойлау. Іс жүзінде құпиялылықпен қатар тұтастық пен қолжетімділікті де қорғау қажет.',
          comparisonTitle: 'Салыстыру',
          comparisonItems: <String>[
            'Құпиялылық — деректерге тек рұқсаты бар адамдар ғана қол жеткізеді.',
            'Тұтастық — деректер дұрыс күйінде сақталып, рұқсатсыз өзгермейді.',
            'Қолжетімділік — жүйе мен деректер қажет кезде ашық болады.',
          ],
          checklistTitle: 'Қалай қорғануға болады?',
          checklistItems: <String>[
            'Деректерге қолжетімділікті шектеу.',
            'Резервтік көшірмелерді пайдалану.',
            'Жүйелерді уақытылы жаңарту.',
            'Пайдаланушы құқықтарын баптау.',
            'Оқиғалар журналын тексеру.',
          ],
          rememberTitle: 'Есте сақта',
          rememberBody:
              'Ақпараттық қауіпсіздік тек құпияны сақтау емес. Деректер қорғалған, дұрыс және қолжетімді болуы тиіс.',
          selfCheckTitle: 'Өзіңді тексер',
          selfCheckQuestion:
              'Пайдаланушы керек жүйені аша алмаса, CIA триадасының қай элементі бұзылады?',
          selfCheckOptions: <String>[
            'Құпиялылық',
            'Тұтастық',
            'Қолжетімділік',
          ],
          selfCheckExplanation:
              'Егер жүйе қажетті сәтте қолжетімсіз болса, онда қолжетімділік бұзылады.',
        );
      case 'ru':
      default:
        return const _LocalizedContent(
          moduleTitle: 'Основы, управление и риск',
          title: 'CIA-триада и базовые свойства безопасности',
          subtitle:
              'CIA-триада описывает три базовых свойства информационной безопасности: конфиденциальность, целостность и доступность.',
          definitionTitle: 'Что это?',
          definitionBody:
              'CIA — это сокращение от Confidentiality, Integrity, Availability. На русском: конфиденциальность, целостность и доступность. Эти три свойства считаются основой большинства разговоров об информационной безопасности.',
          importanceTitle: 'Почему это важно?',
          importanceBody:
              'Если нарушается хотя бы один элемент CIA-триады, система становится небезопасной. Например, данные могут быть украдены, изменены без разрешения или стать недоступными для пользователей.',
          exampleTitle: 'Пример из жизни',
          exampleBody:
              'Компания не обновила сервер и потеряла доступ к CRM после атаки шифровальщика. В этом случае пострадала доступность. Если бы злоумышленник ещё изменил данные клиентов, пострадала бы целостность. Если бы данные утекли наружу, пострадала бы конфиденциальность.',
          warningTitle: 'Типичная ошибка',
          warningBody:
              'Считать, что безопасность — это только защита от кражи данных. На практике важно защищать не только конфиденциальность, но и целостность, и доступность.',
          comparisonTitle: 'Сравнение',
          comparisonItems: <String>[
            'Конфиденциальность — доступ к данным есть только у тех, кому разрешено.',
            'Целостность — данные остаются правильными и не изменяются без разрешения.',
            'Доступность — система и данные доступны тогда, когда они нужны.',
          ],
          checklistTitle: 'Как защититься?',
          checklistItems: <String>[
            'Ограничивать доступ к данным.',
            'Использовать резервные копии.',
            'Следить за обновлениями систем.',
            'Настраивать права пользователей.',
            'Проверять журналы событий.',
          ],
          rememberTitle: 'Запомни',
          rememberBody:
              'Информационная безопасность — это не только секретность. Важно, чтобы данные были защищены, не искажались и оставались доступными.',
          selfCheckTitle: 'Проверь себя',
          selfCheckQuestion:
              'Какой элемент CIA-триады нарушается, если пользователь не может открыть нужную систему?',
          selfCheckOptions: <String>[
            'Конфиденциальность',
            'Целостность',
            'Доступность',
          ],
          selfCheckExplanation:
              'Если система недоступна пользователю в нужный момент, нарушается доступность.',
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
        .replaceAll('вЂ”', '—')
        .replaceAll('вЂ“', '–')
        .replaceAll('вЂ™', '’')
        .replaceAll('вЂ', '‘')
        .replaceAll('вЂњ', '“')
        .replaceAll('вЂќ', '”')
        .trim();
  }

  static String _tr(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'definitionTitle': <String, String>{
        'ru': 'Что это?',
        'en': 'What is it?',
        'kk': 'Бұл не?',
      },
      'checklistTitle': <String, String>{
        'ru': 'Как защититься?',
        'en': 'How to protect yourself',
        'kk': 'Қалай қорғануға болады?',
      },
      'rememberTitle': <String, String>{
        'ru': 'Запомни',
        'en': 'Remember',
        'kk': 'Есте сақта',
      },
      'exampleTitle': <String, String>{
        'ru': 'Пример',
        'en': 'Example',
        'kk': 'Мысал',
      },
      'selfCheckTitle': <String, String>{
        'ru': 'Проверь себя',
        'en': 'Check yourself',
        'kk': 'Өзіңді тексер',
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
