import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: const <Widget>[
        _StreakCard(days: 4),
        SizedBox(height: 14),
        _NewsCard(),
        SizedBox(height: 14),
        _TasksCard(),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2D6F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Серия дней',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('$days дня подряд',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text(
            'Серия увеличивается, если в течение дня выполнено хотя бы 1 задание.',
            style: TextStyle(color: Color(0xFFC7D3EB)),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2D6F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Новости и события',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          _NewsItem(
            title: 'Новый мини-урок: Как распознать фишинговый сайт',
            date: 'Сегодня',
          ),
          SizedBox(height: 8),
          _NewsItem(
            title: 'Чеклист безопасного пароля обновлен',
            date: 'Вчера',
          ),
        ],
      ),
    );
  }
}

class _NewsItem extends StatelessWidget {
  const _NewsItem({required this.title, required this.date});

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF123A82),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.article_outlined, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
          const SizedBox(width: 8),
          Text(date, style: const TextStyle(color: Color(0xFFC7D3EB))),
        ],
      ),
    );
  }
}

class _TasksCard extends StatelessWidget {
  const _TasksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2D6F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Задания дня и месяца',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          _TaskTile(
            title: 'Задание дня: пройти 1 тест по фишингу',
            progress: '0/1',
          ),
          SizedBox(height: 8),
          _TaskTile(
            title: 'Задание месяца: завершить 8 уроков',
            progress: '2/8',
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.title, required this.progress});

  final String title;
  final String progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF123A82),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.task_alt, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
          const SizedBox(width: 8),
          Text(progress, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
