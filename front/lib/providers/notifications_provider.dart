import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/repair_notification.dart';
import 'mock_data.dart';

class NotificationsNotifier extends StateNotifier<List<RepairNotification>> {
  NotificationsNotifier() : super(MockData.waitingNotifications());

  /// Removes a notification once it's been accepted. In the real app this
  /// is where the shared queue updates for every technician simultaneously
  /// (via the `incident:claimed` socket event) — here it's just local state.
  RepairNotification? accept(String id) {
    RepairNotification? accepted;
    state = state.where((n) {
      if (n.id == id) {
        accepted = n;
        return false;
      }
      return true;
    }).toList();
    return accepted;
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<RepairNotification>>((ref) {
  return NotificationsNotifier();
});
