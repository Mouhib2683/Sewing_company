import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/repair_history_entry.dart';
import 'mock_data.dart';

class RepairHistoryNotifier extends StateNotifier<List<RepairHistoryEntry>> {
  RepairHistoryNotifier() : super(MockData.todayHistory());

  void addEntry(RepairHistoryEntry entry) {
    state = [entry, ...state];
  }
}

final repairHistoryProvider = StateNotifierProvider<RepairHistoryNotifier, List<RepairHistoryEntry>>((ref) {
  return RepairHistoryNotifier();
});
