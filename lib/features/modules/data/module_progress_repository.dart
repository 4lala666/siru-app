import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moduleProgressRepositoryProvider = Provider<ModuleProgressRepository>((Ref ref) {
  return ModuleProgressRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final userModuleProgressProvider = StreamProvider<Map<String, ModuleProgressRecord>>((Ref ref) {
  return ref.read(moduleProgressRepositoryProvider).watchUserModuleProgress();
});

final moduleProgressForModuleProvider = Provider.family<ModuleProgressRecord, String>((Ref ref, String moduleId) {
  final AsyncValue<Map<String, ModuleProgressRecord>> progressAsync = ref.watch(userModuleProgressProvider);
  return progressAsync.maybeWhen(
    data: (Map<String, ModuleProgressRecord> records) =>
        records[moduleId] ?? ModuleProgressRecord.empty(moduleId),
    orElse: () => ModuleProgressRecord.empty(moduleId),
  );
});

class ModuleProgressRepository {
  ModuleProgressRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Stream<Map<String, ModuleProgressRecord>> watchUserModuleProgress() {
    return _auth.authStateChanges().asyncExpand((User? user) {
      if (user == null) {
        return Stream<Map<String, ModuleProgressRecord>>.value(
          const <String, ModuleProgressRecord>{},
        );
      }

      return _firestore
          .collection('module_progress')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final Map<String, ModuleProgressRecord> records = <String, ModuleProgressRecord>{};
        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          final ModuleProgressRecord record = ModuleProgressRecord.fromDoc(doc);
          records[record.moduleId] = record;
        }
        return records;
      });
    });
  }
}

class ModuleProgressRecord {
  ModuleProgressRecord({
    required this.moduleId,
    required this.completedSubtopicIds,
    required this.completedSubtopics,
    required this.lastSubtopicId,
    required this.completionRate,
    required this.isCompleted,
    required this.totalSubtopics,
  });

  final String moduleId;
  final List<String> completedSubtopicIds;
  final int completedSubtopics;
  final String? lastSubtopicId;
  final double completionRate;
  final bool isCompleted;
  final int? totalSubtopics;

  factory ModuleProgressRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    final List<String> completedIds =
        ((data['completedSubtopicIds'] as List<dynamic>?) ?? <dynamic>[]).map((dynamic e) => '$e').toList();

    return ModuleProgressRecord(
      moduleId: (data['moduleId'] ?? '').toString(),
      completedSubtopicIds: completedIds,
      completedSubtopics: (data['completedSubtopics'] as num?)?.toInt() ?? completedIds.length,
      lastSubtopicId: _normalizeOptionalString(data['lastSubtopicId']),
      completionRate: (data['completionRate'] as num?)?.toDouble() ?? 0,
      isCompleted: data['isCompleted'] == true,
      totalSubtopics: (data['totalSubtopics'] as num?)?.toInt(),
    );
  }

  factory ModuleProgressRecord.empty(String moduleId) {
    return ModuleProgressRecord(
      moduleId: moduleId,
      completedSubtopicIds: const <String>[],
      completedSubtopics: 0,
      lastSubtopicId: null,
      completionRate: 0,
      isCompleted: false,
      totalSubtopics: null,
    );
  }

  bool get hasStarted => completedSubtopics > 0;

  bool containsLesson(String lessonId) => completedSubtopicIds.contains(lessonId);

  double progressFor({required int totalLessons}) {
    final int safeTotal = totalSubtopics ?? totalLessons;
    if (safeTotal > 0) {
      return (completedSubtopics / safeTotal).clamp(0.0, 1.0);
    }
    return completionRate.clamp(0.0, 1.0);
  }
}

String? _normalizeOptionalString(dynamic value) {
  final String normalized = (value ?? '').toString().trim();
  return normalized.isEmpty ? null : normalized;
}
