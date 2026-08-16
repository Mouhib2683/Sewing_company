import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier() : super(AuthStatus.unauthenticated);

  /// Fake login — accepts any non-empty credentials, simulates network
  /// latency so the login screen's loading state has something to show.
  /// This is the seam that gets replaced with a real API call later.
  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (email.trim().isEmpty || password.trim().isEmpty) return false;
    state = AuthStatus.authenticated;
    return true;
  }

  /// Fake sign-up — accepts any non-empty name/email/password, simulates
  /// network latency so the sign-up screen's loading state has something
  /// to show. This is the seam that gets replaced with a real API call
  /// later (create account, then usually auto-login).
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }
    state = AuthStatus.authenticated;
    return true;
  }

  void logout() {
    state = AuthStatus.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStatus>((ref) {
  return AuthNotifier();
});