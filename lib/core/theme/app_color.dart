import 'package:flutter/material.dart';

// A centralized place for all the app's colors.
// This makes it easy to change the color scheme in the future.
class AppColors {
  // --- Main Colors ---
  static const Color primary = Colors.blue; // اللون الأزرق الأساسي
  static const Color secondary = Color(0xFF007BFF);
  static const Color accent = Color(0xFF00C6FF);

  // --- Background Colors ---
  static const Color background = Color(
    0xFFF8F9FA,
  ); // خلفية بيضاء مائلة للرمادي
  static const Color backgroundDark = Color(0xFF121212); // خلفية داكنة

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // --- Component Colors ---
  static const Color card = Colors.white;
  static const Color border = Color(0xFFDEE2E6);

  // --- Semantic Colors ---
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);

  // --- Gradients ---
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, primary],
  );

  static LinearGradient authGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.cyan.shade200, Colors.blue.shade500],
  );
}
