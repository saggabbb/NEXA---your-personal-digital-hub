/// Widget background dekoratif atmosferik untuk NEXA.
///
/// Membuat efek gradient blob abstrak di latar belakang halaman,
/// mirip dengan estetika dark futuristic — lingkaran besar berwarna
/// hijau gelap yang blur dan transparan, menciptakan pencahayaan
/// atmosferik tanpa mengganggu konten di depannya.
///
/// Cara pakai:
/// ```dart
/// Stack(
///   children: [
///     const NexaBackground(),     // Background layer
///     // ... konten halaman
///   ],
/// )
/// ```
///
/// Atau gunakan helper [NexaBackground.wrap] untuk langsung membungkus widget:
/// ```dart
/// NexaBackground.wrap(child: YourContent())
/// ```
library;

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NexaBackground extends StatelessWidget {
  const NexaBackground({
    super.key,
    this.showTopBlob = true,
    this.showBottomBlob = true,
    this.topBlobOffset,
    this.opacity = 1.0,
  });

  /// Tampilkan blob dekoratif di area atas.
  final bool showTopBlob;

  /// Tampilkan blob dekoratif di area bawah.
  final bool showBottomBlob;

  /// Offset posisi blob atas (opsional).
  final Offset? topBlobOffset;

  /// Opacity keseluruhan background dekorasi.
  final double opacity;

  /// Helper: membungkus child dengan background atmosferik dalam Stack.
  static Widget wrap({
    required Widget child,
    bool showTopBlob = true,
    bool showBottomBlob = true,
    double opacity = 1.0,
  }) {
    return Stack(
      children: [
        NexaBackground(
          showTopBlob: showTopBlob,
          showBottomBlob: showBottomBlob,
          opacity: opacity,
        ),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Opacity(
      opacity: opacity,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // ─── Blob Atas Kanan ──────────────────────
            // Lingkaran gradient hijau besar di pojok kanan atas.
            // Memberikan kesan pencahayaan datang dari sudut.
            if (showTopBlob)
              Positioned(
                top: topBlobOffset?.dy ?? -(size.height * 0.12),
                right: topBlobOffset?.dx ?? -(size.width * 0.3),
                child: Container(
                  width: size.width * 0.85,
                  height: size.width * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.gradientGreen,
                        AppColors.gradientDarkGreen,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),

            // ─── Blob Bawah Kiri ─────────────────────
            // Blob kedua di pojok kiri bawah, lebih kecil dan olive.
            // Memberikan kedalaman dan variasi warna.
            if (showBottomBlob)
              Positioned(
                bottom: -(size.height * 0.1),
                left: -(size.width * 0.25),
                child: Container(
                  width: size.width * 0.7,
                  height: size.width * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.gradientOlive,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
