class ModuleItem {
  const ModuleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.status,
    required this.lessons,
    required this.minutes,
    required this.xp,
    required this.progress,
  });

  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String status;
  final int lessons;
  final int minutes;
  final int xp;
  final double progress;
}

const List<ModuleItem> mockModules = <ModuleItem>[
  ModuleItem(
    id: 'm1',
    title: 'Governance & Risk',
    description: 'Principles, risk evaluation, and controls for secure organizations.',
    difficulty: 'Beginner',
    status: 'In Progress',
    lessons: 8,
    minutes: 64,
    xp: 240,
    progress: 0.45,
  ),
  ModuleItem(
    id: 'm2',
    title: 'Social Engineering',
    description: 'Recognize phishing, vishing, and psychological attack patterns.',
    difficulty: 'Beginner',
    status: 'Completed',
    lessons: 8,
    minutes: 58,
    xp: 300,
    progress: 1,
  ),
  ModuleItem(
    id: 'm3',
    title: 'Cloud Security',
    description: 'Shared responsibility, IAM, and cloud misconfiguration risks.',
    difficulty: 'Intermediate',
    status: 'Locked',
    lessons: 8,
    minutes: 70,
    xp: 320,
    progress: 0,
  ),
];

