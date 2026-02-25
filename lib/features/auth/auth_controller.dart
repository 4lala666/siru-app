import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthUiState>(
  (Ref ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthUiState> {
  AuthController() : super(const AuthUiState());

  Future<String?> signUpEmail(String email, String password) async {
    return _runGuarded(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    });
  }

  Future<String?> signInEmail(String email, String password) async {
    return _runGuarded(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
  }

  Future<String?> signOut() async {
    return _runGuarded(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
  }

  Future<String?> sendPasswordReset(String email) async {
    return _runGuarded(() async {
      await Future<void>.delayed(const Duration(milliseconds: 250));
    });
  }

  Future<String?> signInWithGoogle() async {
    return 'Google Sign-In is disabled in local mode.';
  }

  Future<String?> signInWithApple() async {
    return 'Apple Sign-In is disabled in local mode.';
  }

  Future<String?> sendEmailVerification() async {
    return _runGuarded(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
  }

  Future<String?> _runGuarded(Future<void> Function() action) async {
    try {
      state = state.copyWith(isLoading: true);
      await action();
      return null;
    } catch (_) {
      return 'Unexpected error. Please try again.';
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
