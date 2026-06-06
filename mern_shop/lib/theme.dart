import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color Palette ───────────────────────────────────────────────────────────
const kBg         = Color(0xFF0A0A0B);      // near-black background
const kSurface    = Color(0xFF131316);      // card surface
const kSurface2   = Color(0xFF1C1C21);      // elevated surface
const kBorder     = Color(0xFF2A2A32);      // subtle borders
const kGold       = Color(0xFFD4A853);      // primary accent — amber gold
const kGoldLight  = Color(0xFFE8C270);      // lighter gold
const kGoldDark   = Color(0xFFAA8430);      // darker gold
const kText       = Color(0xFFF0EDE8);      // primary text
const kTextMuted  = Color(0xFF8A8795);      // muted text
const kTextFaint  = Color(0xFF4A4858);      // very faint text
const kError      = Color(0xFFE05252);      // error red
const kSuccess    = Color(0xFF52C97A);      // success green
const kAdminAccent = Color(0xFF7B6EF6);     // admin purple

// ─── Gradients ────────────────────────────────────────────────────────────────
const kGoldGradient = LinearGradient(
  colors: [kGoldDark, kGold, kGoldLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kSurfaceGradient = LinearGradient(
  colors: [Color(0xFF17171C), Color(0xFF0F0F13)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ─── Theme ───────────────────────────────────────────────────────────────────
ThemeData appTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: kBg,
    colorScheme: const ColorScheme.dark(
      primary: kGold,
      secondary: kGoldLight,
      surface: kSurface,
      error: kError,
      onPrimary: kBg,
      onSurface: kText,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
          color: kText, fontSize: 48, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.playfairDisplay(
          color: kText, fontSize: 36, fontWeight: FontWeight.w600),
      displaySmall: GoogleFonts.playfairDisplay(
          color: kText, fontSize: 28, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.dmSans(
          color: kText, fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge:
          GoogleFonts.dmSans(color: kText, fontSize: 16, height: 1.6),
      bodyMedium:
          GoogleFonts.dmSans(color: kTextMuted, fontSize: 14, height: 1.5),
      labelLarge: GoogleFonts.dmSans(
          color: kBg, fontSize: 14, fontWeight: FontWeight.w600,
          letterSpacing: 0.5),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kBg,
      foregroundColor: kText,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
          color: kText, fontSize: 20, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kGold,
        foregroundColor: kBg,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kGold,
        side: const BorderSide(color: kGold),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kGold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kGold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kError, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: const TextStyle(color: kTextFaint, fontSize: 14),
      labelStyle: const TextStyle(color: kTextMuted),
    ),
    cardTheme: CardThemeData(
      color: kSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kBorder, width: 0.5),
      ),
    ),
    dividerTheme: const DividerThemeData(color: kBorder, thickness: 0.5),
    chipTheme: ChipThemeData(
      backgroundColor: kSurface2,
      labelStyle: const TextStyle(color: kTextMuted, fontSize: 12),
      side: const BorderSide(color: kBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kSurface2,
      contentTextStyle: const TextStyle(color: kText),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// ─── Reusable Decoration ─────────────────────────────────────────────────────
BoxDecoration glassDecoration({
  double radius = 16,
  Color borderColor = kBorder,
}) =>
    BoxDecoration(
      color: kSurface.withOpacity(0.8),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: 0.5),
    );

BoxDecoration goldBorderDecoration({double radius = 12}) => BoxDecoration(
      color: kSurface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: kGold.withOpacity(0.4), width: 1),
    );
