/// Logo orisinal NEXA — hexagonal geometric mark.
///
/// Logo NEXA berbentuk hexagon (segi enam) yang melambangkan
/// konektivitas dan "hub" digital. Menggunakan CustomPainter
/// untuk menggambar bentuk geometris dengan garis hijau neon.
///
/// Desain:
/// - Hexagon luar dengan garis hijau neon
/// - Huruf abstrak "N" di dalam hexagon menggunakan garis diagonal
/// - Glow effect halus di sekitar logo
///
/// Cara pakai:
/// ```dart
/// NexaLogo(size: 80)
/// ```
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NexaLogo extends StatelessWidget {
  const NexaLogo({
    super.key,
    this.size = 80,
    this.glowIntensity = 0.4,
  });

  /// Ukuran logo (width = height).
  final double size;

  /// Intensitas glow (0.0 - 1.0).
  final double glowIntensity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Glow effect di belakang logo
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withValues(alpha: glowIntensity * 0.5),
            blurRadius: size * 0.5,
            spreadRadius: size * 0.05,
          ),
          BoxShadow(
            color: AppColors.neonGreen.withValues(alpha: glowIntensity * 0.2),
            blurRadius: size * 0.8,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _NexaLogoPainter(glowIntensity: glowIntensity),
      ),
    );
  }
}

/// CustomPainter yang menggambar logo NEXA.
///
/// Struktur gambar:
/// 1. Hexagon luar (outline hijau neon)
/// 2. Garis diagonal membentuk huruf "N" abstrak di dalam
/// 3. Titik-titik kecil di vertex hexagon untuk detail
class _NexaLogoPainter extends CustomPainter {
  _NexaLogoPainter({required this.glowIntensity});

  final double glowIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42; // Radius hexagon
    final innerRadius = radius * 0.55; // Radius inner untuk "N"

    // ─── Paint: Garis Hexagon ────────────────────────
    final hexPaint = Paint()
      ..color = AppColors.neonGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ─── Paint: Inner "N" ────────────────────────────
    final innerPaint = Paint()
      ..color = AppColors.neonGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03
      ..strokeCap = StrokeCap.round;

    // ─── Paint: Titik aksen ──────────────────────────
    final dotPaint = Paint()
      ..color = AppColors.neonGreen
      ..style = PaintingStyle.fill;

    // ─── Gambar Hexagon ──────────────────────────────
    // Hexagon digambar dari 6 titik dengan jarak sudut 60°.
    // Dimulai dari atas (offset -90° agar vertex pertama di atas).
    final hexPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        hexPath.moveTo(x, y);
      } else {
        hexPath.lineTo(x, y);
      }
    }
    hexPath.close();
    canvas.drawPath(hexPath, hexPaint);

    // ─── Gambar "N" Abstrak di Dalam ─────────────────
    // Huruf N dibentuk dari 3 garis:
    // 1. Garis vertikal kiri
    // 2. Garis diagonal dari kiri-atas ke kanan-bawah
    // 3. Garis vertikal kanan

    final nTop = center.dy - innerRadius;
    final nBottom = center.dy + innerRadius;
    final nLeft = center.dx - innerRadius * 0.5;
    final nRight = center.dx + innerRadius * 0.5;

    // Garis kiri (bawah ke atas)
    canvas.drawLine(
      Offset(nLeft, nBottom),
      Offset(nLeft, nTop),
      innerPaint,
    );

    // Garis diagonal (kiri-atas ke kanan-bawah)
    canvas.drawLine(
      Offset(nLeft, nTop),
      Offset(nRight, nBottom),
      innerPaint,
    );

    // Garis kanan (bawah ke atas)
    canvas.drawLine(
      Offset(nRight, nBottom),
      Offset(nRight, nTop),
      innerPaint,
    );

    // ─── Titik Aksen di Vertex Atas ──────────────────
    // Titik kecil di puncak hexagon untuk detail visual
    final topAngle = -math.pi / 2;
    final topX = center.dx + radius * math.cos(topAngle);
    final topY = center.dy + radius * math.sin(topAngle);
    canvas.drawCircle(
      Offset(topX, topY),
      size.width * 0.02,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _NexaLogoPainter oldDelegate) {
    return oldDelegate.glowIntensity != glowIntensity;
  }
}
