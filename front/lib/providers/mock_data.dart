import '../models/machine.dart';
import '../models/repair_notification.dart';
import '../models/repair_priority.dart';
import '../models/repair_history_entry.dart';
import '../models/technician.dart';

/// All fake data lives here. Every provider that "fetches" data reads from
/// this class instead of hardcoding values inline — when a real backend
/// exists, this is the file that gets replaced by API/repository calls,
/// without the providers or UI needing to change shape.
class MockData {
  MockData._();

  static final Technician technician = const Technician(
    id: 'tech-001',
    fullName: 'Ali Ben Salah',
    role: 'Maintenance Technician',
    employeeId: 'EMP-2291',
    phone: '+216 55 123 456',
    status: TechnicianStatus.available,
  );

  static final List<Machine> machines = const [
    Machine(id: 'm-15', code: '15', name: 'Juki Overlock', location: 'Line A'),
    Machine(id: 'm-08', code: '08', name: 'Brother Lockstitch', location: 'Line B'),
    Machine(id: 'm-22', code: '22', name: 'Pegasus Coverstitch', location: 'Line A'),
    Machine(id: 'm-03', code: '03', name: 'Juki Buttonhole', location: 'Line C'),
  ];

  static final List<String> failureTypes = const [
    'Thread Jam',
    'Needle Break',
    'Motor Overheating',
    'Tension Malfunction',
    'Belt Slippage',
    'Bobbin Misfeed',
  ];

  /// Freshly generated each time it's read, so re-launching the "shared
  /// notification space" screen always shows a believable, slightly
  /// different queue — mirroring how a live feed would behave.
  static List<RepairNotification> waitingNotifications() {
    final now = DateTime.now();
    return [
      RepairNotification(
        id: 'inc-1001',
        machine: machines[0],
        failureType: failureTypes[0],
        detectedAt: now.subtract(const Duration(minutes: 2)),
        priority: RepairPriority.high,
      ),
      RepairNotification(
        id: 'inc-1002',
        machine: machines[1],
        failureType: failureTypes[2],
        detectedAt: now.subtract(const Duration(minutes: 6)),
        priority: RepairPriority.critical,
      ),
      RepairNotification(
        id: 'inc-1003',
        machine: machines[2],
        failureType: failureTypes[3],
        detectedAt: now.subtract(const Duration(minutes: 11)),
        priority: RepairPriority.medium,
      ),
      RepairNotification(
        id: 'inc-1004',
        machine: machines[3],
        failureType: failureTypes[4],
        detectedAt: now.subtract(const Duration(minutes: 18)),
        priority: RepairPriority.low,
      ),
    ];
  }

  static List<RepairHistoryEntry> todayHistory() {
    final now = DateTime.now();
    return [
      RepairHistoryEntry(
        id: 'rep-9001',
        machineCode: '11',
        failureType: 'Needle Break',
        completedAt: now.subtract(const Duration(hours: 2)),
        duration: const Duration(minutes: 14),
      ),
      RepairHistoryEntry(
        id: 'rep-9002',
        machineCode: '07',
        failureType: 'Thread Jam',
        completedAt: now.subtract(const Duration(hours: 4)),
        duration: const Duration(minutes: 9),
      ),
      RepairHistoryEntry(
        id: 'rep-9003',
        machineCode: '19',
        failureType: 'Belt Slippage',
        completedAt: now.subtract(const Duration(hours: 5, minutes: 30)),
        duration: const Duration(minutes: 21),
      ),
    ];
  }
}
