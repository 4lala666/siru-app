class DescriptionSection {
  const DescriptionSection({
    required this.title,
    required this.bullets,
  });

  final Map<String, String> title;
  final Map<String, List<String>> bullets;

  factory DescriptionSection.fromJson(Map<String, dynamic> json) {
    return DescriptionSection(
      title: _stringMap(json['title']),
      bullets: _stringListMap(json['bullets']),
    );
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.durationMin,
    required this.stepsCount,
    required this.title,
  });

  final String id;
  final int durationMin;
  final int stepsCount;
  final Map<String, String> title;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: (json['id'] ?? '').toString(),
      durationMin: _asInt(json['durationMin']),
      stepsCount: _asInt(json['stepsCount']),
      title: _stringMap(json['title']),
    );
  }
}

class Module {
  const Module({
    required this.id,
    required this.difficulty,
    required this.icon,
    required this.cover,
    required this.title,
    required this.subtitle,
    required this.descriptionSections,
    required this.lessons,
  });

  final String id;
  final String difficulty;
  final String icon;
  final String cover;
  final Map<String, String> title;
  final Map<String, String> subtitle;
  final List<DescriptionSection> descriptionSections;
  final List<Lesson> lessons;

  factory Module.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawSections = (json['descriptionSections'] as List<dynamic>?) ?? <dynamic>[];
    final List<dynamic> rawLessons = (json['lessons'] as List<dynamic>?) ?? <dynamic>[];

    return Module(
      id: (json['id'] ?? '').toString(),
      difficulty: (json['difficulty'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString(),
      cover: (json['cover'] ?? '').toString(),
      title: _stringMap(json['title']),
      subtitle: _stringMap(json['subtitle']),
      descriptionSections: rawSections
          .whereType<Map<String, dynamic>>()
          .map(DescriptionSection.fromJson)
          .toList(),
      lessons: rawLessons
          .whereType<Map<String, dynamic>>()
          .map(Lesson.fromJson)
          .toList(),
    );
  }
}

String tr(Map<String, String> localizedMap, String lang) {
  return localizedMap[lang] ?? localizedMap['ru'] ?? '';
}

Map<String, String> _stringMap(dynamic raw) {
  if (raw is! Map) return <String, String>{};
  final Map<String, String> out = <String, String>{};
  raw.forEach((dynamic k, dynamic v) {
    out[k.toString()] = (v ?? '').toString();
  });
  return out;
}

Map<String, List<String>> _stringListMap(dynamic raw) {
  if (raw is! Map) return <String, List<String>>{};
  final Map<String, List<String>> out = <String, List<String>>{};
  raw.forEach((dynamic k, dynamic v) {
    final List<String> list = (v is List)
        ? v.map((dynamic e) => e.toString()).toList()
        : <String>[];
    out[k.toString()] = list;
  });
  return out;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse((value ?? '').toString()) ?? 0;
}
