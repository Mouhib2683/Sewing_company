import 'machine.dart';
import 'repair_priority.dart';

enum RepairWorkflowStatus { preparing, repairing }

class AssignedRepair {
  final String id;
  final Machine machine;
  final String failureType;
  final RepairPriority priority;
  final DateTime acceptedAt;
  final RepairWorkflowStatus workflowStatus;
  final DateTime? repairStartedAt;

  const AssignedRepair({
    required this.id,
    required this.machine,
    required this.failureType,
    required this.priority,
    required this.acceptedAt,
    required this.workflowStatus,
    this.repairStartedAt,
  });

  static const Duration prepWindow = Duration(minutes: 10);

  DateTime get prepDeadline => acceptedAt.add(prepWindow);

  AssignedRepair copyWith({
    RepairWorkflowStatus? workflowStatus,
    DateTime? repairStartedAt,
  }) {
    return AssignedRepair(
      id: id,
      machine: machine,
      failureType: failureType,
      priority: priority,
      acceptedAt: acceptedAt,
      workflowStatus: workflowStatus ?? this.workflowStatus,
      repairStartedAt: repairStartedAt ?? this.repairStartedAt,
    );
  }
}
