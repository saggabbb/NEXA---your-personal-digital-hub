/// Splash Screen aplikasi NEXA.
///
/// Menampilkan identitas lengkap aplikasi dan pemilik:
/// 1. Logo NEXA (hexagonal mark dengan neon glow)
/// 2. Teks "NEXA" dengan neon gradient
/// 3. Tagline "Your Personal Digital Hub"
/// 4. Foto profil pemilik (foto yang telah diset dari kamera/galeri atau default)
/// 5. Nama lengkap pemilik ("Bagas Adigia Ravael")
/// 6. NRP / NIM ("NRP: 152024147")
///
/// Durasi: Tepat 5 detik, kemudian berpindah ke Dashboard.
/// Desain: Dark Futuristic Neon dengan atmospheric background gradient.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexa_logo.dart';
import '../../data/user_profile.dart';
import '../../app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // ─── Animations ────────────────────────────────────────
  late final Animation<double> _bgGlowOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _photoScale;
  late final Animation<double> _photoOpacity;
  late final Animation<double> _identityOpacity;
  late final Animation<double> _identitySlide;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Controller untuk urutan animasi (3.5 detik durasi animasi masuk)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    // 1. Background Glow (0 - 1s)
    _bgGlowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
      ),
    );

    // 2. Logo Scale & Fade (0.3s - 1.4s)
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.08, 0.40, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.08, 0.35, curve: Curves.easeOut),
      ),
    );

    // 3. Title & Tagline (1.2s - 2.0s)
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.55, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<double>(begin: 18.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.58, curve: Curves.easeOutCubic),
      ),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.65, curve: Curves.easeOut),
      ),
    );

    // 4. Foto Profil Pemilik (1.8s - 2.6s)
    _photoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.75, curve: Curves.easeOutBack),
      ),
    );
    _photoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.70, curve: Curves.easeOut),
      ),
    );

    // 5. Nama & NRP Pemilik (2.2s - 3.0s)
    _identityOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 0.85, curve: Curves.easeOut),
      ),
    );
    _identitySlide = Tween<double>(begin: 14.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 0.88, curve: Curves.easeOutCubic),
      ),
    );

    // 6. Pulse effect untuk ring foto profil
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Mulai animasi
    _controller.forward();

    // Navigasi ke Dashboard setelah 5 detik
    Future.delayed(AppDuration.splash, () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              // ─── Atmospheric Glows ─────────────────────
              _buildBackgroundGlow(screenSize),

              // ─── Main Content ──────────────────────────
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 3),

                        // ── Logo NEXA ──────────────────
                        _buildLogo(),

                        const SizedBox(height: 20),

                        // ── Teks NEXA & Tagline ────────
                        _buildAppTitleAndTagline(),

                        const SizedBox(height: 36),

                        // ── Foto Profil Pemilik ────────
                        _buildProfilePhoto(),

                        const SizedBox(height: 16),

                        // ── Nama & NRP Pemilik ─────────
                        _buildOwnerIdentity(),

                        const Spacer(flex: 4),

                        // ── Footer Versi ───────────────
                        _buildFooter(),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Widget Builders
  // ═══════════════════════════════════════════════════════

  Widget _buildBackgroundGlow(Size screenSize) {
    return Opacity(
      opacity: _bgGlowOpacity.value,
      child: Stack(
        children: [
          Positioned(
            top: -(screenSize.height * 0.12),
            right: -(screenSize.width * 0.25),
            child: Container(
              width: screenSize.width * 0.85,
              height: screenSize.width * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonGreen.withValues(alpha: 0.12),
                    AppColors.darkGreen.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -(screenSize.height * 0.1),
            left: -(screenSize.width * 0.2),
            child: Container(
              width: screenSize.width * 0.7,
              height: screenSize.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3D6B1E).withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Opacity(
      opacity: _logoOpacity.value,
      child: Transform.scale(
        scale: _logoScale.value,
        child: const NexaLogo(
          size: 88,
          glowIntensity: 0.5,
        ),
      ),
    );
  }

  Widget _buildAppTitleAndTagline() {
    return Column(
      children: [
        Opacity(
          opacity: _titleOpacity.value,
          child: Transform.translate(
            offset: Offset(0, _titleSlide.value),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.neonGreen,
                  AppColors.neonGreenLight,
                  AppColors.neonGreen,
                ],
                stops: [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: const Text(
                'NEXA',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 10,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Opacity(
          opacity: _taglineOpacity.value,
          child: Text(
            AppInfo.tagline,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePhoto() {
    final photo = UserProfile.profilePhoto;

    return Opacity(
      opacity: _photoOpacity.value,
      child: Transform.scale(
        scale: _photoScale.value,
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.neonGreen.withValues(alpha: 0.8),
              width: 2.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGreen.withValues(
                  alpha: 0.25 * _pulseAnimation.value,
                ),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: photo != null
                ? Image.file(
                    photo,
                    fit: BoxFit.cover,
                    width: 96,
                    height: 96,
                  )
                : Image.asset(
                    'assets/images/profile.jpg',
                    fit: BoxFit.cover,
                    width: 96,
                    height: 96,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 46,
                          color: AppColors.neonGreen,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerIdentity() {
    return Opacity(
      opacity: _identityOpacity.value,
      child: Transform.translate(
        offset: Offset(0, _identitySlide.value),
        child: Column(
          children: [
            Text(
              UserProfile.name,
              style: AppTextStyles.heading3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: AppColors.neonGreen.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Text(
                'NRP: ${UserProfile.nim}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.neonGreen,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Opacity(
      opacity: _identityOpacity.value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonGreen,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Informatika • v${AppInfo.version}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
