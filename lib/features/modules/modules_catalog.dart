import 'package:flutter/material.dart';

class CourseLesson {
  const CourseLesson({required this.title, required this.durationMin});

  final String title;
  final int durationMin;
}

class CourseModule {
  const CourseModule({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.goals,
    required this.benefits,
    required this.lessons,
    required this.progress,
  });

  final String title;
  final String subtitle;
  final String description;
  final String goals;
  final String benefits;
  final List<CourseLesson> lessons;
  final double progress;
}

class ModulesCatalogView extends StatelessWidget {
  const ModulesCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const SizedBox(height: 8),
        const Text(
          'Модули',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          'Выберите модуль, чтобы открыть уроки, цели и описание.',
          style: TextStyle(fontSize: 14, color: Color(0xFFC7D3EB)),
        ),
        const SizedBox(height: 14),
        for (int i = 0; i < kCourseModules.length; i++) ...<Widget>[
          _ModuleListCard(module: kCourseModules[i], index: i + 1),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ModuleListCard extends StatelessWidget {
  const _ModuleListCard({required this.module, required this.index});

  final CourseModule module;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0A2D6F),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ModuleDetailsScreen(module: module),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D3EAD),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text('$index',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(module.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(module.subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFFC7D3EB))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleDetailsScreen extends StatefulWidget {
  const ModuleDetailsScreen({super.key, required this.module});

  final CourseModule module;

  @override
  State<ModuleDetailsScreen> createState() => _ModuleDetailsScreenState();
}

class _ModuleDetailsScreenState extends State<ModuleDetailsScreen> {
  bool _showIndex = true;

  @override
  Widget build(BuildContext context) {
    final CourseModule module = widget.module;

    return Scaffold(
      backgroundColor: const Color(0xFF071A3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2546),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(module.title, style: const TextStyle(fontSize: 20)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CircularProgressIndicator(
                      value: module.progress,
                      strokeWidth: 6,
                      backgroundColor: const Color(0xFF2B3E68),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF00C15A)),
                    ),
                    Center(
                      child: Text(
                        '${(module.progress * 100).round()}%',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: const Color(0xFF1A2546),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              children: <Widget>[
                _HeaderTab(
                  text: 'Индекс',
                  selected: _showIndex,
                  onTap: () => setState(() => _showIndex = true),
                ),
                const SizedBox(width: 20),
                _HeaderTab(
                  text: 'Описание',
                  selected: !_showIndex,
                  onTap: () => setState(() => _showIndex = false),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF0EEF2),
              child: _showIndex
                  ? _IndexTab(module: module)
                  : _DescriptionTab(module: module),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTab extends StatelessWidget {
  const _HeaderTab({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? const Color(0xFF00C15A) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF00C15A) : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _IndexTab extends StatelessWidget {
  const _IndexTab({required this.module});

  final CourseModule module;

  static const List<Color> _palette = <Color>[
    Color(0xFF4B89FF),
    Color(0xFFEF5454),
    Color(0xFFA88EF2),
    Color(0xFFE6CD7A),
    Color(0xFF78D7AA),
    Color(0xFFBD8CD5),
    Color(0xFF79C7FF),
    Color(0xFF8AC7A2),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: module.lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final CourseLesson lesson = module.lessons[index];
        final Color color = _palette[index % _palette.length];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 10,
                  offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${index + 1}. ${lesson.title}',
                      style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.access_time_rounded,
                            color: Colors.white70, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '${lesson.durationMin} мин',
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.description_outlined, color: Colors.white),
            ],
          ),
        );
      },
    );
  }
}

class _DescriptionTab extends StatelessWidget {
  const _DescriptionTab({required this.module});

  final CourseModule module;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'О модуле',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF071A3D)),
        ),
        const SizedBox(height: 8),
        Text(
          module.description,
          style: const TextStyle(
              fontSize: 16, color: Color(0xFF1A2546), height: 1.4),
        ),
        const SizedBox(height: 16),
        const Text(
          'Цель',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF071A3D)),
        ),
        const SizedBox(height: 8),
        Text(
          module.goals,
          style: const TextStyle(
              fontSize: 16, color: Color(0xFF1A2546), height: 1.4),
        ),
        const SizedBox(height: 16),
        const Text(
          'Практическая польза',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF071A3D)),
        ),
        const SizedBox(height: 8),
        Text(
          module.benefits,
          style: const TextStyle(
              fontSize: 16, color: Color(0xFF1A2546), height: 1.4),
        ),
      ],
    );
  }
}

