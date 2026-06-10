import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardsServiceProvider = Provider<RewardsService>((Ref ref) {
  return RewardsService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final userRewardsProvider = StreamProvider<UserRewards>((Ref ref) {
  return ref.read(rewardsServiceProvider).watchUserRewards();
});

class UserRewards {
  const UserRewards({
    required this.totalXp,
    required this.level,
    required this.badges,
    required this.badgeCount,
    required this.earnedXpSubtopicIds,
    required this.completedQuizzes,
    required this.averageScore,
    required this.currentStreak,
    required this.maxStreak,
    this.createdAt,
    this.updatedAt,
  });

  final int totalXp;
  final int level;
  final List<String> badges;
  final int badgeCount;
  final List<String> earnedXpSubtopicIds;
  final int completedQuizzes;
  final double averageScore;
  final int currentStreak;
  final int maxStreak;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  double get progressToNextLevel => (totalXp % 1000) / 1000;

  factory UserRewards.empty() {
    return const UserRewards(
      totalXp: 0,
      level: 1,
      badges: <String>[],
      badgeCount: 0,
      earnedXpSubtopicIds: <String>[],
      completedQuizzes: 0,
      averageScore: 0,
      currentStreak: 0,
      maxStreak: 0,
    );
  }

  factory UserRewards.fromFirestore(Map<String, dynamic>? data) {
    final Map<String, dynamic> source = data ?? <String, dynamic>{};
    final List<String> badges = ((source['badges'] as List<dynamic>?) ?? <dynamic>[])
        .map((dynamic e) => '$e')
        .where((String e) => e.trim().isNotEmpty)
        .toList();
    final List<String> earned = ((source['earnedXpSubtopicIds'] as List<dynamic>?) ?? <dynamic>[])
        .map((dynamic e) => '$e')
        .where((String e) => e.trim().isNotEmpty)
        .toList();
    final int totalXp = (source['totalXp'] as num?)?.toInt() ?? 0;
    final int level = (source['level'] as num?)?.toInt() ?? RewardsService.calculateLevel(totalXp);

    return UserRewards(
      totalXp: totalXp,
      level: level,
      badges: badges,
      badgeCount: (source['badgeCount'] as num?)?.toInt() ?? badges.length,
      earnedXpSubtopicIds: earned,
      completedQuizzes: (source['completedQuizzes'] as num?)?.toInt() ?? 0,
      averageScore: (source['averageScore'] as num?)?.toDouble() ?? 0,
      currentStreak: (source['currentStreak'] as num?)?.toInt() ?? 0,
      maxStreak: (source['maxStreak'] as num?)?.toInt() ?? 0,
      createdAt: _asDateTime(source['createdAt']),
      updatedAt: _asDateTime(source['updatedAt']),
    );
  }

  static DateTime? _asDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return null;
  }
}

class RewardsAwardResult {
  const RewardsAwardResult({
    required this.xpAwarded,
    required this.xpAlreadyEarned,
    required this.totalXp,
    required this.level,
    required this.badges,
  });

  final bool xpAwarded;
  final bool xpAlreadyEarned;
  final int totalXp;
  final int level;
  final List<String> badges;
}

class RewardsService {
  RewardsService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static Future<Map<String, int>>? _moduleLessonCountsFuture;

  static int calculateLevel(int totalXp) => (totalXp ~/ 1000) + 1;

  Stream<UserRewards> watchUserRewards() {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Stream<UserRewards>.value(UserRewards.empty());
    }

    return _firestore.collection('users').doc(user.uid).snapshots().map(
          (DocumentSnapshot<Map<String, dynamic>> snap) => UserRewards.fromFirestore(snap.data()),
        );
  }

  Future<UserRewards> getUserRewards() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return UserRewards.empty();
    }

    final DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection('users').doc(user.uid).get();
    return UserRewards.fromFirestore(snap.data());
  }

  Future<RewardsAwardResult?> awardSubtopicXp({
    required String moduleId,
    required String subtopicId,
    required double score,
    required int correctAnswers,
    required int totalQuestions,
    required DateTime completedAt,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      debugPrint('[rewards] skipped: user is null');
      return null;
    }

    final String rewardKey = '${moduleId}_$subtopicId';
    final Map<String, int> moduleLessonCounts = await _loadModuleLessonCounts();
    final DocumentReference<Map<String, dynamic>> userRef = _firestore.collection('users').doc(user.uid);

    RewardsAwardResult? result;

    try {
      await _firestore.runTransaction((Transaction tx) async {
        final DocumentSnapshot<Map<String, dynamic>> snap = await tx.get(userRef);
        final Map<String, dynamic> oldData = snap.data() ?? <String, dynamic>{};

        int totalXp = (oldData['totalXp'] as num?)?.toInt() ?? 0;
        final Set<String> earnedXpSubtopicIds =
            ((oldData['earnedXpSubtopicIds'] as List<dynamic>?) ?? <dynamic>[])
                .map((dynamic e) => '$e')
                .where((String e) => e.trim().isNotEmpty)
                .toSet();
        final Set<String> badges = ((oldData['badges'] as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic e) => '$e')
            .where((String e) => e.trim().isNotEmpty)
            .toSet();

        final int completedQuizzes = (oldData['completedQuizzes'] as num?)?.toInt() ?? 0;

        bool xpAwarded = false;
        bool xpAlreadyEarned = false;
        if (score >= 0.7) {
          if (earnedXpSubtopicIds.contains(rewardKey)) {
            xpAlreadyEarned = true;
          } else {
            earnedXpSubtopicIds.add(rewardKey);
            totalXp += 200;
            xpAwarded = true;
          }
        }

        final Set<String> evaluatedBadges = evaluateBadges(
          existingBadges: badges,
          totalXp: totalXp,
          completedQuizzes: completedQuizzes,
          earnedXpSubtopicIds: earnedXpSubtopicIds,
          moduleLessonCounts: moduleLessonCounts,
          perfectQuiz: totalQuestions > 0 && correctAnswers == totalQuestions,
          currentStreak: (oldData['currentStreak'] as num?)?.toInt() ?? 0,
        );

        final int level = calculateLevel(totalXp);
        final Map<String, dynamic> payload = <String, dynamic>{
          'totalXp': totalXp,
          'earnedXpSubtopicIds': earnedXpSubtopicIds.toList()..sort(),
          'level': level,
          'badges': evaluatedBadges.toList()..sort(),
          'badgeCount': evaluatedBadges.length,
          'updatedAt': FieldValue.serverTimestamp(),
          'lastRewardedAt': Timestamp.fromDate(completedAt),
        };

        debugPrint(
          '[rewards] write user=${user.uid} key=$rewardKey score=$score '
          'xpAwarded=$xpAwarded xpAlreadyEarned=$xpAlreadyEarned totalXp=$totalXp level=$level badges=${evaluatedBadges.length}',
        );

        tx.set(userRef, payload, SetOptions(merge: true));

        result = RewardsAwardResult(
          xpAwarded: xpAwarded,
          xpAlreadyEarned: xpAlreadyEarned,
          totalXp: totalXp,
          level: level,
          badges: evaluatedBadges.toList()..sort(),
        );
      });
    } catch (e, st) {
      debugPrint('[rewards] failed to award XP/badges: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }

    return result;
  }

  Set<String> evaluateBadges({
    required Set<String> existingBadges,
    required int totalXp,
    required int completedQuizzes,
    required Set<String> earnedXpSubtopicIds,
    required Map<String, int> moduleLessonCounts,
    required bool perfectQuiz,
    required int currentStreak,
  }) {
    final Set<String> badges = <String>{...existingBadges};

    if (completedQuizzes >= 1) {
      badges.add('first_test_completed');
    }
    if (earnedXpSubtopicIds.isNotEmpty) {
      badges.add('first_subtopic_completed');
    }
    if (totalXp >= 1000) {
      badges.add('xp_1000');
    }
    if (totalXp >= 3000) {
      badges.add('xp_3000');
    }
    if (perfectQuiz) {
      badges.add('no_mistake_quiz');
    }
    if (_hasCompletedWholeModule(earnedXpSubtopicIds, moduleLessonCounts)) {
      badges.add('module_master');
    }

    if (currentStreak >= 3) {
      badges.add('streak_3');
    }
    if (currentStreak >= 7) {
      badges.add('streak_7');
    }

    return badges;
  }

  bool _hasCompletedWholeModule(Set<String> earnedXpSubtopicIds, Map<String, int> moduleLessonCounts) {
    for (final MapEntry<String, int> entry in moduleLessonCounts.entries) {
      final int earnedCount =
          earnedXpSubtopicIds.where((String id) => id.startsWith('${entry.key}_')).length;
      if (entry.value > 0 && earnedCount >= entry.value) {
        return true;
      }
    }
    return false;
  }

  Future<Map<String, int>> _loadModuleLessonCounts() {
    _moduleLessonCountsFuture ??= _readModuleLessonCounts();
    return _moduleLessonCountsFuture!;
  }

  Future<Map<String, int>> _readModuleLessonCounts() async {
    final String raw = await rootBundle.loadString('assets/data/modules.json');
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    final List<dynamic> modules = (json['modules'] as List<dynamic>?) ?? <dynamic>[];

    final Map<String, int> result = <String, int>{};
    for (final dynamic item in modules) {
      if (item is! Map) continue;
      final String id = (item['id'] ?? '').toString();
      final List<dynamic> lessons = (item['lessons'] as List<dynamic>?) ?? <dynamic>[];
      if (id.isNotEmpty) {
        result[id] = lessons.length;
      }
    }
    return result;
  }
}
