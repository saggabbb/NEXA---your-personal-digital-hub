/// Utility functions untuk aplikasi NEXA.
///
/// Berisi helper yang dipakai di berbagai tempat,
/// seperti format tanggal, validasi, dll.
library;

class AppHelpers {
  AppHelpers._();

  /// Format angka dengan pemisah ribuan.
  /// Contoh: 1000000 → "1.000.000"
  static String formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (match) => '${match[1]}.',
          );
    }
    return number.toStringAsFixed(2);
  }

  /// Mengecek apakah string merupakan angka valid.
  static bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }
}
