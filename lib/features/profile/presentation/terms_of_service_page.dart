import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(_t(lang, 'title')),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _title(_t(lang, 'docTitle')),
          _muted(_t(lang, 'effectiveDate')),
          const SizedBox(height: 16),
          _section(
            '1. ${_t(lang, 's1')}',
            <String>[
              _t(lang, 's1_1'),
              _t(lang, 's1_2'),
              _t(lang, 's1_3'),
            ],
          ),
          _section(
            '2. ${_t(lang, 's2')}',
            <String>[
              _t(lang, 's2_1'),
              _t(lang, 's2_2'),
              _t(lang, 's2_3'),
              _t(lang, 's2_4'),
              _t(lang, 's2_5'),
            ],
          ),
          _section(
            '3. ${_t(lang, 's3')}',
            <String>[
              _t(lang, 's3_1'),
              _t(lang, 's3_2'),
              _t(lang, 's3_3'),
              _t(lang, 's3_4'),
            ],
          ),
          _section(
            '4. ${_t(lang, 's4')}',
            <String>[
              _t(lang, 's4_1'),
              _t(lang, 's4_2'),
              _t(lang, 's4_3'),
            ],
          ),
          _section(
            '5. ${_t(lang, 's5')}',
            <String>[
              _t(lang, 's5_1'),
              _t(lang, 's5_2'),
              _t(lang, 's5_3'),
              _t(lang, 's5_4'),
            ],
          ),
          _section(
            '6. ${_t(lang, 's6')}',
            <String>[
              _t(lang, 's6_1'),
              _t(lang, 's6_2'),
              _t(lang, 's6_3'),
            ],
          ),
          _section(
            '7. ${_t(lang, 's7')}',
            <String>[
              _t(lang, 's7_1'),
              _t(lang, 's7_2'),
              _t(lang, 's7_3'),
            ],
          ),
          _section(
            '8. ${_t(lang, 's8')}',
            <String>[
              _t(lang, 's8_1'),
              _t(lang, 's8_2'),
              _t(lang, 's8_3'),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _title(String text) => Text(text, style: AppTextStyles.screenTitle);

  Widget _muted(String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(text, style: AppTextStyles.secondary),
      );

  Widget _section(String heading, List<String> paragraphs) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(heading, style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          ...paragraphs.map((String p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(p, style: AppTextStyles.body),
              )),
        ],
      ),
    );
  }

  String _t(String lang, String key) {
    const Map<String, Map<String, String>> dict = <String, Map<String, String>>{
      'title': <String, String>{
        'ru': 'Условия использования',
        'en': 'Terms of Service',
        'kk': 'Қызмет көрсету шарттары',
      },
      'docTitle': <String, String>{
        'ru': 'Пользовательское соглашение (Условия использования) Siru',
        'en': 'Siru User Agreement (Terms of Service)',
        'kk': 'Siru Пайдаланушы келісімі (Қызмет көрсету шарттары)',
      },
      'effectiveDate': <String, String>{
        'ru': 'Дата вступления в силу: «___» __________ 20__ г.',
        'en': 'Effective date: “___” __________ 20__',
        'kk': 'Күшіне ену күні: «___» __________ 20__ ж.',
      },
      's1': <String, String>{'ru': 'Общие положения', 'en': 'General Provisions', 'kk': 'Жалпы ережелер'},
      's1_1': <String, String>{
        'ru': 'Настоящее Соглашение регулирует использование приложения Siru для обучения кибербезопасности.',
        'en': 'This Agreement governs the use of the Siru cybersecurity learning app.',
        'kk': 'Осы Келісім Siru киберқауіпсіздік оқыту қолданбасын пайдалануды реттейді.',
      },
      's1_2': <String, String>{
        'ru': 'Используя приложение, пользователь подтверждает принятие условий.',
        'en': 'By using the app, the user confirms acceptance of these terms.',
        'kk': 'Қолданбаны пайдалану арқылы пайдаланушы шарттарды қабылдағанын растайды.',
      },
      's1_3': <String, String>{
        'ru': 'При несогласии с условиями необходимо прекратить использование приложения.',
        'en': 'If you disagree with these terms, you must stop using the app.',
        'kk': 'Егер шарттармен келіспесеңіз, қолданбаны пайдалануды тоқтатуыңыз керек.',
      },
      's2': <String, String>{'ru': 'Регистрация и аккаунт', 'en': 'Registration and Account', 'kk': 'Тіркелу және аккаунт'},
      's2_1': <String, String>{
        'ru': 'Для доступа к части функций требуется аккаунт.',
        'en': 'An account may be required to access certain features.',
        'kk': 'Кейбір функцияларға қол жеткізу үшін аккаунт қажет болуы мүмкін.',
      },
      's2_2': <String, String>{
        'ru': 'Пользователь обязан предоставлять достоверные регистрационные данные.',
        'en': 'The user must provide accurate registration data.',
        'kk': 'Пайдаланушы тіркеу кезінде дұрыс деректерді ұсынуы тиіс.',
      },
      's2_3': <String, String>{
        'ru': 'Пользователь несет ответственность за сохранность данных входа.',
        'en': 'The user is responsible for safeguarding login credentials.',
        'kk': 'Пайдаланушы кіру деректерінің қауіпсіздігіне өзі жауап береді.',
      },
      's2_4': <String, String>{
        'ru': 'Передача аккаунта третьим лицам запрещена.',
        'en': 'Sharing your account with third parties is prohibited.',
        'kk': 'Аккаунтты үшінші тұлғаларға беру тыйым салынады.',
      },
      's2_5': <String, String>{
        'ru': 'При подозрении компрометации аккаунта пользователь обязан сменить пароль.',
        'en': 'If compromise is suspected, the user must immediately change the password.',
        'kk': 'Аккаунт бұзылды деген күдік болса, пайдаланушы парольді дереу өзгертуі керек.',
      },
      's3': <String, String>{'ru': 'Использование приложения', 'en': 'Use of the App', 'kk': 'Қолданбаны пайдалану'},
      's3_1': <String, String>{
        'ru': 'Приложение используется только в образовательных целях.',
        'en': 'The app is intended for educational purposes only.',
        'kk': 'Қолданба тек білім беру мақсатында пайдаланылады.',
      },
      's3_2': <String, String>{
        'ru': 'Запрещены взлом, несанкционированный доступ и иные противоправные действия.',
        'en': 'Hacking, unauthorized access, and other unlawful actions are prohibited.',
        'kk': 'Бұзу, рұқсатсыз қол жеткізу және өзге заңсыз әрекеттерге тыйым салынады.',
      },
      's3_3': <String, String>{
        'ru': 'Запрещено распространение вредоносного контента и злоупотребление системой.',
        'en': 'Distribution of malicious content and abuse of the system are prohibited.',
        'kk': 'Зиянды контент таратуға және жүйені теріс пайдалануға тыйым салынады.',
      },
      's3_4': <String, String>{
        'ru': 'Материалы Siru не должны использоваться для нанесения вреда.',
        'en': 'Siru materials must not be used to cause harm.',
        'kk': 'Siru материалдарын зиян келтіру үшін пайдалануға болмайды.',
      },
      's4': <String, String>{'ru': 'Интеллектуальная собственность', 'en': 'Intellectual Property', 'kk': 'Зияткерлік меншік'},
      's4_1': <String, String>{
        'ru': 'Тексты, тесты, дизайн и структура курсов принадлежат разработчикам Siru.',
        'en': 'Texts, quizzes, design, and course structure belong to Siru developers.',
        'kk': 'Мәтіндер, тесттер, дизайн және курс құрылымы Siru әзірлеушілеріне тиесілі.',
      },
      's4_2': <String, String>{
        'ru': 'Пользователю предоставляется ограниченное право личного использования.',
        'en': 'Users receive limited rights for personal use.',
        'kk': 'Пайдаланушыға жеке қолдануға шектеулі құқық беріледі.',
      },
      's4_3': <String, String>{
        'ru': 'Копирование и распространение без разрешения запрещены.',
        'en': 'Copying and distribution without permission are prohibited.',
        'kk': 'Рұқсатсыз көшіруге және таратуға тыйым салынады.',
      },
      's5': <String, String>{'ru': 'Ответственность', 'en': 'Liability', 'kk': 'Жауапкершілік'},
      's5_1': <String, String>{
        'ru': 'Приложение предоставляется на условиях «как есть».',
        'en': 'The app is provided “as is.”',
        'kk': 'Қолданба «бар күйінде» ұсынылады.',
      },
      's5_2': <String, String>{
        'ru': 'Разработчики не гарантируют бесперебойную работу без ошибок.',
        'en': 'Developers do not guarantee uninterrupted and error-free operation.',
        'kk': 'Әзірлеушілер қателіксіз және үздіксіз жұмысты кепілдендірмейді.',
      },
      's5_3': <String, String>{
        'ru': 'Разработчики не несут ответственность за временные сбои и их последствия.',
        'en': 'Developers are not liable for temporary outages and consequences.',
        'kk': 'Әзірлеушілер уақытша ақаулар мен олардың салдары үшін жауап бермейді.',
      },
      's5_4': <String, String>{
        'ru': 'Пользователь сам отвечает за законность применения полученных знаний.',
        'en': 'Users are responsible for lawful use of acquired knowledge.',
        'kk': 'Пайдаланушы алған білімін заңды түрде қолдануға өзі жауап береді.',
      },
      's6': <String, String>{'ru': 'Конфиденциальность', 'en': 'Privacy', 'kk': 'Құпиялық'},
      's6_1': <String, String>{
        'ru': 'Разработчики принимают меры для защиты данных пользователя.',
        'en': 'Developers take measures to protect user data.',
        'kk': 'Әзірлеушілер пайдаланушы деректерін қорғау шараларын қолданады.',
      },
      's6_2': <String, String>{
        'ru': 'Порядок обработки данных определяется Политикой конфиденциальности.',
        'en': 'Data processing is governed by the Privacy Policy.',
        'kk': 'Деректерді өңдеу тәртібі Құпиялық саясатымен анықталады.',
      },
      's6_3': <String, String>{
        'ru': 'Используя приложение, пользователь соглашается с Политикой конфиденциальности.',
        'en': 'By using the app, the user agrees to the Privacy Policy.',
        'kk': 'Қолданбаны пайдалану арқылы пайдаланушы Құпиялық саясатымен келіседі.',
      },
      's7': <String, String>{'ru': 'Изменения условий', 'en': 'Changes to Terms', 'kk': 'Шарттарды өзгерту'},
      's7_1': <String, String>{
        'ru': 'Разработчики вправе изменять Соглашение в любое время.',
        'en': 'Developers may update this Agreement at any time.',
        'kk': 'Әзірлеушілер осы Келісімді кез келген уақытта өзгерте алады.',
      },
      's7_2': <String, String>{
        'ru': 'Обновленная версия действует с момента публикации в приложении.',
        'en': 'The updated version takes effect upon publication in the app.',
        'kk': 'Жаңартылған нұсқа қолданбада жарияланған сәттен бастап күшіне енеді.',
      },
      's7_3': <String, String>{
        'ru': 'Пользователь обязан самостоятельно отслеживать изменения.',
        'en': 'The user is responsible for reviewing updates.',
        'kk': 'Пайдаланушы өзгерістерді өз бетінше бақылауы тиіс.',
      },
      's8': <String, String>{'ru': 'Заключительные положения', 'en': 'Final Provisions', 'kk': 'Қорытынды ережелер'},
      's8_1': <String, String>{
        'ru': 'Соглашение регулирует использование приложения между пользователем и разработчиками Siru.',
        'en': 'This Agreement governs app use between the user and Siru developers.',
        'kk': 'Бұл Келісім пайдаланушы мен Siru әзірлеушілері арасындағы қолданба пайдалануын реттейді.',
      },
      's8_2': <String, String>{
        'ru': 'Недействительность одного пункта не отменяет остальные.',
        'en': 'Invalidity of one clause does not affect others.',
        'kk': 'Бір тармақтың жарамсыздығы қалған тармақтардың күшін жоймайды.',
      },
      's8_3': <String, String>{
        'ru': 'По вопросам использования можно обратиться в поддержку через контакты в приложении.',
        'en': 'For questions, contact support via the contacts listed in the app.',
        'kk': 'Сұрақтар бойынша қолданбадағы байланыс арналары арқылы қолдауға жүгінуге болады.',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

