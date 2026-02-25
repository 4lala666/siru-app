import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthUiState>(
  (Ref ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthUiState> {
  AuthController() : super(const AuthUiState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> signUpEmail(String email, String password) async {
    return _runGuarded(() async {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _ensureUserDoc(cred.user!);
    });
  }

  Future<String?> signInEmail(String email, String password) async {
    return _runGuarded(() async {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _ensureUserDoc(cred.user!);
    });
  }

  Future<String?> signOut() async {
    return _runGuarded(() async {
      // если хотите — можно ещё GoogleSignIn().signOut()
      await _auth.signOut();
    });
  }

  Future<String?> sendPasswordReset(String email) async {
    return _runGuarded(() async {
      await _auth.sendPasswordResetEmail(email: email.trim());
    });
  }

  Future<String?> signInWithGoogle() async {
    return _runGuarded(() async {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      await _ensureUserDoc(cred.user!);
    });
  }

  Future<String?> signInWithApple() async {
    if (kIsWeb) return 'Apple Sign-In is not supported on web.';
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return 'Apple Sign-In is available only on iOS.';
    }

    return _runGuarded(() async {
      final rawNonce = _randomNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final cred = await _auth.signInWithCredential(oauthCredential);
      await _ensureUserDoc(cred.user!);
    });
  }

  Future<String?> sendEmailVerification() async {
    return _runGuarded(() async {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No signed-in user');
      if (user.emailVerified) return;
      await user.sendEmailVerification();
    });
  }

  Future<String?> _runGuarded(Future<void> Function() action) async {
  try {
    state = state.copyWith(isLoading: true);
    await action();
    return null;
  } on FirebaseAuthException catch (e, stack) {
    debugPrint('================ FIREBASE AUTH ERROR ================');
    debugPrint('CODE: ${e.code}');
    debugPrint('MESSAGE: ${e.message}');
    debugPrint('STACK: $stack');
    debugPrint('====================================================');
    return _mapAuthError(e);
  } catch (e, stack) {
    debugPrint('================ UNKNOWN ERROR ================');
    debugPrint('ERROR: $e');
    debugPrint('STACK: $stack');
    debugPrint('================================================');
    return e.toString();
  } finally {
    state = state.copyWith(isLoading: false);
  }
}

  Future<void> _ensureUserDoc(User user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) return;

    final provider = user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : 'password';

    await ref.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? '',
      'provider': provider, // password / google.com / apple.com
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Неверный email';
      case 'user-disabled':
        return 'Аккаунт отключён';
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Этот email уже зарегистрирован';
      case 'weak-password':
        return 'Слишком простой пароль';
      case 'network-request-failed':
        return 'Проблема с интернетом';
      default:
        return 'Ошибка авторизации: ${e.code}';
    }
  }
}

String _randomNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final rand = Random.secure();
  return List.generate(length, (_) => charset[rand.nextInt(charset.length)])
      .join();
}

String _sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}