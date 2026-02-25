import 'package:flutter/material.dart';

class SurveyQuestion {
  const SurveyQuestion({
    required this.question,
    required this.options,
  });

  final String question;
  final List<String> options;
}

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('ru'),
    Locale('kk'),
    Locale('en'),
  ];

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? result =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return result ?? AppLocalizations(const Locale('ru'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get _code => locale.languageCode;

  String _pick({
    required String ru,
    required String kk,
    required String en,
  }) {
    switch (_code) {
      case 'kk':
        return kk;
      case 'en':
        return en;
      default:
        return ru;
    }
  }

  String get appName => 'SIRU';
  String get chooseLanguage =>
      _pick(ru: 'Выберите язык', kk: 'Тілді таңдаңыз', en: 'Choose language');
  String get langKk => 'Қазақша';
  String get langRu => 'Русский';
  String get langEn => 'English';

  String get welcomeIn => _pick(
      ru: 'Добро пожаловать в', kk: 'SIRU-ға қош келдіңіз', en: 'Welcome to');
  String get welcomeSubtitle => _pick(
        ru: 'Вход в безопасное пространство знаний',
        kk: 'Қауіпсіз білім кеңістігіне кіру',
        en: 'Your safe space for knowledge',
      );

  String get introMentor => _pick(
        ru: 'Мяу! Я Koneko - твой цифровой наставник.\nВ мире интернет много мышеловок, но я\nнаучу тебя обходить их стороной.',
        kk: 'Мяу! Мен Koneko - сенің цифрлық тәлімгеріңмін.\nИнтернетте тұзақ көп, бірақ мен\nоларды айналып өтуді үйретемін.',
        en: 'Meow! I am Koneko, your digital mentor.\nThe internet is full of traps, and I will\nteach you how to avoid them.',
      );
  String get continueText =>
      _pick(ru: 'Продолжить', kk: 'Жалғастыру', en: 'Continue');
  String get introStart => _pick(
        ru: 'Давай познакомимся ближе!\n\nОтветь на пару вопросов. Это поможет мне\nузнать тебя получше и понять твой текущий\nуровень подготовки.',
        kk: 'Жақынырақ танысайық!\n\nБірнеше сұраққа жауап бер. Бұл маған\nсені жақсырақ түсінуге және қазіргі\nдеңгейіңді анықтауға көмектеседі.',
        en: 'Let us get to know each other better!\n\nAnswer a few questions so I can\nunderstand your current level.',
      );
  String get startText => _pick(ru: 'Начать', kk: 'Бастау', en: 'Start');
  String get skipText => _pick(ru: 'Пропустить', kk: 'Өткізу', en: 'Skip');
  String get goText => _pick(ru: 'В путь!', kk: 'Алға!', en: 'Let\'s go!');

  String get surveyFinish => _pick(
        ru: 'Все готово. Мы подготовили для вас путь,\nкоторый прошли тысячи, но каждый\nнашел в нем что-то свое',
        kk: 'Бәрі дайын. Біз сіз үшін\nмыңдаған адам өткен жолды дайындадық,\nәркім одан өзіне керек нәрсе табады',
        en: 'All set. We prepared a path that\nthousands have walked, and everyone\nfinds something personal in it.',
      );

  List<SurveyQuestion> get surveyQuestions {
    switch (_code) {
      case 'kk':
        return const <SurveyQuestion>[
          SurveyQuestion(
            question: 'Бүгін SIRU-ға не әкелді?',
            options: <String>[
              'Жаңа нәрсе білгім келеді 📚',
              'Шабыт іздеп жүрмін ✨',
              'Өзімді дамытқым келеді 📈',
              'Жай қызығушылық 👀',
            ],
          ),
          SurveyQuestion(
            question: 'Киберқауіпсіздікпен таныссыз ба?',
            options: <String>[
              'Мен мүлде жаңадан бастаймын 🐣',
              'Аздап естігенмін 👂',
              'Негізгі білімім бар 🧠',
              'Мен чайникпін',
            ],
          ),
          SurveyQuestion(
            question: 'Өзін-өзі дамытуға қай уақытта көңіл бөлесіз?',
            options: <String>[
              'Сергек таң 🌅',
              'Түскі үзіліс ☕',
              'Тыныш кеш 🌙',
              'Ұйқы кезінде',
            ],
          ),
          SurveyQuestion(
            question: 'Күніне оқуға қанша уақыт бөлуге дайынсыз?',
            options: <String>[
              '5 минут (Жылдам старт) ⚡',
              '15-20 минут (Терең ену) 🌊',
              'Көңіл-күйге қарай 🎭',
              'Шексіз',
            ],
          ),
          SurveyQuestion(
            question: 'Білім алуда сіз үшін ең маңыздысы не?',
            options: <String>[
              'Түсіндірудің қарапайымдылығы 💡',
              'Практикалық пайда 🛠️',
              'Эстетика мен тәртіп 🏛️',
              'Бәрібір',
            ],
          ),
        ];
      case 'en':
        return const <SurveyQuestion>[
          SurveyQuestion(
            question: 'What brought you to SIRU today?',
            options: <String>[
              'I want to learn something new 📚',
              'I am looking for inspiration ✨',
              'I want self-growth 📈',
              'Simple curiosity 👀',
            ],
          ),
          SurveyQuestion(
            question: 'Are you familiar with cybersecurity?',
            options: <String>[
              'I am a complete beginner 🐣',
              'I heard about it a little 👂',
              'I have basic knowledge 🧠',
              'I am a newbie',
            ],
          ),
          SurveyQuestion(
            question: 'What time of day do you use for learning?',
            options: <String>[
              'Energetic morning 🌅',
              'Lunch break ☕',
              'Quiet evening 🌙',
              'During sleep',
            ],
          ),
          SurveyQuestion(
            question: 'How much time can you spend learning daily?',
            options: <String>[
              'Just 5 min (Quick start) ⚡',
              '15-20 min (Deep dive) 🌊',
              'Depends on mood 🎭',
              'Infinity',
            ],
          ),
          SurveyQuestion(
            question: 'What matters most in your learning process?',
            options: <String>[
              'Simple explanations 💡',
              'Practical value 🛠️',
              'Aesthetics and order 🏛️',
              'No preference',
            ],
          ),
        ];
      default:
        return const <SurveyQuestion>[
          SurveyQuestion(
            question: 'Что привело вас в SIRU сегодня?',
            options: <String>[
              'Желание узнать что-то новое 📚',
              'Поиск вдохновения ✨',
              'Стремление к саморазвитию 📈',
              'Простое любопытство 👀',
            ],
          ),
          SurveyQuestion(
            question: 'Знакомы ли вы с кибербезопасностью?',
            options: <String>[
              'Я абсолютный новичок 🐣',
              'Кое-что слышал(а) об этом 👂',
              'У меня есть базовые знания 🧠',
              'Я чайник',
            ],
          ),
          SurveyQuestion(
            question: 'Какое время дня вы обычно выделяете для саморазвития?',
            options: <String>[
              'Бодрое утро 🌅',
              'Обеденный перерыв ☕',
              'Тихий вечер 🌙',
              'Во время сна',
            ],
          ),
          SurveyQuestion(
            question: 'Сколько времени вы готовы уделять обучению в день?',
            options: <String>[
              'Всего 5 минут (Быстрый старт) ⚡',
              '15-20 минут (Глубокое погружение) 🌊',
              'По настроению 🎭',
              'Бесконечность',
            ],
          ),
          SurveyQuestion(
            question: 'Что для вас важнее всего в процессе получения знаний?',
            options: <String>[
              'Простота изложения 💡',
              'Практическая польза 🛠️',
              'Эстетика и порядок 🏛️',
              'Безразницы',
            ],
          ),
        ];
    }
  }

  String get register =>
      _pick(ru: 'Регистрация', kk: 'Тіркелу', en: 'Register');
  String get login => _pick(ru: 'Войти', kk: 'Кіру', en: 'Log in');
  String get email => _pick(ru: 'Почта', kk: 'Пошта', en: 'Email');
  String get createPassword => _pick(
      ru: 'Создайте пароль', kk: 'Құпиясөз жасаңыз', en: 'Create password');
  String get confirmPassword => _pick(
      ru: 'Подтвердите пароль',
      kk: 'Құпиясөзді растаңыз',
      en: 'Confirm password');
  String get min8 => _pick(
      ru: 'минимум 8 символов',
      kk: 'кемінде 8 таңба',
      en: 'minimum 8 characters');
  String get repeatPassword => _pick(
      ru: 'Повторите пароль',
      kk: 'Құпиясөзді қайталаңыз',
      en: 'Repeat password');
  String get noAccount => _pick(
        ru: 'Нет аккаунта? Зарегистрироваться',
        kk: 'Аккаунт жоқ па? Тіркелу',
        en: 'No account? Register',
      );
  String get hasProfile => _pick(
      ru: 'Уже есть профиль? Войти',
      kk: 'Профиль бар ма? Кіру',
      en: 'Already have an account? Log in');
  String get forgotPassword => _pick(
      ru: 'Забыли пароль?',
      kk: 'Құпиясөзді ұмыттыңыз ба?',
      en: 'Forgot password?');
  String get sendEmail =>
      _pick(ru: 'Введите почту', kk: 'Поштаны енгізіңіз', en: 'Enter email');
  String get rememberPassword => _pick(
      ru: 'Помните пароль? Войти',
      kk: 'Құпиясөз есіңізде ме? Кіру',
      en: 'Remember password? Log in');
  String get verifyMailTitle => _pick(
      ru: 'Пожалуйста, проверьте\nвашу почту',
      kk: 'Поштаңызды\nтексеріңіз',
      en: 'Please check\nyour email');
  String get sentCode => _pick(
        ru: 'Мы отправили код на helloworld@gmail.com',
        kk: 'Код helloworld@gmail.com поштасына жіберілді',
        en: 'We sent a code to helloworld@gmail.com',
      );
  String get verify => _pick(ru: 'Подтвердить', kk: 'Растау', en: 'Verify');
  String get resendCode => _pick(
      ru: 'Отправить код еще раз', kk: 'Кодты қайта жіберу', en: 'Resend code');
  String get resetPassword => _pick(
      ru: 'Сброс пароля',
      kk: 'Құпиясөзді қалпына келтіру',
      en: 'Reset password');
  String get resetHint => _pick(
        ru: 'Пожалуйста, введите то, что вы запомните',
        kk: 'Есте сақтайтын құпиясөзді енгізіңіз',
        en: 'Please enter a password you will remember',
      );
  String get newPassword =>
      _pick(ru: 'Новый пароль', kk: 'Жаңа құпиясөз', en: 'New password');
  String get confirmNewPassword => _pick(
      ru: 'Подтвердите новый пароль',
      kk: 'Жаңа құпиясөзді растаңыз',
      en: 'Confirm new password');
  String get passwordChanged => _pick(
      ru: 'Пароль изменен', kk: 'Құпиясөз өзгертілді', en: 'Password changed');
  String get passwordChangedSubtitle => _pick(
        ru: 'Ваш пароль был успешно\nизменен',
        kk: 'Құпиясөзіңіз сәтті\nөзгертілді',
        en: 'Your password has been\nchanged successfully',
      );
  String get backToLogin =>
      _pick(ru: 'Вернуться к входу', kk: 'Кіруге оралу', en: 'Back to login');
  String get wrongCode => _pick(
      ru: 'Неверный код. Проверьте и попробуйте снова.',
      kk: 'Қате код. Қайта тексеріңіз.',
      en: 'Invalid code. Please try again.');
  String get codeSent =>
      _pick(ru: 'Код отправлен', kk: 'Код жіберілді', en: 'Code sent');
  String get newCode => _pick(ru: 'Новый код', kk: 'Жаңа код', en: 'New code');

  String get home => _pick(ru: 'Главная', kk: 'Басты', en: 'Home');
  String get modules => _pick(ru: 'Модули', kk: 'Модульдер', en: 'Modules');
  String get profile => _pick(ru: 'Профиль', kk: 'Профиль', en: 'Profile');
  String get startLearning =>
      _pick(ru: 'Начать обучение', kk: 'Оқуды бастау', en: 'Start learning');
  String get openModulesHint => _pick(
        ru: 'Открой вкладку "Модули" внизу',
        kk: 'Төмендегі "Модульдер" бетін ашыңыз',
        en: 'Open the "Modules" tab below',
      );
  String get profileName => _pick(ru: 'Имя', kk: 'Аты', en: 'Name');
  String get profileNameValue =>
      _pick(ru: 'Пользователь SIRU', kk: 'SIRU пайдаланушысы', en: 'SIRU user');
  String get profileProgress =>
      _pick(ru: 'Прогресс', kk: 'Прогресс', en: 'Progress');
  String get profileProgressValue =>
      _pick(ru: '0% завершено', kk: '0% аяқталды', en: '0% completed');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const <String>['ru', 'kk', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
