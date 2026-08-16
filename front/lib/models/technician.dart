import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum TechnicianStatus { available, preparing, repairing, offline }

extension TechnicianStatusX on TechnicianStatus {
  String get label => switch (this) {
        TechnicianStatus.available => 'Available',
        TechnicianStatus.preparing => 'Preparing',
        TechnicianStatus.repairing => 'Repairing',
        TechnicianStatus.offline => 'Offline',
      };

  Color get color => switch (this) {
        TechnicianStatus.available => AppColors.success,
        TechnicianStatus.preparing => AppColors.warning,
        TechnicianStatus.repairing => AppColors.accent,
        TechnicianStatus.offline => AppColors.textDisabled,
      };
}

class Technician {
  final String id;
  final String fullName;
  final String role;
  final String employeeId;
  final String phone;
  final TechnicianStatus status;

  const Technician({
    required this.id,
    required this.fullName,
    required this.role,
    required this.employeeId,
    required this.phone,
    required this.status,
  });

  Technician copyWith({TechnicianStatus? status}) {
    return Technician(
      id: id,
      fullName: fullName,
      role: role,
      employeeId: employeeId,
      phone: phone,
      status: status ?? this.status,
    );
  }
}
