import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/lesson_content.dart';

class LessonDefinitionCard extends StatelessWidget {
  const LessonDefinitionCard({super.key, required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return LessonSectionCard(
      title: section.title,
      icon: Icons.menu_book_rounded,
      accent: const Color(0xFF5AC8FA),
      child: Text(section.body ?? '', style: AppTextStyles.body.copyWith(height: 1.45)),
    );
  }
}

class LessonImportanceCard extends StatelessWidget {
  const LessonImportanceCard({super.key, required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return LessonSectionCard(
      title: section.title,
      icon: Icons.priority_high_rounded,
      accent: const Color(0xFF41D38A),
      child: Text(section.body ?? '', style: AppTextStyles.body.copyWith(height: 1.45)),
    );
  }
}

class LessonExampleCard extends StatelessWidget {
  const LessonExampleCard({super.key, required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    final List<String> items = section.items.isNotEmpty
        ? section.items
        : <String>[if ((section.body ?? '').isNotEmpty) section.body!];
    return LessonSectionCard(
      title: section.title,
      icon: Icons.lightbulb_outline_rounded,
      accent: const Color(0xFF7FC8FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((String item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(item, style: AppTextStyles.body.copyWith(height: 1.45)),
                ))
            .toList(),
      ),
    );
  }
}

class LessonWarningCard extends StatelessWidget {
  const LessonWarningCard({super.key, required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return LessonSectionCard(
      title: section.title,
      icon: Icons.warning_amber_rounded,
      accent: const Color(0xFFFF7D7D),
      background: const Color(0x26FF7D7D),
      child: Text(section.body ?? '', style: AppTextStyles.body.copyWith(height: 1.45)),
    );
  }
}

class LessonChecklistCard extends StatelessWidget {
  const LessonChecklistCard({super.key, required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return LessonSectionCard(
      title: section.title,
      icon: Icons.check_circle_outline_rounded,
      accent: const Color(0xFF41D38A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: section.items
            .map(
              (String item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.check, size: 18, color: Color(0xFF41D38A)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item, style: AppTextStyles.body.copyWith(height: 1.4)),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class LessonComparisonCard extends StatelessWidget {
  const LessonComparisonCard({super.key, required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return LessonSectionCard(
      title: section.title,
      icon: Icons.compare_arrows_rounded,
      accent: const Color(0xFFB49BFF),
      child: Column(
        children: section.items
            .map(
              (String item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.circle, size: 8, color: AppColors.accent),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item, style: AppTextStyles.body)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class LessonRememberCard extends StatelessWidget {
  const LessonRememberCard({super.key, required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return LessonSectionCard(
      title: section.title,
      icon: Icons.push_pin_outlined,
      accent: AppColors.accent,
      background: AppColors.accent.withValues(alpha: 0.12),
      child: Text(
        (section.body ?? section.items.join('\n')).trim(),
        style: AppTextStyles.body.copyWith(height: 1.45),
      ),
    );
  }
}

class LessonSelfCheckCard extends StatefulWidget {
  const LessonSelfCheckCard({super.key, required this.section});
  final LessonSection section;

  @override
  State<LessonSelfCheckCard> createState() => _LessonSelfCheckCardState();
}

class _LessonSelfCheckCardState extends State<LessonSelfCheckCard> {
  int? selectedIndex;
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    final String lang = Localizations.localeOf(context).languageCode;
    return LessonSectionCard(
      title: widget.section.title,
      icon: Icons.quiz_outlined,
      accent: const Color(0xFF5AC8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if ((widget.section.question ?? '').isNotEmpty)
            Text(widget.section.question!, style: AppTextStyles.body.copyWith(height: 1.4)),
          const SizedBox(height: 12),
          ...List<Widget>.generate(widget.section.options.length, (int index) {
            final bool isCorrect = widget.section.correctIndex == index;
            final bool isSelected = selectedIndex == index;
            final Color bg = !revealed
                ? isSelected
                    ? AppColors.primaryButton
                    : Colors.white.withValues(alpha: 0.05)
                : isCorrect
                    ? Colors.green.withValues(alpha: 0.2)
                    : isSelected
                        ? Colors.red.withValues(alpha: 0.18)
                        : Colors.white.withValues(alpha: 0.05);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: revealed
                    ? null
                    : () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(widget.section.options[index], style: AppTextStyles.body)),
                      if (revealed && isCorrect)
                        const Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (!revealed)
            ElevatedButton(
              onPressed: selectedIndex == null
                  ? null
                  : () {
                      setState(() {
                        revealed = true;
                      });
                    },
              child: Text(_checkLabel(lang)),
            ),
          if (revealed) ...<Widget>[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    selectedIndex == widget.section.correctIndex ? _correctLabel(lang) : _almostLabel(lang),
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 8),
                  Text(widget.section.explanation ?? '', style: AppTextStyles.body),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _checkLabel(String lang) {
    switch (lang) {
      case 'en':
        return 'Check answer';
      case 'kk':
        return 'Жауапты тексеру';
      case 'ru':
      default:
        return 'Проверить';
    }
  }

  String _correctLabel(String lang) {
    switch (lang) {
      case 'en':
        return 'Correct';
      case 'kk':
        return 'Дұрыс';
      case 'ru':
      default:
        return 'Верно';
    }
  }

  String _almostLabel(String lang) {
    switch (lang) {
      case 'en':
        return 'Not quite';
      case 'kk':
        return 'Сәл қате';
      case 'ru':
      default:
        return 'Почти';
    }
  }
}

class LessonSectionCard extends StatelessWidget {
  const LessonSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
    this.background,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTextStyles.cardTitle)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
