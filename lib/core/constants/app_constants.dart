/// Konstanta global aplikasi NEXA.
///
/// File ini menyimpan nilai-nilai tetap yang digunakan di seluruh aplikasi,
/// seperti spacing, border radius, durasi animasi, dan informasi pemilik.
/// Dengan memusatkan konstanta, kita memastikan konsistensi visual
/// dan memudahkan perubahan di satu tempat.
library;

/// Informasi identitas aplikasi.
class AppInfo {
  AppInfo._(); // Private constructor — mencegah instansiasi

  static const String appName = 'NEXA';
  static const String tagline = 'Your Personal Digital Hub';
  static const String version = '1.0.0';

  // Identitas pemilik
  static const String ownerName = 'Bagas Adigia Ravael';
  static const String ownerNim = '152024147';
  static const String ownerProdi = 'Informatika';
}

/// Konstanta spacing (jarak antar elemen).
/// Menggunakan kelipatan 4px untuk konsistensi (4-point grid system).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Konstanta border radius.
class AppRadius {
  AppRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 100.0; // Untuk bentuk pill/circle
}

/// Konstanta durasi animasi (dalam milidetik).
class AppDuration {
  AppDuration._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(seconds: 5);
}

/// Konstanta ukuran ikon.
class AppIconSize {
  AppIconSize._();

  static const double sm = 20.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
}
