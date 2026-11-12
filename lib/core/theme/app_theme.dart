/// ThemeData lengkap aplikasi NEXA.
///
/// File ini menggabungkan AppColors dan AppTextStyles menjadi
/// satu ThemeData yang dipakai oleh MaterialApp.
///
/// Konsep: Futuristic Dark Mode — hitam dominan dengan aksen hijau neon.
/// Semua komponen Material (AppBar, Card, BottomNavigationBar, Input, dll)
/// di-override agar sesuai dengan identitas visual NEXA.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      // ─── Base ──────────────────────────────────────────
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffoldBg,

      // ─── Color Scheme ──────────────────────────────────
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonGreen,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.darkGreen,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textPrimary,
      ),

      // ─── AppBar ────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),

      // ─── Card ──────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      // ─── Bottom Navigation Bar ─────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navBarBg,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: AppColors.navInactive,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        elevation: 0,
      ),

      // ─── Input / TextField ─────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.neonGreen,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),

      // ─── Elevated Button ───────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // ─── Outlined Button ───────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.neonGreen,
          side: const BorderSide(color: AppColors.neonGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.neonGreen,
          ),
        ),
      ),

      // ─── Text Button ──────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.neonGreen,
          textStyle: AppTextStyles.button.copyWith(
            color: AppColors.neonGreen,
          ),
        ),
      ),

      // ─── Icon ──────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppIconSize.md,
      ),

      // ─── Divider ───────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ─── Text Theme (fallback) ─────────────────────────
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        headlineSmall: AppTextStyles.heading3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.button,
        labelSmall: AppTextStyles.caption,
      ),
    );
  }
}
