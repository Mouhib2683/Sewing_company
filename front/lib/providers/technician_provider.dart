import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/technician.dart';
import 'mock_data.dart';

class TechnicianNotifier extends StateNotifier<Technician> {
  TechnicianNotifier() : super(MockData.technician);

  void setStatus(TechnicianStatus status) {
    state = state.copyWith(status: status);
  }

  /// Called right after a successful login/sign-up so the name shown in the
  /// app (report form, profile screen) reflects the real logged-in account
  /// instead of the mock technician. Employee ID/phone/status stay mocked
  /// for now, since the backend doesn't model them yet.
  void hydrateFromAuth({required String fullName, required String role}) {
    state = Technician(
      id: state.id,
      fullName: fullName.isNotEmpty ? fullName : state.fullName,
      role: role == 'admin' ? 'Admin' : 'Maintenance Technician',
      employeeId: state.employeeId,
      phone: state.phone,
      status: state.status,
    );
  }
}

final technicianProvider = StateNotifierProvider<TechnicianNotifier, Technician>((ref) {
  return TechnicianNotifier();
});
