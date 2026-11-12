/// Route definitions untuk aplikasi NEXA.
///
/// Mendefinisikan nama-nama route dan mapping ke halaman.
/// Menggunakan named routes agar navigasi konsisten
/// dan mudah di-maintain di satu tempat.
///
/// Alur navigasi:
/// splash (/) → dashboard (/dashboard) → [sub-pages]
library;

import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

class AppRoutes {
  AppRoutes._();

  // ─── Route Names ───────────────────────────────────────
  /// Splash screen — halaman pertama yang muncul
  static const String splash = '/';

  /// Dashboard — halaman utama dengan Bottom Navigation
  static const String dashboard = '/dashboard';

  // ─── Route Map ─────────────────────────────────────────
  /// Mapping nama route ke widget builder.
  /// MaterialApp akan menggunakan map ini untuk navigasi.
  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        dashboard: (context) => const DashboardScreen(),
      };

  // ─── Initial Route ─────────────────────────────────────
  /// Route pertama yang dibuka — splash screen
  static String get initialRoute => splash;
}
