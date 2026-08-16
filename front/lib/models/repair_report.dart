class RepairReport {
  final String technicianName;
  final String machineCode;
  final String failureType;
  final DateTime acceptedAt;
  final DateTime repairStartedAt;
  final DateTime repairEndedAt;
  final String problemDescription;
  final String solutionApplied;
  final String? notes;

  const RepairReport({
    required this.technicianName,
    required this.machineCode,
    required this.failureType,
    required this.acceptedAt,
    required this.repairStartedAt,
    required this.repairEndedAt,
    required this.problemDescription,
    required this.solutionApplied,
    this.notes,
  });

  Duration get duration => repairEndedAt.difference(repairStartedAt);
}
