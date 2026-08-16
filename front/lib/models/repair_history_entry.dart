class RepairHistoryEntry {
  final String id;
  final String machineCode;
  final String failureType;
  final DateTime completedAt;
  final Duration duration;

  const RepairHistoryEntry({
    required this.id,
    required this.machineCode,
    required this.failureType,
    required this.completedAt,
    required this.duration,
  });
}
