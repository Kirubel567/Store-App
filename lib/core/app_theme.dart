import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color navyDark   = Color(0xFF1A1A2E);
  static const Color navyMid    = Color(0xFF16213E);
  static const Color accentBlue = Color(0xFF4F46E5);
  static const Color bgSurface  = Color(0xFFF8F7F4);
  static const Color bgCard     = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textMuted     = Color(0xFF999999);
  static const Color borderLight   = Color(0xFFE8E8E8);
  static const Color dangerLight   = Color(0xFFFFF0F0);
  static const Color dangerText    = Color(0xFFE53E3E);
  static const Color dangerBorder  = Color(0xFFFFCCCC);

  // Category chip colors (maps to API categories)
  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return const Color(0xFFEEF2FF);
      case 'jewelery':
        return const Color(0xFFFDF2F8);
      case "men's clothing":
        return const Color(0xFFECFDF5);
      case "women's clothing":
        return const Color(0xFFFFF7ED);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  static Color categoryTextColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return const Color(0xFF4F46E5);
      case 'jewelery':
        return const Color(0xFFBE185D);
      case "men's clothing":
        return const Color(0xFF065F46);
      case "women's clothing":
        return const Color(0xFFC2410C);
      default:
        return const Color(0xFF374151);
    }
  }

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bgSurface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: navyDark,
      surface: bgSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: navyDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Color(0xFF555555),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E2E2), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: navyDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dangerText, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: navyDark,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
    cardTheme: CardThemeData(
      color: bgCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE8E8E8), width: 0.5),
      ),
    ),
    chipTheme: ChipThemeData(
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}