import 'machine.dart';
import 'repair_priority.dart';

class RepairNotification {
  final String id;
  final Machine machine;
  final String failureType;
  final DateTime detectedAt;
  final RepairPriority priority;

  const RepairNotification({
    required this.id,
    required this.machine,
    required this.failureType,
    required this.detectedAt,
    required this.priority,
  });
}
