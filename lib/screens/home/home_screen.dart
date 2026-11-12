/// Halaman Dashboard / Beranda Utama aplikasi NEXA.
///
/// Merupakan tampilan awal setelah Splash Screen yang menyajikan:
/// 1. Header Profil: Nama pemilik, NRP, prodi, dan foto profil
/// 2. Hero Banner: NEXA Digital Hub Overview
/// 3. Menu Interaktif: 5 menu utama (Biodata, Kontak, Kalkulator, Cuaca, Berita)
///    yang dapat ditekan langsung untuk berpindah ke halaman terkait.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexa_card.dart';
import '../../data/user_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onSelectTab,
  });

  /// Callback untuk berpindah ke tab tertentu pada Dashboard utama.
  /// 1: Biodata, 2: Kontak, 3: Kalkulator, 4: Cuaca, 5: Berita
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Profil Pemilik ────────────────────────
          _buildUserHeader(),

          const SizedBox(height: AppSpacing.lg),

          // ─── Hero Banner: Digital Hub Overview ────────────
          _buildHeroBanner(),

          const SizedBox(height: AppSpacing.lg),

          // ─── Section Title: Menu Utama ───────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MENU UTAMA',
                style: AppTextStyles.label.copyWith(
                  letterSpacing: 1.5,
                  fontSize: 13,
                ),
              ),
              Text(
                '5 Layanan Tersedia',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ─── Daftar 5 Menu Interaktif ────────────────────
          _buildMenuGrid(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Section Builders
  // ═══════════════════════════════════════════════════════

  /// Header sambutan dengan nama pengguna dan avatar
  Widget _buildUserHeader() {
    return ValueListenableBuilder<int>(
      valueListenable: UserProfile.updateNotifier,
      builder: (context, _, child) {
        final photo = UserProfile.profilePhoto;

        return NexaCard.glass(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Avatar dengan Neon Glow
              GestureDetector(
                onTap: () => onSelectTab(1), // Buka biodata
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.neonGreen,
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGlow,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: photo != null
                        ? Image.file(
                            photo,
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                          )
                        : Image.asset(
                            'assets/images/profile.jpg',
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.surface,
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 30,
                                  color: AppColors.neonGreen,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Teks Sambutan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'ONLINE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neonGreen,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      UserProfile.name,
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NRP: ${UserProfile.nim} • ${UserProfile.prodi}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neonGreen,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Ikon Panah ke Profil
              IconButton(
                onPressed: () => onSelectTab(1),
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.neonGreen,
                ),
                tooltip: 'Lihat Biodata',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Banner informasi aplikasi
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.neonGreen.withValues(alpha: 0.3),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceLight,
            AppColors.deepGreen.withValues(alpha: 0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGlowSubtle,
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.hub_outlined,
                      size: 14,
                      color: AppColors.neonGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'NEXA HUB',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neonGreen,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'UTS Pemrograman Mobile',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppInfo.tagline,
            style: AppTextStyles.heading2.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Solusi multifungsi personal yang mengintegrasikan biodata, kontak, kalkulator digital, prakiraan cuaca, dan portal berita dalam satu aplikasi futuristik.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  /// Grid 5 Menu Utama
  Widget _buildMenuGrid() {
    final List<_MenuItemData> menuItems = [
      _MenuItemData(
        tabIndex: 1,
        title: 'Biodata Pribadi',
        description: 'Profil lengkap mahasiswa, form isian, foto kamera & galeri',
        icon: Icons.badge_outlined,
        badgeText: 'Fase 4',
        accentColor: AppColors.neonGreen,
      ),
      _MenuItemData(
        tabIndex: 2,
        title: 'Daftar Kontak',
        description: 'Direktori 15+ kontak dummy dengan fitur pencarian instan',
        icon: Icons.contacts_outlined,
        badgeText: 'Fase 5',
        accentColor: const Color(0xFF69F0AE),
      ),
      _MenuItemData(
        tabIndex: 3,
        title: 'Kalkulator Digital',
        description: 'Perhitungan matematika, kuadrat, dan akar kuadrat akurat',
        icon: Icons.calculate_outlined,
        badgeText: 'Fase 6',
        accentColor: const Color(0xFF40C4FF),
      ),
      _MenuItemData(
        tabIndex: 4,
        title: 'Informasi Cuaca',
        description: 'Pantau suhu, kelembapan, angin, dan animasi cuaca interaktif',
        icon: Icons.cloud_outlined,
        badgeText: 'Fase 7',
        accentColor: const Color(0xFFFFD740),
      ),
      _MenuItemData(
        tabIndex: 5,
        title: 'Portal Berita',
        description: 'Isu publik, transparansi kebijakan, dan informasi terkini',
        icon: Icons.newspaper_outlined,
        badgeText: 'Fase 8',
        accentColor: const Color(0xFFFF8A80),
      ),
    ];

    return Column(
      children: menuItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildMenuCard(item),
        );
      }).toList(),
    );
  }

  /// Satu Card Menu Interaktif
  Widget _buildMenuCard(_MenuItemData item) {
    return NexaCard(
      onTap: () => onSelectTab(item.tabIndex),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: item.accentColor.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Icon(
              item.icon,
              size: 24,
              color: item.accentColor,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Teks Judul & Deskripsi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.border,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        item.badgeText,
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Action Arrow
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: item.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemData {
  const _MenuItemData({
    required this.tabIndex,
    required this.title,
    required this.description,
    required this.icon,
    required this.badgeText,
    required this.accentColor,
  });

  final int tabIndex;
  final String title;
  final String description;
  final IconData icon;
  final String badgeText;
  final Color accentColor;
}
