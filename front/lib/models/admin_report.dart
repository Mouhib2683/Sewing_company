/// A repair report ("rapport") as returned by GET /api/reports, i.e. the
/// admin's view of a report a technician submitted. Field names mirror the
/// backend's snake_case JSON directly, since this model only ever flows
/// one way (API -> UI).
class AdminReport {
  const AdminReport({
    required this.id,
    required this.technicianName,
    required this.machineCode,
    required this.failureType,
    required this.acceptedAt,
    required this.repairStartedAt,
    required this.repairEndedAt,
    required this.problemDescription,
    required this.solutionApplied,
    required this.createdAt,
    this.notes,
  });

  final String id;
  final String technicianName;
  final String machineCode;
  final String failureType;
  final DateTime acceptedAt;
  final DateTime repairStartedAt;
  final DateTime repairEndedAt;
  final String problemDescription;
  final String solutionApplied;
  final String? notes;
  final DateTime createdAt;

  Duration get duration => repairEndedAt.difference(repairStartedAt);

  factory AdminReport.fromJson(Map<String, dynamic> json) {
    return AdminReport(
      id: json['id'] as String,
      technicianName: json['technician_name'] as String,
      machineCode: json['machine_code'] as String,
      failureType: json['failure_type'] as String,
      acceptedAt: DateTime.parse(json['accepted_at'] as String),
      repairStartedAt: DateTime.parse(json['repair_started_at'] as String),
      repairEndedAt: DateTime.parse(json['repair_ended_at'] as String),
      problemDescription: json['problem_description'] as String,
      solutionApplied: json['solution_applied'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
