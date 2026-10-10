import 'package:flutter/material.dart';

/// Künye'nin "dark academia" paleti: ceviz raflar, eski deri, parşömen, yaldız ve öküz kanı cilt.
/// Renkler anlamlarına göre adlandırılmıştır; temayı değiştirmek için yalnızca bu dosya yeter.
abstract final class KunyeColors {
  static const background = Color(0xFF14100C);
  static const surface = Color(0xFF1F1813);
  static const surfaceHigh = Color(0xFF2A211A);
  static const text = Color(0xFFE8DCC4);
  static const textMuted = Color(0xFF9C8B73);
  static const border = Color(0xFF3A2F25);
  static const gold = Color(0xFFC9A45C);
  static const oxblood = Color(0xFF6E1F1F);
  static const forest = Color(0xFF1E2A21);
  static const shadow = Color(0xFF000000);

  // Koyu zemin üzerindeki eski kâğıtlar (künye fişi, sahaf notu)
  static const parchment = Color(0xFFE9DCC0);
  static const parchmentInk = Color(0xFF2B2016);
  static const parchmentMuted = Color(0xFF7A6A55);
  static const parchmentLine = Color(0xFFCDBB98);
}

ThemeData buildKunyeTheme() {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: KunyeColors.border),
  );

  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: KunyeColors.oxblood,
      brightness: Brightness.dark,
      primary: KunyeColors.gold,
      onPrimary: KunyeColors.background,
      secondary: KunyeColors.oxblood,
      surface: KunyeColors.background,
      onSurface: KunyeColors.text,
    ),
    fontFamily: 'serif',
  );

  return base.copyWith(
    scaffoldBackgroundColor: KunyeColors.background,
    textTheme: base.textTheme.apply(
      bodyColor: KunyeColors.text,
      displayColor: KunyeColors.text,
    ),
    iconTheme: const IconThemeData(color: KunyeColors.text),
    appBarTheme: const AppBarTheme(
      backgroundColor: KunyeColors.background,
      foregroundColor: KunyeColors.text,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: KunyeColors.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      hintStyle: const TextStyle(color: KunyeColors.textMuted),
      prefixIconColor: KunyeColors.textMuted,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: KunyeColors.gold),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: KunyeColors.oxblood,
        foregroundColor: KunyeColors.parchment,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: KunyeColors.gold.withValues(alpha: 0.6)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          fontFamily: 'serif',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: KunyeColors.gold,
        side: const BorderSide(color: KunyeColors.gold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: KunyeColors.gold),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: KunyeColors.surfaceHigh,
      textStyle: TextStyle(color: KunyeColors.text, fontFamily: 'serif'),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: KunyeColors.surfaceHigh,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: KunyeColors.surfaceHigh,
      contentTextStyle: TextStyle(color: KunyeColors.text, fontFamily: 'serif'),
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: const DividerThemeData(color: KunyeColors.border),
  );
}
