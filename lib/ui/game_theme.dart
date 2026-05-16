import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Refined palette for the temperament quest — playful but professional.
abstract final class GameColors {
  static const primary = Color(0xFF4F46E5);
  static const primaryDark = Color(0xFF312E81);
  static const accent = Color(0xFFF59E0B);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF8FAFC);
  static const border = Color(0xFFE2E8F0);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);

  static const sky = Color(0xFF38BDF8);
  static const violet = Color(0xFF8B5CF6);
  static const rose = Color(0xFFF43F5E);
  static const mint = Color(0xFF34D399);
  static const peach = Color(0xFFFB923C);

  static const deep = primaryDark;
}

abstract final class GameTheme {
  static ThemeData theme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GameColors.primary,
      brightness: Brightness.light,
      primary: GameColors.primary,
      onPrimary: Colors.white,
      secondary: GameColors.accent,
      surface: GameColors.surface,
    );

    final base = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: GameColors.surfaceMuted,
      textTheme: base.apply(
        bodyColor: GameColors.textPrimary,
        displayColor: GameColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: GameColors.textPrimary,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: GameColors.textPrimary,
          letterSpacing: -0.2,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GameColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GameColors.textPrimary,
          side: const BorderSide(color: GameColors.border),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: GameColors.primary,
        linearTrackColor: GameColors.border,
      ),
    );
  }

  static TextStyle display({double size = 32, FontWeight weight = FontWeight.w700, Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: -0.6,
      color: color ?? GameColors.textPrimary,
      height: 1.1,
    );
  }

  static TextStyle heading({double size = 20, FontWeight weight = FontWeight.w700, Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: -0.3,
      color: color ?? GameColors.textPrimary,
      height: 1.25,
    );
  }

  static TextStyle body({double size = 14, FontWeight weight = FontWeight.w500, Color? color}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color ?? GameColors.textSecondary,
      height: 1.45,
    );
  }

  static TextStyle eyebrow({Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.4,
      color: color ?? GameColors.textSecondary,
    );
  }

  static BoxDecoration cleanCard({Color? color, bool elevated = true}) {
    return BoxDecoration(
      color: color ?? GameColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: GameColors.border),
      boxShadow: elevated
          ? [
              BoxShadow(
                color: GameColors.primaryDark.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: GameColors.primaryDark.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration selectableCard({required bool selected, Color? accent}) {
    final a = accent ?? GameColors.primary;
    return BoxDecoration(
      color: selected ? a.withValues(alpha: 0.06) : GameColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: selected ? a : GameColors.border,
        width: selected ? 2 : 1,
      ),
      boxShadow: selected
          ? [
              BoxShadow(
                color: a.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ]
          : [
              BoxShadow(
                color: GameColors.primaryDark.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }
}
