import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/siru_button.dart';
import '../../core/widgets/siru_layout.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int _step = 0;
  final Map<int, int> _answers = <int, int>{};

  @override
  Widget build(BuildContext context) {
    final _SurveyContent s = _contentFor(Localizations.localeOf(context).languageCode);

    return SiruLayout(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: switch (_step) {
          0 => _IntroPage(
              key: const ValueKey<String>('intro-1'),
              text: s.introMentor,
              imagePath: 'assets/images/intro_mentor.png',
              buttonText: s.continueText,
              onPressed: _next,
            ),
          1 => _IntroPage(
              key: const ValueKey<String>('intro-2'),
              text: s.introStart,
              imagePath: 'assets/images/koneko.png',
              buttonText: s.startText,
              onPressed: _next,
            ),
          7 => _FinishPage(
             key: const ValueKey<String>('finish'),
             text: s.surveyFinish,
             buttonText: s.goText,
             onPressed: () => _finishAndGoAuth(context),
          ),
          _ => _QuestionPage(
              key: ValueKey<String>('question-$_step'),
              question: s.questions[_step - 2],
              progressCurrent: _step - 1,
              selectedIndex: _answers[_step - 2],
              skipText: s.skipText,
              onOptionTap: (int index) {
                setState(() => _answers[_step - 2] = index);
                _next();
              },
              onSkip: _next,
            ),
        },
      ),
    );
  }

  void _next() {
  if (_step < 7) {
    setState(() => _step++);
  }
}

Future<void> _finishAndGoAuth(BuildContext context) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setBool('onboarding_done', true);

  if (!mounted) return;
  context.go('/auth');
}
}

class _SurveyQuestion {
  const _SurveyQuestion({required this.question, required this.options});

  final String question;
  final List<String> options;
}

class _SurveyContent {
  const _SurveyContent({
    required this.introMentor,
    required this.introStart,
    required this.continueText,
    required this.startText,
    required this.skipText,
    required this.goText,
    required this.surveyFinish,
    required this.questions,
  });

  final String introMentor;
  final String introStart;
  final String continueText;
  final String startText;
  final String skipText;
  final String goText;
  final String surveyFinish;
  final List<_SurveyQuestion> questions;
}