const List<CourseModule> kCourseModules = <CourseModule>[
  CourseModule(
    title: 'Основы, управление и риск',
    subtitle: 'Governance & Risk • 8 уроков',
    progress: 0.13,
    description:
        'Базовый модуль о том, как устроена информационная безопасность в организации: от целей до практик управления рисками.',
    goals:
        'Научиться отличать угрозы, уязвимости и риски, понимать принципы CIA и выбирать подход к управлению рисками.',
    benefits:
        'После модуля вы сможете уверенно читать политики ИБ и участвовать в оценке рисков.',
    lessons: <CourseLesson>[
      CourseLesson(title: 'Что такое ИБ: цели, принципы и роль в мире', durationMin: 8),
      CourseLesson(title: 'CIA-триада и базовые свойства безопасности', durationMin: 8),
      CourseLesson(title: 'Угрозы, уязвимости и риски: как отличать', durationMin: 9),
      CourseLesson(title: 'Risk Management: идентификация и оценка риска', durationMin: 10),
      CourseLesson(title: 'Обработка рисков: mitigation, transfer, accept', durationMin: 9),
      CourseLesson(title: 'Политики ИБ: зачем нужны и как выглядят', durationMin: 7),
      CourseLesson(title: 'ISO 27001 / NIST / CIS: что выбрать и почему', durationMin: 10),
      CourseLesson(title: 'Комплаенс и ответственность: GDPR, PCI DSS, 152-ФЗ', durationMin: 10),
    ],
  ),
  CourseModule(
    title: 'Социальная инженерия и человеческий фактор',
    subtitle: 'Human Factor • 8 уроков',
    progress: 0.07,
    description:
        'Модуль посвящен атакам на людей: фишинг, вишинг, смишинг и другие схемы, обходящие технические меры защиты.',
    goals:
        'Понять психологию атак и научиться распознавать обман в почте, звонках, мессенджерах и соцсетях.',
    benefits:
        'Вы начнете быстрее определять опасные сообщения и применять личный чеклист защиты.',
    lessons: <CourseLesson>[
      CourseLesson(title: 'Почему люди — главная цель атак', durationMin: 7),
      CourseLesson(title: 'Фишинг: письма, сайты-клоны, “поддержка банка”', durationMin: 9),
      CourseLesson(title: 'Вишинг и смишинг: звонки и SMS-мошенничество', durationMin: 8),
      CourseLesson(title: 'Соцсети и мессенджеры: популярные схемы', durationMin: 8),
      CourseLesson(title: 'CEO fraud и атаки на сотрудников компании', durationMin: 8),
      CourseLesson(title: 'Психология атак: страх, срочность, доверие', durationMin: 9),
      CourseLesson(title: 'Как защищаться: правила + привычки + чеклист', durationMin: 8),
      CourseLesson(title: 'Security Awareness: обучение и симуляции', durationMin: 8),
    ],
  ),
  CourseModule(
    title: 'Сети и инфраструктура',
    subtitle: 'Network Security • 8 уроков',
    progress: 0.0,
    description:
        'Практичное введение в сетевую безопасность: как устроен трафик и какие механизмы защищают инфраструктуру.',
    goals:
        'Разобраться в базовых сетевых угрозах, работе firewall/IDS/IPS и принципах Zero Trust.',
    benefits:
        'Сможете уверенно обсуждать сетевые инциденты и выбирать базовые защитные меры.',
    lessons: <CourseLesson>[
      CourseLesson(title: 'Как работает интернет: IP, DNS, порты', durationMin: 8),
      CourseLesson(title: 'Сетевые угрозы: MITM, sniffing, spoofing', durationMin: 9),
      CourseLesson(title: 'Firewall: принципы и типы правил', durationMin: 8),
      CourseLesson(title: 'IDS/IPS: обнаружение и предотвращение атак', durationMin: 8),
      CourseLesson(title: 'VPN: зачем нужен и от чего не спасает', durationMin: 7),
      CourseLesson(title: 'TLS/SSL и HTTPS: что реально шифруется', durationMin: 8),
      CourseLesson(title: 'Сегментация сети: VLAN, DMZ, изоляция', durationMin: 8),
      CourseLesson(title: 'Zero Trust: “никому не доверяй”', durationMin: 9),
    ],
  ),
];
