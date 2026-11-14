/// Halaman Cuaca — Aplikasi NEXA.
///
/// Menampilkan prakiraan cuaca statis untuk kota Bandung.
/// Data tidak berasal dari API, melainkan hard-coded di [weather_data.dart].
///
/// Fitur visual:
/// - Kartu cuaca utama dengan suhu besar & animasi ikon
/// - Detail cuaca (kelembaban, angin, UV index, visibility)
/// - Prakiraan per jam (horizontal scroll)
/// - Prakiraan 7 hari (list vertikal)
/// - Ikon cuaca custom menggunakan [CustomPainter]
/// - Animasi transisi masuk dan shimmer effect
///
/// State management: StatefulWidget + AnimationController
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexa_card.dart';
import '../../models/weather_model.dart';
import '../../data/weather_data.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  // ─── Animation Controllers ─────────────────────────────
  /// Animasi masuk keseluruhan halaman (fade + slide up).
  late final AnimationController _enterController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  /// Animasi rotasi ikon cuaca utama (rotation terus-menerus).
  late final AnimationController _iconPulseController;

  @override
  void initState() {
    super.initState();

    // Animasi masuk halaman
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOut,
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    ));

    // Animasi pulse ikon cuaca
    _iconPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Loop terus-menerus

    _enterController.forward();
  }

  @override
  void dispose() {
    _enterController.dispose();
    _iconPulseController.dispose();
    super.dispose();
  }

  // ─── Build ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            // ─── Header Lokasi ────────────────────────
            _buildLocationHeader(),
            const SizedBox(height: AppSpacing.md),

            // ─── Kartu Cuaca Utama ────────────────────
            _buildMainWeatherCard(),
            const SizedBox(height: AppSpacing.md),

            // ─── Detail Info (grid 2×2) ───────────────
            _buildDetailGrid(),
            const SizedBox(height: AppSpacing.lg),

            // ─── Prakiraan Per Jam ────────────────────
            _buildSectionTitle('Prakiraan Per Jam'),
            const SizedBox(height: AppSpacing.sm),
            _buildHourlyForecast(),
            const SizedBox(height: AppSpacing.lg),

            // ─── Prakiraan 7 Hari ─────────────────────
            _buildSectionTitle('Prakiraan 7 Hari'),
            const SizedBox(height: AppSpacing.sm),
            _buildWeeklyForecast(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Section Builders
  // ═══════════════════════════════════════════════════════

  /// Header lokasi: nama kota dan koordinat.
  Widget _buildLocationHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.neonGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            Icons.location_on_rounded,
            color: AppColors.neonGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${WeatherLocation.city}, ${WeatherLocation.province}',
                style: AppTextStyles.heading3,
              ),
              Text(
                WeatherLocation.timezone,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        // Badge "Statis"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            'Data Demo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  /// Kartu cuaca utama — suhu besar, kondisi, ikon animasi.
  Widget _buildMainWeatherCard() {
    return NexaCard.glass(
      hasGlow: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Kiri: Suhu & Kondisi ───
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Suhu utama
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${currentWeather.temperature.toInt()}',
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.w200,
                            color: AppColors.textPrimary,
                            height: 1.0,
                            letterSpacing: -2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '°C',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: AppColors.neonGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Kondisi cuaca
                    Text(
                      currentWeather.condition.label,
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.neonGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Terasa seperti
                    Text(
                      'Terasa ${currentWeather.feelsLike.toInt()}°C',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),

              // ─── Kanan: Ikon Cuaca Animasi ───
              AnimatedBuilder(
                animation: _iconPulseController,
                builder: (context, child) {
                  return _WeatherIcon(
                    condition: currentWeather.condition,
                    size: 100,
                    animationValue: _iconPulseController.value,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ─── Baris info ringkas ───
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniInfo(
                  Icons.water_drop_outlined,
                  '${currentWeather.humidity}%',
                  'Kelembaban',
                ),
                _buildDividerVertical(),
                _buildMiniInfo(
                  Icons.air_rounded,
                  '${currentWeather.windSpeed} km/h',
                  'Angin',
                ),
                _buildDividerVertical(),
                _buildMiniInfo(
                  Icons.umbrella_outlined,
                  '${currentWeather.chanceOfRain}%',
                  'Hujan',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Info kecil dalam kartu utama (ikon + nilai + label).
  Widget _buildMiniInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.neonGreen, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  /// Divider vertikal tipis.
  Widget _buildDividerVertical() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.border,
    );
  }

  /// Grid detail cuaca 2×2: UV, Visibility, Angin, Kelembaban.
  Widget _buildDetailGrid() {
    final items = [
      _DetailItem(
        icon: Icons.wb_sunny_outlined,
        label: 'UV Index',
        value: '${currentWeather.uvIndex}',
        subtitle: _uvLabel(currentWeather.uvIndex),
        color: _uvColor(currentWeather.uvIndex),
      ),
      _DetailItem(
        icon: Icons.visibility_outlined,
        label: 'Visibilitas',
        value: '${currentWeather.visibility} km',
        subtitle: currentWeather.visibility >= 10 ? 'Jernih' : 'Terbatas',
        color: AppColors.info,
      ),
      _DetailItem(
        icon: Icons.air_rounded,
        label: 'Angin',
        value: '${currentWeather.windSpeed} km/h',
        subtitle: _windLabel(currentWeather.windSpeed),
        color: AppColors.neonGreen,
      ),
      _DetailItem(
        icon: Icons.water_drop_rounded,
        label: 'Kelembaban',
        value: '${currentWeather.humidity}%',
        subtitle: currentWeather.humidity > 80 ? 'Lembab' : 'Normal',
        color: Colors.cyanAccent,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return NexaCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(item.icon, color: item.color, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                item.value,
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                item.subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: item.color.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Judul section dengan garis dekoratif.
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.neonGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: AppTextStyles.heading3),
      ],
    );
  }

  /// Prakiraan per jam — list horizontal.
  Widget _buildHourlyForecast() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyForecast.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final hour = hourlyForecast[index];
          // Highlight "sekarang" (index 3 = jam 12)
          final isNow = index == 3;

          return NexaCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            hasGlow: isNow,
            borderColor: isNow ? AppColors.neonGreen.withValues(alpha: 0.5) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  isNow ? 'Now' : hour.time,
                  style: AppTextStyles.caption.copyWith(
                    color: isNow ? AppColors.neonGreen : AppColors.textSecondary,
                    fontWeight: isNow ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                Text(
                  hour.condition.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                Text(
                  '${hour.temp.toInt()}°',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Prakiraan 7 hari — list vertikal.
  Widget _buildWeeklyForecast() {
    return NexaCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: weeklyForecast.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final isToday = index == 0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    // Hari
                    SizedBox(
                      width: 72,
                      child: Text(
                        isToday ? 'Hari Ini' : day.dayName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isToday
                              ? AppColors.neonGreen
                              : AppColors.textPrimary,
                          fontWeight:
                              isToday ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),

                    // Ikon cuaca
                    SizedBox(
                      width: 36,
                      child: Text(
                        day.main.condition.icon,
                        style: const TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Probabilitas hujan (jika > 0)
                    SizedBox(
                      width: 44,
                      child: day.main.chanceOfRain > 0
                          ? Row(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: 12,
                                  color: AppColors.info.withValues(alpha: 0.7),
                                ),
                                Text(
                                  '${day.main.chanceOfRain}%',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),

                    const Spacer(),

                    // Bar suhu visual
                    _buildTempBar(day.tempMin, day.tempMax),

                    const SizedBox(width: 8),

                    // Suhu min — max
                    SizedBox(
                      width: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${day.tempMin.toInt()}°',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const Text(' / ',
                              style: TextStyle(
                                  color: AppColors.textTertiary, fontSize: 12)),
                          Text(
                            '${day.tempMax.toInt()}°',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < weeklyForecast.length - 1)
                Divider(color: AppColors.divider, height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// Bar visual suhu (menunjukkan range min–max relatif terhadap 20°–40°).
  Widget _buildTempBar(double min, double max) {
    // Normalisasi ke range 20°–40° → 0.0–1.0
    const rangeStart = 20.0;
    const rangeEnd = 40.0;
    final normalMin = ((min - rangeStart) / (rangeEnd - rangeStart)).clamp(0.0, 1.0);
    final normalMax = ((max - rangeStart) / (rangeEnd - rangeStart)).clamp(0.0, 1.0);

    return SizedBox(
      width: 60,
      height: 4,
      child: CustomPaint(
        painter: _TempBarPainter(
          minFraction: normalMin,
          maxFraction: normalMax,
        ),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────

  /// Label deskripsi UV Index.
  String _uvLabel(int uv) {
    if (uv <= 2) return 'Rendah';
    if (uv <= 5) return 'Sedang';
    if (uv <= 7) return 'Tinggi';
    if (uv <= 10) return 'Sangat Tinggi';
    return 'Ekstrem';
  }

  /// Warna berdasarkan UV Index.
  Color _uvColor(int uv) {
    if (uv <= 2) return AppColors.success;
    if (uv <= 5) return AppColors.neonGreen;
    if (uv <= 7) return AppColors.warning;
    if (uv <= 10) return Colors.orange;
    return AppColors.error;
  }

  /// Label deskripsi kecepatan angin.
  String _windLabel(double speed) {
    if (speed < 10) return 'Sepoi-sepoi';
    if (speed < 20) return 'Sedang';
    if (speed < 30) return 'Kencang';
    return 'Sangat Kencang';
  }
}

// ═════════════════════════════════════════════════════════
// Custom Painters & Helper Widgets
// ═════════════════════════════════════════════════════════

/// Widget ikon cuaca custom berdasarkan kondisi.
///
/// Menggunakan [CustomPainter] untuk menggambar representasi visual
/// kondisi cuaca (matahari, awan, hujan, petir) dengan animasi.
class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({
    required this.condition,
    required this.size,
    required this.animationValue,
  });

  final WeatherCondition condition;
  final double size;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WeatherIconPainter(
          condition: condition,
          animationValue: animationValue,
        ),
      ),
    );
  }
}

/// Painter ikon cuaca.
///
/// Menggambar visual berbeda berdasarkan [WeatherCondition]:
/// - Cerah: Matahari dengan sinar berputar
/// - Berawan: Awan halus
/// - Hujan: Awan + tetes hujan
/// - Badai: Awan gelap + petir
class _WeatherIconPainter extends CustomPainter {
  _WeatherIconPainter({
    required this.condition,
    required this.animationValue,
  });

  final WeatherCondition condition;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (condition) {
      case WeatherCondition.cerah:
        _drawSun(canvas, center, size);
        break;
      case WeatherCondition.cerahBerawan:
        _drawSun(canvas, Offset(center.dx - 8, center.dy - 8), size * 0.7);
        _drawCloud(canvas, Offset(center.dx + 10, center.dy + 10), size * 0.6);
        break;
      case WeatherCondition.berawan:
      case WeatherCondition.mendung:
        _drawCloud(canvas, Offset(center.dx, center.dy - 4), size * 0.9);
        _drawCloud(canvas, Offset(center.dx + 8, center.dy + 8), size * 0.7,
            opacity: 0.5);
        break;
      case WeatherCondition.hujanRingan:
        _drawCloud(canvas, Offset(center.dx, center.dy - 8), size * 0.8);
        _drawRainDrops(canvas, center, size, count: 3);
        break;
      case WeatherCondition.hujan:
        _drawCloud(canvas, Offset(center.dx, center.dy - 10), size * 0.85);
        _drawRainDrops(canvas, center, size, count: 5);
        break;
      case WeatherCondition.hujanLebat:
        _drawCloud(canvas, Offset(center.dx, center.dy - 10), size * 0.9,
            isDark: true);
        _drawRainDrops(canvas, center, size, count: 7);
        break;
      case WeatherCondition.badai:
        _drawCloud(canvas, Offset(center.dx, center.dy - 12), size * 0.9,
            isDark: true);
        _drawLightning(canvas, center, size);
        _drawRainDrops(canvas, center, size, count: 4);
        break;
    }
  }

  /// Gambar matahari: lingkaran kuning + sinar berputar.
  void _drawSun(Canvas canvas, Offset center, Size size) {
    final radius = size.width * 0.22;

    // Glow di belakang matahari
    final glowPaint = Paint()
      ..color = const Color(0xFFB9FF66).withValues(alpha: 0.15 + animationValue * 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, radius * 2.2, glowPaint);

    // Sinar matahari (berputar berdasarkan animasi)
    final rayPaint = Paint()
      ..color = const Color(0xFFB9FF66).withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (animationValue * math.pi * 2);
      final innerRadius = radius * 1.3;
      final outerRadius = radius * 1.8;
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * innerRadius,
          center.dy + math.sin(angle) * innerRadius,
        ),
        Offset(
          center.dx + math.cos(angle) * outerRadius,
          center.dy + math.sin(angle) * outerRadius,
        ),
        rayPaint,
      );
    }

    // Lingkaran matahari utama
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4FF9E),
          const Color(0xFFB9FF66),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    canvas.drawCircle(center, radius, sunPaint);
  }

  /// Gambar awan menggunakan lingkaran-lingkaran yang overlap.
  void _drawCloud(Canvas canvas, Offset center, Size size,
      {double opacity = 0.9, bool isDark = false}) {
    final baseColor = isDark
        ? const Color(0xFF444444).withValues(alpha: opacity)
        : Colors.white.withValues(alpha: opacity * 0.85);

    final paint = Paint()..color = baseColor;
    final w = size.width * 0.5;
    final h = size.height * 0.2;

    // Awan terdiri dari 4 lingkaran yang tumpang-tindih
    canvas.drawCircle(Offset(center.dx - w * 0.3, center.dy + h * 0.2), w * 0.28, paint);
    canvas.drawCircle(Offset(center.dx - w * 0.05, center.dy - h * 0.2), w * 0.35, paint);
    canvas.drawCircle(Offset(center.dx + w * 0.2, center.dy - h * 0.1), w * 0.30, paint);
    canvas.drawCircle(Offset(center.dx + w * 0.35, center.dy + h * 0.2), w * 0.25, paint);

    // Badan awan (rounded rect)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + h * 0.3),
        width: w * 0.9,
        height: h * 0.8,
      ),
      Radius.circular(h * 0.4),
    );
    canvas.drawRRect(bodyRect, paint);
  }

  /// Gambar tetes hujan yang jatuh (posisi bergeser oleh animasi).
  void _drawRainDrops(Canvas canvas, Offset center, Size size,
      {required int count}) {
    final paint = Paint()
      ..color = const Color(0xFF40C4FF).withValues(alpha: 0.7)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final startY = center.dy + size.height * 0.05;
    final spacing = size.width * 0.12;
    final startX = center.dx - (count - 1) * spacing / 2;

    for (int i = 0; i < count; i++) {
      // Tiap tetes memiliki fase animasi berbeda
      final phase = (animationValue + i * 0.15) % 1.0;
      final x = startX + i * spacing;
      final y = startY + phase * size.height * 0.35;
      final length = size.height * 0.08;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + length),
        paint,
      );
    }
  }

  /// Gambar petir (zigzag kuning).
  void _drawLightning(Canvas canvas, Offset center, Size size) {
    // Flash effect (berkedip berdasarkan animasi)
    final flashOpacity = (math.sin(animationValue * math.pi * 6) > 0.7) ? 1.0 : 0.3;

    final paint = Paint()
      ..color = const Color(0xFFFFD740).withValues(alpha: flashOpacity)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final startX = center.dx + 2;
    final startY = center.dy - size.height * 0.05;

    path.moveTo(startX, startY);
    path.lineTo(startX - 6, startY + 12);
    path.lineTo(startX + 2, startY + 12);
    path.lineTo(startX - 4, startY + 26);

    canvas.drawPath(path, paint);

    // Glow di sekitar petir
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD740).withValues(alpha: flashOpacity * 0.3)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(_WeatherIconPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue ||
      condition != oldDelegate.condition;
}

/// Painter bar suhu pada prakiraan mingguan.
///
/// Menggambar garis gradien dari hijau (dingin) ke kuning (panas)
/// sesuai range suhu relatif 20°–40°.
class _TempBarPainter extends CustomPainter {
  _TempBarPainter({required this.minFraction, required this.maxFraction});

  final double minFraction;
  final double maxFraction;

  @override
  void paint(Canvas canvas, Size size) {
    // Background bar
    final bgPaint = Paint()
      ..color = AppColors.surfaceLight
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      bgPaint,
    );

    // Filled bar
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.neonGreen.withValues(alpha: 0.6),
          AppColors.neonGreen,
          AppColors.warning,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.height;

    final startX = size.width * minFraction;
    final endX = size.width * maxFraction;
    if (endX > startX) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_TempBarPainter oldDelegate) =>
      minFraction != oldDelegate.minFraction ||
      maxFraction != oldDelegate.maxFraction;
}

/// Data model helper untuk grid detail cuaca.
class _DetailItem {
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;
}