_SurveyContent _contentFor(String code) {
  if (code == 'en') {
    return const _SurveyContent(
      introMentor:
          'Meow! I am Koneko, your digital mentor. The internet has many traps, but I will teach you how to avoid them.',
      introStart:
          'Let us get to know each other better. Answer a few questions to estimate your current level.',
      continueText: 'Continue',
      startText: 'Start',
      skipText: 'Skip',
      goText: 'Let\'s go!',
      surveyFinish:
          'All set. We prepared a path that many users completed successfully.',
      questions: <_SurveyQuestion>[
        _SurveyQuestion(
          question: 'What brought you to SIRU today?',
          options: <String>[
            'Learn something new',
            'Find inspiration',
            'Self development',
            'Curiosity',
          ],
        ),
        _SurveyQuestion(
          question: 'Are you familiar with cybersecurity?',
          options: <String>[
            'Complete beginner',
            'Heard something',
            'Basic knowledge',
            'Need a restart',
          ],
        ),
        _SurveyQuestion(
          question: 'When do you usually learn?',
          options: <String>[
            'Morning',
            'Lunch break',
            'Evening',
            'Any time',
          ],
        ),
        _SurveyQuestion(
          question: 'How much time per day can you spend?',
          options: <String>[
            '5 minutes',
            '15-20 minutes',
            'Depends on mood',
            'A lot',
          ],
        ),
        _SurveyQuestion(
          question: 'What is the most important for you?',
          options: <String>[
            'Simple explanations',
            'Practical value',
            'Aesthetics and order',
            'No preference',
          ],
        ),
      ],
    );
  }

  if (code == 'kk') {
    return const _SurveyContent(
      introMentor:
          'Мяу! Мен Koneko - сенің цифрлық тәлімгерің. Интернетте көп тұзақ бар, мен оларды айналып өтуді үйретемін.',
      introStart:
          'Жақынырақ танысайық. Бірнеше сұраққа жауап бер, деңгейіңді анықтаймыз.',
      continueText: 'Жалғастыру',
      startText: 'Бастау',
      skipText: 'Өткізу',
      goText: 'Алға!',
      surveyFinish:
          'Бәрі дайын. Біз сізге тиімді оқу жолын дайындадық.',
      questions: <_SurveyQuestion>[
        _SurveyQuestion(
          question: 'SIRU-ға бүгін не үшін келдіңіз?',
          options: <String>[
            'Жаңа нәрсе үйрену',
            'Шабыт іздеу',
            'Өзін-өзі дамыту',
            'Қызығушылық',
          ],
        ),
        _SurveyQuestion(
          question: 'Киберқауіпсіздікпен таныссыз ба?',
          options: <String>[
            'Жаңадан бастаймын',
            'Сәл естігенмін',
            'Негізгі білімім бар',
            'Қайталап өткім келеді',
          ],
        ),
        _SurveyQuestion(
          question: 'Қай уақытта оқыған ыңғайлы?',
          options: <String>[
            'Таңертең',
            'Түскі үзілісте',
            'Кешке',
            'Кез келген уақытта',
          ],
        ),
        _SurveyQuestion(
          question: 'Күніне қанша уақыт бөле аласыз?',
          options: <String>[
            '5 минут',
            '15-20 минут',
            'Көңіл-күйге байланысты',
            'Көбірек',
          ],
        ),
        _SurveyQuestion(
          question: 'Сіз үшін ең маңыздысы не?',
          options: <String>[
            'Қарапайым түсіндіру',
            'Практикалық пайда',
            'Реттілік пен стиль',
            'Айырмасы жоқ',
          ],
        ),
      ],
    );
  }

  return const _SurveyContent(
    introMentor:
        'Мяу! Я Koneko - твой цифровой наставник. В интернете много ловушек, но я научу тебя обходить их стороной.',
    introStart:
        'Давай познакомимся ближе. Ответь на пару вопросов, чтобы определить твой текущий уровень.',
    continueText: 'Продолжить',
    startText: 'Начать',
    skipText: 'Пропустить',
    goText: 'В путь!',
    surveyFinish:
        'Все готово. Мы подготовили для вас путь, который прошли тысячи пользователей.',
    questions: <_SurveyQuestion>[
      _SurveyQuestion(
        question: 'Что привело вас в SIRU сегодня?',
        options: <String>[
          'Желание узнать что-то новое',
          'Поиск вдохновения',
          'Стремление к саморазвитию',
          'Простое любопытство',
        ],
      ),
      _SurveyQuestion(
        question: 'Знакомы ли вы с кибербезопасностью?',
        options: <String>[
          'Я абсолютный новичок',
          'Кое-что слышал(а)',
          'Есть базовые знания',
          'Хочу пройти с нуля',
        ],
      ),
      _SurveyQuestion(
        question: 'Какое время дня вы обычно выделяете?',
        options: <String>[
          'Утро',
          'Обеденный перерыв',
          'Вечер',
          'Любое время',
        ],
      ),
      _SurveyQuestion(
        question: 'Сколько времени готовы уделять в день?',
        options: <String>[
          '5 минут',
          '15-20 минут',
          'По настроению',
          'Больше',
        ],
      ),
      _SurveyQuestion(
        question: 'Что для вас важнее всего в обучении?',
        options: <String>[
          'Простота изложения',
          'Практическая польза',
          'Эстетика и порядок',
          'Без разницы',
        ],
      ),
    ],
  );
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    super.key,
    required this.text,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
  });

  final String text;
  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 80),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 26),
        Expanded(
          child: Center(
            child: Image.asset(
              imagePath,
              width: 290,
              height: 290,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.pets, size: 120, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: Align(
            alignment: Alignment.center,
            child: SiruButton(text: buttonText, onPressed: onPressed),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

class _QuestionPage extends StatelessWidget {
  const _QuestionPage({
    super.key,
    required this.question,
    required this.progressCurrent,
    required this.selectedIndex,
    required this.skipText,
    required this.onOptionTap,
    required this.onSkip,
  });

  final _SurveyQuestion question;
  final int progressCurrent;
  final int? selectedIndex;
  final String skipText;
  final ValueChanged<int> onOptionTap;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 40),
        _Progress(current: progressCurrent),
        const SizedBox(height: 42),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.questionBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            question.question,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        const Spacer(),
        for (int i = 0; i < question.options.length; i++) ...<Widget>[
          _Option(
            text: question.options[i],
            selected: selectedIndex == i,
            onTap: () => onOptionTap(i),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 180,
            child: SiruButton(text: skipText, onPressed: onSkip),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _FinishPage extends StatelessWidget {
  const _FinishPage({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  });

  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 40),
        const _Progress(current: 6),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.questionBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 17),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 160,
          child: Align(
            alignment: Alignment.center,
            child: SiruButton(text: buttonText, onPressed: onPressed),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        6,
        (int index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 5 ? 0 : 8),
            height: 10,
            decoration: BoxDecoration(
              color: index < current
                  ? const Color(0xFF47B1FF)
                  : const Color(0xFFC7D3EB),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF1D3EAD) : const Color(0xFF0A2D6F),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 60,
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
