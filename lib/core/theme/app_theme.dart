import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // ── Palette ──────────────────────────────────────────────────────────────
  // Primary: Rich Indigo  |  Secondary: Teal  |  Tertiary: Amber
  static const Color _seed      = Color(0xFF5B6BF5); // vibrant indigo-blue
  static const Color _secondary = Color(0xFF0CA678); // emerald teal
  static const Color _tertiary  = Color(0xFFF76B3F); // sunset orange
  static const Color _error     = Color(0xFFF43F5E); // rose red

  // Light surface palette
  static const Color _lightSurface    = Color(0xFFF8F9FF);
  static const Color _lightCard       = Color(0xFFFFFFFF);
  static const Color _lightInput      = Color(0xFFEEF0FF);

  // Dark surface palette
  static const Color _darkBackground = Color(0xFF0F0F1A);
  static const Color _darkSurface    = Color(0xFF1A1A2E);
  static const Color _darkCard       = Color(0xFF16213E);

  // ── Shared button shape ──────────────────────────────────────────────────
  static final _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );

  // ── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      secondary: _secondary,
      tertiary: _tertiary,
      error: _error,
      brightness: Brightness.light,
      surface: _lightSurface,
    ),
    scaffoldBackgroundColor: _lightSurface,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      backgroundColor: _lightCard,
      foregroundColor: Color(0xFF1C1B4B),
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: _lightCard,
      shadowColor: const Color(0x1A5B6BF5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE8EAFF), width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _seed, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _seed,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: _buttonShape,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _seed,
        foregroundColor: Colors.white,
        shape: _buttonShape,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _seed,
        side: const BorderSide(color: _seed, width: 1.5),
        shape: _buttonShape,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _seed,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _seed,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEEF0FF),
      labelStyle: const TextStyle(
          color: _seed, fontWeight: FontWeight.w600, fontSize: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEF0FF),
      thickness: 1,
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontWeight: FontWeight.w800, color: Color(0xFF1C1B4B)),
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xFF1C1B4B)),
      headlineSmall: TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xFF1C1B4B)),
      titleLarge: TextStyle(
          fontWeight: FontWeight.w700, color: Color(0xFF1C1B4B)),
      titleMedium: TextStyle(
          fontWeight: FontWeight.w600, color: Color(0xFF1C1B4B)),
      bodyLarge: TextStyle(color: Color(0xFF2D2D5E)),
      bodyMedium: TextStyle(color: Color(0xFF4A4A7A)),
      bodySmall: TextStyle(color: Color(0xFF6B6B9A)),
      labelSmall: TextStyle(color: Color(0xFF6B6B9A)),
    ),
  );

  // ── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      secondary: _secondary,
      tertiary: _tertiary,
      error: _error,
      brightness: Brightness.dark,
      surface: _darkSurface,
    ),
    scaffoldBackgroundColor: _darkBackground,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      backgroundColor: _darkSurface,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: _darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFF2A2A4A), width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _seed, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _seed,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: _buttonShape,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _seed,
        foregroundColor: Colors.white,
        shape: _buttonShape,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _seed,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2A2A4A),
      labelStyle: const TextStyle(
          color: Color(0xFFADB5FF),
          fontWeight: FontWeight.w600,
          fontSize: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2A4A),
      thickness: 1,
    ),

    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
  );
}
