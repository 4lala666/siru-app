import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> saveQuizAttempt(QuizAttemptResult attempt) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

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
  }
}
