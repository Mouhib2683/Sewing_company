import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assigned_repair.dart';
import '../models/repair_history_entry.dart';
import '../models/repair_report.dart';
import '../models/technician.dart';
import 'assigned_repair_provider.dart';
import 'notifications_provider.dart';
import 'repair_history_provider.dart';
import 'technician_provider.dart';

/// Mirrors, at the UI-state level, the same sequence the real backend will
/// eventually drive via REST calls + socket events: accept -> start ->
/// finish -> submit report. Centralizing it here means screens just call a
/// single method instead of coordinating four providers by hand.
class RepairWorkflowController {
  RepairWorkflowController(this._ref);
  final Ref _ref;

  void acceptNotification(String notificationId) {
    final notification = _ref.read(notificationsProvider.notifier).accept(notificationId);
    if (notification == null) return;

    _ref.read(assignedRepairProvider.notifier).assign(
          AssignedRepair(
            id: notification.id,
            machine: notification.machine,
            failureType: notification.failureType,
            priority: notification.priority,
            acceptedAt: DateTime.now(),
            workflowStatus: RepairWorkflowStatus.preparing,
          ),
        );

    _ref.read(technicianProvider.notifier).setStatus(TechnicianStatus.preparing);
  }

  void startRepair() {
    _ref.read(assignedRepairProvider.notifier).startRepair();
    _ref.read(technicianProvider.notifier).setStatus(TechnicianStatus.repairing);
  }

  /// Submits the mandatory report, logs it to today's history, releases the
  /// technician back to available, and clears the active assignment.
  /// Returns the constructed report — shaped exactly like what a real
  /// `POST /incidents/:id/report` call would send/receive later.
  RepairReport? submitReport({required String problemDescription, required String solutionApplied, String? notes}) {
    final repair = _ref.read(assignedRepairProvider);
    final technician = _ref.read(technicianProvider);
    if (repair == null || repair.repairStartedAt == null) return null;

    final now = DateTime.now();

    final report = RepairReport(
      technicianName: technician.fullName,
      machineCode: repair.machine.code,
      failureType: repair.failureType,
      acceptedAt: repair.acceptedAt,
      repairStartedAt: repair.repairStartedAt!,
      repairEndedAt: now,
      problemDescription: problemDescription,
      solutionApplied: solutionApplied,
      notes: notes,
    );

    _ref.read(repairHistoryProvider.notifier).addEntry(
          RepairHistoryEntry(
            id: 'rep-${now.millisecondsSinceEpoch}',
            machineCode: repair.machine.code,
            failureType: repair.failureType,
            completedAt: now,
            duration: report.duration,
          ),
        );

    _ref.read(technicianProvider.notifier).setStatus(TechnicianStatus.available);
    _ref.read(assignedRepairProvider.notifier).clear();

    return report;
  }
}

final repairWorkflowControllerProvider = Provider<RepairWorkflowController>((ref) {
  return RepairWorkflowController(ref);
});
