import 'package:flutter/material.dart';

class AppColors {
  // Primary & Background
  static const Color primary = Color(0xFF5F55FF); // Main blue/purple color
  static const Color background = Color(0xFFF8F9FA); // Very light gray background
  static const Color white = Colors.white;
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color textDark = Color(0xFF212529); // Main text
  static const Color textLight = Color(0xFF6C757D); // Subtitles/Placeholders
  
  // Status Colors
  static const Color statusNormal = Color(0xFF28A745); // Green for normal
  static const Color statusWarning = Color(0xFFFFC107); // Yellow for soon
  static const Color statusDanger = Color(0xFFFD7E14); // Orange for late/overdue

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7367F0), Color(0xFF5F55FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
