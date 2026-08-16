import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import 'technician_provider.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.accessToken,
    this.userId,
    this.email,
    this.fullName,
    this.role,
    this.errorMessage,
    this.needsEmailConfirmation = false,
  });

  final AuthStatus status;
  final String? accessToken;
  final String? userId;
  final String? email;
  final String? fullName;
  final String? role; // 'technicien' | 'admin'
  final String? errorMessage;

  /// True right after a sign-up whose Supabase project requires email
  /// confirmation before the account can log in (no session was returned).
  final bool needsEmailConfirmation;

  bool get isAdmin => role == 'admin';

  AuthState copyWith({
    AuthStatus? status,
    String? accessToken,
    String? userId,
    String? email,
    String? fullName,
    String? role,
    String? errorMessage,
    bool? needsEmailConfirmation,
  }) {
    return AuthState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      errorMessage: errorMessage,
      needsEmailConfirmation: needsEmailConfirmation ?? false,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref, this._api) : super(const AuthState());

  final Ref _ref;
  final ApiClient _api;

  Future<bool> login({required String email, required String password}) async {
    try {
      final data = await _api.post('/api/auth/signin', {
        'email': email,
        'password': password,
      });

      final session = data['session'] as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>;
      final profile = data['profile'] as Map<String, dynamic>;

      _applySession(session: session, userId: user['id'] as String, email: user['email'] as String?, profile: profile);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Could not reach the server. Is it running?');
      return false;
    }
  }

  /// Returns true if sign-up resulted in an immediately-usable, logged-in
  /// session. Returns false either on error (check [AuthState.errorMessage])
  /// or when the Supabase project requires email confirmation first (check
  /// [AuthState.needsEmailConfirmation]).
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final data = await _api.post('/api/auth/signup', {
        'name': name,
        'email': email,
        'password': password,
      });

      final session = data['session'] as Map<String, dynamic>?;
      final user = data['user'] as Map<String, dynamic>;
      final profile = data['profile'] as Map<String, dynamic>;

      if (session == null) {
        // Email confirmation is required by this Supabase project — no
        // session yet, so we can't log the user in.
        state = state.copyWith(needsEmailConfirmation: true, errorMessage: null);
        return false;
      }

      _applySession(session: session, userId: user['id'] as String, email: user['email'] as String?, profile: profile);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Could not reach the server. Is it running?');
      return false;
    }
  }

  void _applySession({
    required Map<String, dynamic> session,
    required String userId,
    required String? email,
    required Map<String, dynamic> profile,
  }) {
    final fullName = profile['full_name'] as String? ?? '';
    final role = profile['role'] as String? ?? 'technicien';

    state = AuthState(
      status: AuthStatus.authenticated,
      accessToken: session['access_token'] as String?,
      userId: userId,
      email: email,
      fullName: fullName,
      role: role,
    );

    // Keep the technician-facing UI (report form, profile screen) in sync
    // with whoever actually just logged in.
    _ref.read(technicianProvider.notifier).hydrateFromAuth(fullName: fullName, role: role);
  }

  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref, ref.read(apiClientProvider));
});
