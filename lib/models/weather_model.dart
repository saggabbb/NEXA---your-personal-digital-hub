/// Model data cuaca untuk aplikasi NEXA.
///
/// [WeatherCondition] — enum kondisi cuaca (cerah, berawan, dll).
/// [WeatherData] — data cuaca satu titik waktu (suhu, kelembaban, dll).
/// [WeatherForecast] — ramalan cuaca harian (pagi, siang, malam).
library;

/// Jenis kondisi cuaca yang didukung.
///
/// Setiap kondisi memiliki:
/// - [label] — nama tampil berbahasa Indonesia
/// - [icon] — emoji ikon bawaan
enum WeatherCondition {
  cerah('Cerah', '☀️'),
  cerahBerawan('Cerah Berawan', '🌤️'),
  berawan('Berawan', '☁️'),
  mendung('Mendung', '🌥️'),
  hujanRingan('Hujan Ringan', '🌦️'),
  hujan('Hujan', '🌧️'),
  hujanLebat('Hujan Lebat', '⛈️'),
  badai('Badai', '🌩️');

  const WeatherCondition(this.label, this.icon);

  /// Nama kondisi cuaca dalam Bahasa Indonesia.
  final String label;

  /// Emoji representasi kondisi.
  final String icon;
}

/// Data cuaca untuk satu titik waktu.
///
/// Berisi informasi suhu, kelembaban, kecepatan angin, dsb.
/// Data bersifat statis (tidak dari API), hanya dari variabel.
class WeatherData {
  const WeatherData({
    required this.condition,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
    required this.visibility,
    this.chanceOfRain = 0,
  });

  /// Kondisi cuaca (cerah, berawan, hujan, dll).
  final WeatherCondition condition;

  /// Suhu dalam derajat Celsius.
  final double temperature;

  /// Suhu terasa (heat index) dalam derajat Celsius.
  final double feelsLike;

  /// Kelembaban relatif (0–100%).
  final int humidity;

  /// Kecepatan angin dalam km/jam.
  final double windSpeed;

  /// UV Index (0–11+).
  final int uvIndex;

  /// Jarak pandang dalam km.
  final double visibility;

  /// Probabilitas hujan (0–100%).
  final int chanceOfRain;
}

/// Ramalan cuaca harian lengkap.
///
/// Berisi cuaca utama (siang hari), suhu min/max,
/// dan prakiraan per waktu (pagi, siang, malam).
class WeatherForecast {
  const WeatherForecast({
    required this.dayName,
    required this.date,
    required this.main,
    required this.tempMin,
    required this.tempMax,
    this.morning,
    this.afternoon,
    this.night,
  });

  /// Nama hari (Senin, Selasa, dst).
  final String dayName;

  /// Tanggal (format: "12 Nov").
  final String date;

  /// Data cuaca utama (biasanya cuaca siang hari).
  final WeatherData main;

  /// Suhu minimum hari itu.
  final double tempMin;

  /// Suhu maksimum hari itu.
  final double tempMax;

  /// Cuaca pagi (opsional).
  final WeatherData? morning;

  /// Cuaca siang (opsional).
  final WeatherData? afternoon;

  /// Cuaca malam (opsional).
  final WeatherData? night;
}
