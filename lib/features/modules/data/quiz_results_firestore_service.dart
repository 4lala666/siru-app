import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../mistakes/domain/mistake.dart';
import 'quiz_attempt_store.dart';

final quizResultsFirestoreServiceProvider = Provider<QuizResultsFirestoreService>((Ref ref) {
  return QuizResultsFirestoreService(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class QuizResultsFirestoreService {
  QuizResultsFirestoreService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<String?> saveQuizAttempt(QuizAttemptResult attempt) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    final DocumentReference<Map<String, dynamic>> doc =
        await _firestore.collection('quiz_results').add(<String, dynamic>{
      'userId': user.uid,
      'moduleId': attempt.moduleId,
      'subtopicId': attempt.subtopicId,
      'score': attempt.score,
      'totalQuestions': attempt.totalQuestions,
      'correctAnswers': attempt.correctAnswers,
      'wrongQuestionIds': attempt.wrongQuestionIds,
      'selectedAnswers': attempt.selectedAnswers,
      'completedAt': Timestamp.fromDate(attempt.completedAt),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  Future<void> saveWrongAnswers({
    required String moduleId,
    required String subtopicId,
    required List<QuizQuestion> questions,
    required Map<String, int> selectedAnswers,
    required DateTime completedAt,
    String? attemptId,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final WriteBatch batch = _firestore.batch();
    for (final QuizQuestion q in questions) {
      final int selectedIndex = selectedAnswers[q.questionId] ?? -1;
      if (selectedIndex == q.correctIndex) {
        continue;
      }

      final String selectedAnswer =
          selectedIndex >= 0 && selectedIndex < q.options.length ? q.options[selectedIndex] : '';
      final String correctAnswer =
          q.correctIndex >= 0 && q.correctIndex < q.options.length ? q.options[q.correctIndex] : '';

      final DocumentReference<Map<String, dynamic>> doc =
          _firestore.collection('wrong_answers').doc();
      batch.set(doc, <String, dynamic>{
        'attemptId': attemptId,
        'userId': user.uid,
        'userEmail': user.email,
        'userName': user.displayName,
        'moduleId': moduleId,
        'subtopicId': subtopicId,
        'questionId': q.questionId,
        'questionText': q.question,
        'questionType': q.type,
        'difficulty': q.difficulty,
        'selectedAnswer': selectedAnswer,
        'selectedAnswerIndex': selectedIndex,
        'correctAnswer': correctAnswer,
        'correctAnswerIndex': q.correctIndex,
        'explanation': q.explanation,
        'createdAt': Timestamp.fromDate(completedAt),
        'resolved': false,
      });
    }

    try {
      await batch.commit();
    } catch (e, st) {
      debugPrint('Failed to save wrong_answers: $e');
      debugPrint('$st');
    }
  }

  Future<void> markLearningActivity({DateTime? activityAt}) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final DateTime now = activityAt ?? DateTime.now();
    final String yyyy = now.year.toString().padLeft(4, '0');
    final String mm = now.month.toString().padLeft(2, '0');
    final String dd = now.day.toString().padLeft(2, '0');
    final String date = '$yyyy-$mm-$dd';
    final String documentId = '${user.uid}_$date';

    try {
      await _firestore.collection('learning_activity').doc(documentId).set(
        <String, dynamic>{
          'userId': user.uid,
          'userEmail': user.email,
          'userName': user.displayName,
          'date': date,
          'completedQuizzes': FieldValue.increment(1),
          'completedLessons': FieldValue.increment(0),
          'fixedMistakes': FieldValue.increment(0),
          'active': true,
          'lastActivityAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e, st) {
      debugPrint('Failed to update learning_activity: $e');
      debugPrint('$st');
    }
  }
}
