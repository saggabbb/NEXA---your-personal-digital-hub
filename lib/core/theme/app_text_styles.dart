/// Typography system aplikasi NEXA.
///
/// Menggunakan font bawaan Flutter (tanpa custom font)
/// dengan style yang tegas, modern, dan mudah dibaca.
///
/// Hierarki teks:
/// - heading1: Judul halaman utama (28px, bold)
/// - heading2: Sub-judul / section title (22px, bold)
/// - heading3: Card title (18px, semi-bold)
/// - bodyLarge: Teks utama (16px, regular)
/// - bodyMedium: Teks konten (14px, regular)
/// - bodySmall: Teks kecil (12px, regular)
/// - caption: Label / keterangan (11px, regular)
/// - button: Teks tombol (14px, bold)
library;

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ─── Headings ────────────────────────────────────────────

  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ─── Body ────────────────────────────────────────────────

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ─── Utility ─────────────────────────────────────────────

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.neonGreen,
    letterSpacing: 0.5,
  );

  /// Teks angka besar (untuk kalkulator, suhu, dsb)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.2,
  );

  /// Teks angka medium
  static const TextStyle displayMedium = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
}
