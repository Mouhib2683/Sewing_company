import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assigned_repair.dart';

class AssignedRepairNotifier extends StateNotifier<AssignedRepair?> {
  AssignedRepairNotifier() : super(null);

  void assign(AssignedRepair repair) => state = repair;

  void startRepair() {
    final current = state;
    if (current == null) return;
    state = current.copyWith(
      workflowStatus: RepairWorkflowStatus.repairing,
      repairStartedAt: DateTime.now(),
    );
  }

  /// Called once the report has been submitted — clears the active task so
  /// the technician is free for the next assignment.
  void clear() => state = null;
}

final assignedRepairProvider = StateNotifierProvider<AssignedRepairNotifier, AssignedRepair?>((ref) {
  return AssignedRepairNotifier();
});
