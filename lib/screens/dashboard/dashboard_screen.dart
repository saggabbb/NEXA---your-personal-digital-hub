/// Dashboard Shell — Halaman Navigasi Utama Aplikasi NEXA.
///
/// Mengatur navigasi terpadu yang terdiri dari 6 menu:
/// 0. Beranda (Dashboard Hub berisikan menu-menu yang tersedia)
/// 1. Biodata (Informasi pribadi, foto profil kamera/galeri, form input)
/// 2. Kontak (Direktori 15+ kontak dummy)
/// 3. Kalkulator (Kalkulator digital & operasi matematika)
/// 4. Cuaca (Prakiraan cuaca interaktif)
/// 5. Berita (Portal berita pemerintahan & isu publik)
///
/// Tampilan awal setelah Splash Screen adalah **Beranda (Tab 0)**.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/nexa_background.dart';
import '../home/home_screen.dart';
import '../biodata/biodata_screen.dart';
import '../contacts/contacts_screen.dart';
import '../calculator/calculator_screen.dart';
import '../weather/weather_screen.dart';
import '../news/news_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Index tab aktif. 0 = Beranda / Dashboard Hub (Tampilan Awal).
  int _currentIndex = 0;

  void _switchTab(int index) {
    if (index >= 0 && index < 6) {
      setState(() => _currentIndex = index);
    }
  }

  /// Konfigurasi 6 tab navigasi
  static const List<_TabItemConfig> _tabConfigs = [
    _TabItemConfig(
      label: 'Beranda',
      title: 'NEXA Hub',
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
    ),
    _TabItemConfig(
      label: 'Biodata',
      title: 'Biodata Pribadi',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
    _TabItemConfig(
      label: 'Kontak',
      title: 'Daftar Kontak',
      icon: Icons.contacts_outlined,
      activeIcon: Icons.contacts_rounded,
    ),
    _TabItemConfig(
      label: 'Kalkulator',
      title: 'Kalkulator Digital',
      icon: Icons.calculate_outlined,
      activeIcon: Icons.calculate_rounded,
    ),
    _TabItemConfig(
      label: 'Cuaca',
      title: 'Informasi Cuaca',
      icon: Icons.cloud_outlined,
      activeIcon: Icons.cloud_rounded,
    ),
    _TabItemConfig(
      label: 'Berita',
      title: 'Portal Berita',
      icon: Icons.newspaper_outlined,
      activeIcon: Icons.newspaper_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      // ─── AppBar ────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentIndex == 0) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.neonGreen,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              _tabConfigs[_currentIndex].title,
              style: AppTextStyles.heading3.copyWith(
                letterSpacing: 0.8,
                fontSize: 18,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.neonGreen.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),

      // ─── Body dengan IndexedStack ───────────────────────
      body: Stack(
        children: [
          // Background atmosferik konsisten
          const NexaBackground(opacity: 0.45),

          IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(onSelectTab: _switchTab),
              const BiodataScreen(),
              const ContactsScreen(),
              const CalculatorScreen(),
              const WeatherScreen(),
              const NewsScreen(),
            ],
          ),
        ],
      ),

      // ─── Bottom Navigation Bar ─────────────────────────
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBarBg,
        border: Border(
          top: BorderSide(
            color: AppColors.neonGreen.withValues(alpha: 0.12),
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabConfigs.length, (index) {
              final tab = _tabConfigs[index];
              final isActive = index == _currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _switchTab(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.neonGreen.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: isActive
                              ? BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.neonGreen.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                )
                              : null,
                          child: Icon(
                            isActive ? tab.activeIcon : tab.icon,
                            size: 20,
                            color: isActive ? AppColors.neonGreen : AppColors.navInactive,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive ? AppColors.neonGreen : AppColors.navInactive,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItemConfig {
  const _TabItemConfig({
    required this.label,
    required this.title,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final String title;
  final IconData icon;
  final IconData activeIcon;
}
