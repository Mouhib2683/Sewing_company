import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum RepairPriority { low, medium, high, critical }

extension RepairPriorityX on RepairPriority {
  String get label => switch (this) {
        RepairPriority.low => 'Low',
        RepairPriority.medium => 'Medium',
        RepairPriority.high => 'High',
        RepairPriority.critical => 'Critical',
      };

  Color get color => switch (this) {
        RepairPriority.low => AppColors.priorityLow,
        RepairPriority.medium => AppColors.priorityMedium,
        RepairPriority.high => AppColors.priorityHigh,
        RepairPriority.critical => AppColors.priorityCritical,
      };

  IconData get icon => switch (this) {
        RepairPriority.low => Icons.arrow_downward_rounded,
        RepairPriority.medium => Icons.remove_rounded,
        RepairPriority.high => Icons.arrow_upward_rounded,
        RepairPriority.critical => Icons.priority_high_rounded,
      };
}
