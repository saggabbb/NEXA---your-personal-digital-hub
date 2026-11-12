/// Reusable card widget untuk NEXA.
///
/// Mendukung 2 varian:
/// 1. **Standard** — Background surface solid dengan border charcoal
/// 2. **Glass** — Glassmorphism: background semi-transparan dengan border putih tipis
///
/// Kedua varian mendukung:
/// - Opsional glow effect hijau neon
/// - Padding dan margin konsisten
/// - Tap callback (InkWell)
/// - Border radius rounded
///
/// Cara pakai:
/// ```dart
/// // Standard card
/// NexaCard(child: Text('Konten'))
///
/// // Glassmorphism card
/// NexaCard.glass(child: Text('Konten'))
///
/// // Card dengan glow
/// NexaCard(child: Text('Konten'), hasGlow: true)
/// ```
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class NexaCard extends StatelessWidget {
  const NexaCard({
    super.key,
    required this.child,
    this.hasGlow = false,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor,
  })  : _isGlass = false;

  /// Glassmorphism variant — semi-transparan dengan border putih tipis.
  const NexaCard.glass({
    super.key,
    required this.child,
    this.hasGlow = false,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor,
  })  : _isGlass = true;

  final Widget child;
  final bool hasGlow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool _isGlass;

  @override
  Widget build(BuildContext context) {
    // Pilih warna berdasarkan varian
    final bgColor = _isGlass ? AppColors.glassBg : AppColors.surface;
    final bColor = borderColor ??
        (_isGlass ? AppColors.glassBorder : AppColors.border);

    Widget card = Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: bColor, width: _isGlass ? 0.5 : 1),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: AppColors.neonGlowSubtle,
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          splashColor: AppColors.neonGreen.withValues(alpha: 0.08),
          highlightColor: AppColors.neonGreen.withValues(alpha: 0.04),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );

    // Glassmorphism: tambahkan blur di belakang card
    if (_isGlass) {
      card = ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: card,
        ),
      );
    }

    return card;
  }
}
