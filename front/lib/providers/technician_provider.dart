import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/technician.dart';
import 'mock_data.dart';

class TechnicianNotifier extends StateNotifier<Technician> {
  TechnicianNotifier() : super(MockData.technician);

  void setStatus(TechnicianStatus status) {
    state = state.copyWith(status: status);
  }
}

final technicianProvider = StateNotifierProvider<TechnicianNotifier, Technician>((ref) {
  return TechnicianNotifier();
});
