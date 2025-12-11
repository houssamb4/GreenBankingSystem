import 'package:flutter/material.dart';

class AppColors {
  // Primary green color for eco-friendly theme
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);

  // Accent colors
  static const Color accent = Color(0xFF66BB6A);
  static const Color accentLight = Color(0xFF98EE99);
  static const Color accentDark = Color(0xFF338A3E);

  // Carbon indicator colors
  static const Color lowCarbon = Color(0xFF4CAF50);
  static const Color mediumCarbon = Color(0xFFFF9800);
  static const Color highCarbon = Color(0xFFF44336);

  // Neutral colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E0E0);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Get carbon color based on percentage
  static Color getCarbonColor(double percentage) {
    if (percentage <= 50) return lowCarbon;
    if (percentage <= 75) return mediumCarbon;
    return highCarbon;
  }

  // Get eco score color
  static Color getEcoScoreColor(int score) {
    if (score >= 75) return success;
    if (score >= 50) return warning;
    return error;
  }
}
