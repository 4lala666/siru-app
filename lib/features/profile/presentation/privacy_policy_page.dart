import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          _section('1. ${_t(lang, 's1')}', <String>[
            _t(lang, 's1_1'),
            _t(lang, 's1_2'),
            _t(lang, 's1_3'),
          ]),
          _section('2. ${_t(lang, 's2')}', <String>[
            _t(lang, 's2_1'),
            _t(lang, 's2_2'),
            _t(lang, 's2_3'),
            _t(lang, 's2_4'),
          ]),
          _section('3. ${_t(lang, 's3')}', <String>[
            _t(lang, 's3_1'),
            _t(lang, 's3_2'),
            _t(lang, 's3_3'),
            _t(lang, 's3_4'),
          ]),
          _section('4. ${_t(lang, 's4')}', <String>[
            _t(lang, 's4_1'),
            _t(lang, 's4_2'),
          ]),
          _section('5. ${_t(lang, 's5')}', <String>[
            _t(lang, 's5_1'),
            _t(lang, 's5_2'),
          ]),
          _section('6. ${_t(lang, 's6')}', <String>[
            _t(lang, 's6_1'),
            _t(lang, 's6_2'),
            _t(lang, 's6_3'),
          ]),
          _section('7. ${_t(lang, 's7')}', <String>[
            _t(lang, 's7_1'),
            _t(lang, 's7_2'),
            _t(lang, 's7_3'),
          ]),
          _section('8. ${_t(lang, 's8')}', <String>[
            _t(lang, 's8_1'),
            _t(lang, 's8_2'),
            _t(lang, 's8_3'),
          ]),
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
        'ru': 'Политика конфиденциальности',
        'en': 'Privacy Policy',
        'kk': 'Құпиялық саясаты',
      },
      'docTitle': <String, String>{
        'ru': 'Политика конфиденциальности приложения Siru',
        'en': 'Siru Privacy Policy',
        'kk': 'Siru қолданбасының құпиялық саясаты',
      },
      'effectiveDate': <String, String>{
        'ru': 'Дата вступления в силу: «___» __________ 20__ г.',
        'en': 'Effective date: “___” __________ 20__',
        'kk': 'Күшіне ену күні: «___» __________ 20__ ж.',
      },
      's1': <String, String>{'ru': 'Общие положения', 'en': 'General Provisions', 'kk': 'Жалпы ережелер'},
      's1_1': <String, String>{
        'ru': 'Настоящая Политика определяет, какие данные собираются и как они обрабатываются в приложении Siru.',
        'en': 'This Policy explains what data is collected and how it is processed in Siru.',
        'kk': 'Бұл Саясат Siru қолданбасында қандай деректер жиналатынын және өңделетінін түсіндіреді.',
      },
      's1_2': <String, String>{
        'ru': 'Siru — образовательное приложение по кибербезопасности.',
        'en': 'Siru is an educational cybersecurity app.',
        'kk': 'Siru — киберқауіпсіздікке арналған білім беру қолданбасы.',
      },
      's1_3': <String, String>{
        'ru': 'Используя приложение, пользователь подтверждает согласие с настоящей Политикой.',
        'en': 'By using the app, the user agrees to this Policy.',
        'kk': 'Қолданбаны пайдалану арқылы пайдаланушы осы Саясатпен келісетінін растайды.',
      },
      's2': <String, String>{'ru': 'Какие данные собираются', 'en': 'Data We Collect', 'kk': 'Қандай деректер жиналады'},
      's2_1': <String, String>{
        'ru': 'Имя пользователя (displayName).',
        'en': 'User name (displayName).',
        'kk': 'Пайдаланушы аты (displayName).',
      },
      's2_2': <String, String>{
        'ru': 'Адрес электронной почты (email).',
        'en': 'Email address.',
        'kk': 'Электрондық пошта (email).',
      },
      's2_3': <String, String>{
        'ru': 'Идентификатор аккаунта (uid).',
        'en': 'Account identifier (uid).',
        'kk': 'Аккаунт идентификаторы (uid).',
      },
      's2_4': <String, String>{
        'ru': 'Технические данные: устройство, версия приложения, сведения об ошибках.',
        'en': 'Technical data: device, app version, and error logs.',
        'kk': 'Техникалық деректер: құрылғы, қолданба нұсқасы және қате журналдары.',
      },
      's3': <String, String>{'ru': 'Цели использования данных', 'en': 'Why We Use Data', 'kk': 'Деректерді пайдалану мақсаттары'},
      's3_1': <String, String>{
        'ru': 'Регистрация и авторизация пользователя.',
        'en': 'User registration and authentication.',
        'kk': 'Пайдаланушыны тіркеу және авторизациялау.',
      },
      's3_2': <String, String>{
        'ru': 'Обеспечение функциональности приложения.',
        'en': 'To provide app functionality.',
        'kk': 'Қолданба функционалын қамтамасыз ету.',
      },
      's3_3': <String, String>{
        'ru': 'Улучшение качества сервиса.',
        'en': 'To improve service quality.',
        'kk': 'Сервис сапасын жақсарту.',
      },
      's3_4': <String, String>{
        'ru': 'Обеспечение безопасности и предотвращение нарушений.',
        'en': 'To improve security and prevent abuse.',
        'kk': 'Қауіпсіздікті арттыру және бұзушылықтардың алдын алу.',
      },
      's4': <String, String>{'ru': 'Хранение и защита данных', 'en': 'Storage and Protection', 'kk': 'Деректерді сақтау және қорғау'},
      's4_1': <String, String>{
        'ru': 'Данные могут храниться в защищенной инфраструктуре, включая Firebase.',
        'en': 'Data may be stored in protected infrastructure, including Firebase.',
        'kk': 'Деректер қорғалған инфрақұрылымда, соның ішінде Firebase-та сақталуы мүмкін.',
      },
      's4_2': <String, String>{
        'ru': 'Мы применяем разумные технические и организационные меры защиты данных.',
        'en': 'We use reasonable technical and organizational safeguards.',
        'kk': 'Біз деректерді қорғау үшін ақылға қонымды техникалық және ұйымдастырушылық шаралар қолданамыз.',
      },
      's5': <String, String>{'ru': 'Передача третьим лицам', 'en': 'Data Sharing', 'kk': 'Үшінші тұлғаларға беру'},
      's5_1': <String, String>{
        'ru': 'Данные не продаются и не передаются третьим лицам в рекламных целях.',
        'en': 'Data is not sold or shared with third parties for advertising.',
        'kk': 'Деректер сатылмайды және жарнама мақсатында үшінші тұлғаларға берілмейді.',
      },
      's5_2': <String, String>{
        'ru': 'Передача возможна только для обязательных сервисов (авторизация/хранение) или по закону.',
        'en': 'Data may be shared only with essential services or when required by law.',
        'kk': 'Деректер тек міндетті сервистерге немесе заң талап еткен жағдайда ғана берілуі мүмкін.',
      },
      's6': <String, String>{'ru': 'Права пользователя', 'en': 'User Rights', 'kk': 'Пайдаланушы құқықтары'},
      's6_1': <String, String>{
        'ru': 'Пользователь может изменить свои данные в приложении.',
        'en': 'Users can update their data in the app.',
        'kk': 'Пайдаланушы қолданбадағы деректерін өзгерте алады.',
      },
      's6_2': <String, String>{
        'ru': 'Пользователь может удалить аккаунт.',
        'en': 'Users can delete their account.',
        'kk': 'Пайдаланушы аккаунтын жоя алады.',
      },
      's6_3': <String, String>{
        'ru': 'Пользователь может запросить удаление данных через поддержку.',
        'en': 'Users can request data deletion via support.',
        'kk': 'Пайдаланушы қолдау қызметі арқылы деректерді жоюды сұрай алады.',
      },
      's7': <String, String>{'ru': 'Cookies, аналитика и логирование', 'en': 'Cookies, Analytics and Logs', 'kk': 'Cookies, аналитика және логтар'},
      's7_1': <String, String>{
        'ru': 'В мобильном приложении cookies в классическом веб-формате не используются.',
        'en': 'Classic web cookies are not used in the mobile app.',
        'kk': 'Мобильді қолданбада классикалық веб-cookies қолданылмайды.',
      },
      's7_2': <String, String>{
        'ru': 'Может использоваться техническое логирование и данные о сбоях.',
        'en': 'Technical logging and crash data may be used.',
        'kk': 'Техникалық логтар мен қате деректері қолданылуы мүмкін.',
      },
      's7_3': <String, String>{
        'ru': 'Аналитика используется только для улучшения качества и безопасности сервиса.',
        'en': 'Analytics is used only to improve service quality and security.',
        'kk': 'Аналитика тек сервис сапасы мен қауіпсіздігін жақсарту үшін қолданылады.',
      },
      's8': <String, String>{'ru': 'Изменения политики', 'en': 'Policy Updates', 'kk': 'Саясатты өзгерту'},
      's8_1': <String, String>{
        'ru': 'Разработчики могут обновлять Политику в любое время.',
        'en': 'Developers may update this Policy at any time.',
        'kk': 'Әзірлеушілер бұл Саясатты кез келген уақытта жаңарта алады.',
      },
      's8_2': <String, String>{
        'ru': 'Новая версия действует с момента публикации в приложении.',
        'en': 'The new version takes effect upon publication in the app.',
        'kk': 'Жаңа нұсқа қолданбада жарияланған сәттен бастап күшіне енеді.',
      },
      's8_3': <String, String>{
        'ru': 'Пользователь обязан самостоятельно знакомиться с обновлениями.',
        'en': 'Users are responsible for reviewing updates.',
        'kk': 'Пайдаланушы жаңартулармен өз бетінше танысуға міндетті.',
      },
    };

    return dict[key]?[lang] ?? dict[key]?['ru'] ?? key;
  }
}

