// lib/core/theme/app_color.dart
import 'package:flutter/material.dart';

class AppColors {
  // --- Main Colors ---
  static const Color primary = Color(
    0xFF007BFF,
  ); // A vibrant, professional blue
  static const Color secondary = Color(0xFF00C6FF);
  static const Color accent = Color(0xFFE0F7FA); // A light cyan for accents

  // --- Background Colors ---
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);

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
}
