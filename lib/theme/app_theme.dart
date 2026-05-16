import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE2E8F0);
  static const borderSubtle = Color(0xFFF1F5F9);

  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted = Color(0xFF94A3B8);

  static const primary = Color(0xFF0F172A);
  static const primarySoft = Color(0xFF1E293B);
  static const accent = Color(0xFF2563EB);

  static const userBubble = Color(0xFF0F172A);
  static const assistantBubble = Color(0xFFFFFFFF);
  static const assistantBubbleBorder = Color(0xFFE2E8F0);

  static const success = Color(0xFF059669);
  static const successMuted = Color(0xFFD1FAE5);
}

abstract final class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.borderSubtle,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.border,
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ).copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: AppColors.textPrimary,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          fontSize: 15,
          height: 1.5,
          color: AppColors.textPrimary,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.45,
          color: AppColors.textSecondary,
        ),
        labelSmall: base.textTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: AppColors.textMuted,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
        ),
      ),
    );
  }
}
