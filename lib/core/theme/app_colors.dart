/// Palette warna aplikasi NEXA.
///
/// Konsep: Dark Futuristic Neon Green
/// Terinspirasi dari estetika tech/digital modern dengan
/// background hitam pekat, aksen hijau neon, dan efek atmosferik.
///
/// Kategori warna:
/// 1. Primary — Hijau neon untuk aksen dan interaksi
/// 2. Background — Hitam pekat dan charcoal untuk latar
/// 3. Surface — Charcoal dengan variasi untuk card dan panel
/// 4. Text — Putih, abu-abu, dan variasi untuk hierarki teks
/// 5. Glassmorphism — Warna transparan untuk efek kaca
/// 6. Gradient — Warna untuk gradient atmosferik background
/// 7. Status — Warna untuk feedback (error, success, dll)
/// 8. Navigation — Warna khusus bottom nav bar
library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Primary Colors ──────────────────────────────────────
  /// Hijau neon utama — aksen, tombol, ikon aktif
  static const Color neonGreen = Color(0xFFB9FF66);

  /// Hijau neon terang — highlight, gradient atas
  static const Color neonGreenLight = Color(0xFFD4FF9E);

  /// Hijau tua — elemen sekunder
  static const Color darkGreen = Color(0xFF2E7D32);

  /// Hijau sangat tua — subtle accent
  static const Color deepGreen = Color(0xFF1B5E20);

  // ─── Background Colors ───────────────────────────────────
  /// Background utama (hitam pekat)
  static const Color background = Color(0xFF0A0A0A);

  /// Background scaffold
  static const Color scaffoldBg = Color(0xFF0D0D0D);

  /// Surface card (charcoal gelap)
  static const Color surface = Color(0xFF1A1A1A);

  /// Surface sedikit lebih terang (nested cards)
  static const Color surfaceLight = Color(0xFF242424);

  /// Surface hover/pressed
  static const Color surfaceHover = Color(0xFF2A2A2A);

  // ─── Text Colors ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF707070);
  static const Color textOnPrimary = Color(0xFF0A0A0A);

  // ─── Border & Divider ────────────────────────────────────
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderFocused = Color(0xFFB9FF66);
  static const Color divider = Color(0xFF1F1F1F);

  // ─── Status Colors ───────────────────────────────────────
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF69F0AE);
  static const Color warning = Color(0xFFFFD740);
  static const Color info = Color(0xFF40C4FF);

  // ─── Glassmorphism ───────────────────────────────────────
  /// Background card glassmorphism (semi-transparan)
  static Color get glassBg => Colors.white.withValues(alpha: 0.05);

  /// Background glass lebih terang
  static Color get glassBgLight => Colors.white.withValues(alpha: 0.08);

  /// Border glassmorphism (sangat tipis, putih transparan)
  static Color get glassBorder => Colors.white.withValues(alpha: 0.1);

  /// Border glass lebih terlihat
  static Color get glassBorderLight => Colors.white.withValues(alpha: 0.15);

  // ─── Gradient (Atmospheric Background) ───────────────────
  /// Hijau neon sangat transparan — untuk blob dekoratif
  static Color get gradientGreen => neonGreen.withValues(alpha: 0.12);

  /// Hijau tua transparan — untuk blob sekunder
  static Color get gradientDarkGreen => const Color(0xFF3D6B1E).withValues(alpha: 0.2);

  /// Olive transparan — untuk variasi blob
  static Color get gradientOlive => const Color(0xFF4A5D23).withValues(alpha: 0.15);

  // ─── Glow & Shadow ───────────────────────────────────────
  static Color get neonGlow => neonGreen.withValues(alpha: 0.3);
  static Color get neonGlowSubtle => neonGreen.withValues(alpha: 0.1);
  static Color get neonGlowStrong => neonGreen.withValues(alpha: 0.5);
  static Color get shadowDark => Colors.black.withValues(alpha: 0.5);

  // ─── Navigation ──────────────────────────────────────────
  static const Color navBarBg = Color(0xFF111111);
  static const Color navInactive = Color(0xFF606060);
  static const Color navActive = neonGreen;
}
