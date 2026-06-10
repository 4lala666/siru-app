class LessonContent {
  const LessonContent({
    required this.id,
    required this.moduleId,
    required this.topicId,
    required this.title,
    required this.moduleTitle,
    required this.subtitle,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.totalSteps,
    required this.heroIcon,
    required this.status,
    required this.sections,
    required this.quizId,
    required this.sources,
    required this.hasRealContent,
  });

  final String id;
  final String moduleId;
  final String topicId;
  final String title;
  final String moduleTitle;
  final String subtitle;
  final int estimatedMinutes;
  final String difficulty;
  final int totalSteps;
  final String heroIcon;
  final LessonTopicStatus status;
  final List<LessonSection> sections;
  final String? quizId;
  final List<LessonContentSource> sources;
  final bool hasRealContent;
}

class LessonSection {
  const LessonSection({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    this.icon,
    this.items = const <String>[],
    this.question,
    this.options = const <String>[],
    this.correctIndex,
    this.explanation,
  });

  final String id;
  final LessonSectionType type;
  final String title;
  final String? body;
  final String? icon;
  final List<String> items;
  final String? question;
  final List<String> options;
  final int? correctIndex;
  final String? explanation;
}

class LessonContentSource {
  const LessonContentSource({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;
}

enum LessonSectionType {
  definition,
  importance,
  example,
  warning,
  checklist,
  comparison,
  remember,
  selfCheck,
  sources,
}

enum LessonTopicStatus {
  notStarted,
  inProgress,
  completed,
  locked,
}

