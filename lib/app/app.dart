/// Root widget aplikasi NEXA.
///
/// File ini berisi MaterialApp — widget paling atas dalam tree.
/// Konfigurasi:
/// - Theme: Dark mode futuristik (hitam + hijau neon)
/// - Routes: Splash → Dashboard
/// - Debug banner: Dinonaktifkan
///
/// Dipisahkan dari main.dart agar entry point tetap bersih
/// dan konfigurasi MaterialApp terkelola di satu tempat.
library;

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import 'routes.dart';

class NexaApp extends StatelessWidget {
  const NexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ─── App Identity ──────────────────────────────────
      title: AppInfo.appName,
      debugShowCheckedModeBanner: false,

      // ─── Theme ─────────────────────────────────────────
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // ─── Navigation ────────────────────────────────────
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,

      // ─── Page Transition ───────────────────────────────
      // Custom transition: fade saat berpindah dari splash ke dashboard
      onGenerateRoute: (settings) {
        // Jika route sudah ada di routes map, gunakan custom transition
        final builder = AppRoutes.routes[settings.name];
        if (builder != null) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                builder(context),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Fade transition yang halus
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
            transitionDuration: AppDuration.normal,
          );
        }
        return null;
      },
    );
  }
}
