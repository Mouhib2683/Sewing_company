import 'package:flutter/material.dart';

/// Central palette for the app. Dark-mode-only, industrial feel.
/// Kept as plain static constants (rather than a ThemeExtension) so any
/// widget can reach for a semantic color without needing BuildContext.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF3D7BFF); // deep-ish blue, but bright enough to read on dark bg
  static const Color primaryVariant = Color(0xFF2B5FD9);
  static const Color accent = Color(0xFFFF8A3D); // orange

  // Status
  static const Color success = Color(0xFF3FCF6E);
  static const Color error = Color(0xFFFF5A5A);
  static const Color warning = Color(0xFFFFC24D);

  // Priority scale (distinct from status colors to avoid ambiguity in UI)
  static const Color priorityLow = Color(0xFF6FA8FF);
  static const Color priorityMedium = Color(0xFFFFC24D);
  static const Color priorityHigh = Color(0xFFFF8A3D);
  static const Color priorityCritical = Color(0xFFFF5A5A);

  // Surfaces
  static const Color background = Color(0xFF0F1216);
  static const Color surface = Color(0xFF171B21);
  static const Color surfaceElevated = Color(0xFF1E232B);
  static const Color border = Color(0xFF2A303A);

  // Text
  static const Color textPrimary = Color(0xFFF2F4F7);
  static const Color textSecondary = Color(0xFF9AA4B2);
  static const Color textDisabled = Color(0xFF5B6472);
}
