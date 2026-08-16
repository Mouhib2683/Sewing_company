import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_report.dart';
import '../services/reports_api.dart';
import 'auth_provider.dart';

class AdminReportsState {
  const AdminReportsState({
    this.isLoading = false,
    this.error,
    this.reports = const [],
  });

  final bool isLoading;
  final String? error;
  final List<AdminReport> reports;

  AdminReportsState copyWith({
    bool? isLoading,
    String? error,
    List<AdminReport>? reports,
  }) {
    return AdminReportsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      reports: reports ?? this.reports,
    );
  }
}

/// Backs the admin dashboard: fetches every technician's submitted reports
/// from `GET /api/reports` (admin-only on the backend).
class AdminReportsNotifier extends StateNotifier<AdminReportsState> {
  AdminReportsNotifier(this._ref) : super(const AdminReportsState());

  final Ref _ref;

  Future<void> load() async {
    final token = _ref.read(authProvider).accessToken;
    if (token == null) {
      state = state.copyWith(error: 'Not logged in');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final reports = await _ref.read(reportsApiProvider).fetchReports(token);
      state = state.copyWith(isLoading: false, reports: reports, error: null);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }
}

final adminReportsProvider = StateNotifierProvider<AdminReportsNotifier, AdminReportsState>((ref) {
  return AdminReportsNotifier(ref);
});
