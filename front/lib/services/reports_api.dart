import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_report.dart';
import '../providers/auth_provider.dart';
import 'api_client.dart';

class ReportsApi {
  ReportsApi(this._client);
  final ApiClient _client;

  /// Technician submits a repair report. Timestamps are sent as ISO-8601.
  Future<void> submitReport({
    required String token,
    required String machineCode,
    required String failureType,
    required DateTime acceptedAt,
    required DateTime repairStartedAt,
    required DateTime repairEndedAt,
    required String problemDescription,
    required String solutionApplied,
    String? notes,
  }) async {
    await _client.post(
      '/api/reports',
      {
        'machineCode': machineCode,
        'failureType': failureType,
        'acceptedAt': acceptedAt.toIso8601String(),
        'repairStartedAt': repairStartedAt.toIso8601String(),
        'repairEndedAt': repairEndedAt.toIso8601String(),
        'problemDescription': problemDescription,
        'solutionApplied': solutionApplied,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
      token: token,
    );
  }

  /// Admin only — every technician's reports, most recent first.
  Future<List<AdminReport>> fetchReports(String token) async {
    final data = await _client.get('/api/reports', token: token) as List<dynamic>;
    return data
        .map((item) => AdminReport.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Admin only — single report detail.
  Future<AdminReport> fetchReportById(String token, String id) async {
    final data = await _client.get('/api/reports/$id', token: token);
    return AdminReport.fromJson(data as Map<String, dynamic>);
  }
}

final reportsApiProvider = Provider<ReportsApi>((ref) {
  return ReportsApi(ref.read(apiClientProvider));
});
