/// Data cuaca statis untuk aplikasi NEXA.
///
/// Semua data di sini bersifat statis (hard-coded),
/// tidak memerlukan koneksi internet maupun API.
/// Data mensimulasikan prakiraan cuaca 7 hari untuk Surabaya.
library;

import '../models/weather_model.dart';

/// Lokasi yang ditampilkan.
class WeatherLocation {
  WeatherLocation._();

  static const String city = 'Surabaya';
  static const String province = 'Jawa Timur';
  static const String country = 'Indonesia';
  static const String timezone = 'WIB (UTC+7)';
  static const String coordinates = '7.2575° S, 112.7521° E';
}

/// Data cuaca hari ini (ditampilkan sebagai cuaca utama).
const WeatherData currentWeather = WeatherData(
  condition: WeatherCondition.cerahBerawan,
  temperature: 33,
  feelsLike: 36,
  humidity: 65,
  windSpeed: 12.5,
  uvIndex: 7,
  visibility: 10.0,
  chanceOfRain: 20,
);

/// Prakiraan cuaca per jam hari ini.
/// Digunakan untuk grafik atau list horizontal.
const List<HourlyWeather> hourlyForecast = [
  HourlyWeather(time: '06:00', condition: WeatherCondition.mendung, temp: 26),
  HourlyWeather(time: '08:00', condition: WeatherCondition.cerahBerawan, temp: 28),
  HourlyWeather(time: '10:00', condition: WeatherCondition.cerah, temp: 31),
  HourlyWeather(time: '12:00', condition: WeatherCondition.cerah, temp: 33),
  HourlyWeather(time: '14:00', condition: WeatherCondition.cerahBerawan, temp: 34),
  HourlyWeather(time: '16:00', condition: WeatherCondition.berawan, temp: 32),
  HourlyWeather(time: '18:00', condition: WeatherCondition.mendung, temp: 29),
  HourlyWeather(time: '20:00', condition: WeatherCondition.hujanRingan, temp: 27),
  HourlyWeather(time: '22:00', condition: WeatherCondition.berawan, temp: 26),
  HourlyWeather(time: '00:00', condition: WeatherCondition.mendung, temp: 25),
];

/// Model sederhana untuk prakiraan per jam.
class HourlyWeather {
  const HourlyWeather({
    required this.time,
    required this.condition,
    required this.temp,
  });

  final String time;
  final WeatherCondition condition;
  final double temp;
}

/// Prakiraan cuaca 7 hari ke depan.
const List<WeatherForecast> weeklyForecast = [
  WeatherForecast(
    dayName: 'Senin',
    date: '11 Nov',
    main: WeatherData(
      condition: WeatherCondition.cerahBerawan,
      temperature: 33,
      feelsLike: 36,
      humidity: 65,
      windSpeed: 12.5,
      uvIndex: 7,
      visibility: 10.0,
      chanceOfRain: 20,
    ),
    tempMin: 25,
    tempMax: 34,
  ),
  WeatherForecast(
    dayName: 'Selasa',
    date: '12 Nov',
    main: WeatherData(
      condition: WeatherCondition.cerah,
      temperature: 35,
      feelsLike: 38,
      humidity: 55,
      windSpeed: 8.0,
      uvIndex: 9,
      visibility: 12.0,
      chanceOfRain: 5,
    ),
    tempMin: 26,
    tempMax: 35,
  ),
  WeatherForecast(
    dayName: 'Rabu',
    date: '13 Nov',
    main: WeatherData(
      condition: WeatherCondition.berawan,
      temperature: 31,
      feelsLike: 33,
      humidity: 70,
      windSpeed: 15.0,
      uvIndex: 5,
      visibility: 8.0,
      chanceOfRain: 35,
    ),
    tempMin: 24,
    tempMax: 32,
  ),
  WeatherForecast(
    dayName: 'Kamis',
    date: '14 Nov',
    main: WeatherData(
      condition: WeatherCondition.hujan,
      temperature: 28,
      feelsLike: 30,
      humidity: 85,
      windSpeed: 20.0,
      uvIndex: 3,
      visibility: 5.0,
      chanceOfRain: 80,
    ),
    tempMin: 23,
    tempMax: 29,
  ),
  WeatherForecast(
    dayName: 'Jumat',
    date: '15 Nov',
    main: WeatherData(
      condition: WeatherCondition.hujanLebat,
      temperature: 26,
      feelsLike: 28,
      humidity: 90,
      windSpeed: 25.0,
      uvIndex: 2,
      visibility: 3.0,
      chanceOfRain: 95,
    ),
    tempMin: 22,
    tempMax: 27,
  ),
  WeatherForecast(
    dayName: 'Sabtu',
    date: '16 Nov',
    main: WeatherData(
      condition: WeatherCondition.mendung,
      temperature: 29,
      feelsLike: 31,
      humidity: 75,
      windSpeed: 14.0,
      uvIndex: 4,
      visibility: 7.0,
      chanceOfRain: 45,
    ),
    tempMin: 24,
    tempMax: 30,
  ),
  WeatherForecast(
    dayName: 'Minggu',
    date: '17 Nov',
    main: WeatherData(
      condition: WeatherCondition.badai,
      temperature: 25,
      feelsLike: 27,
      humidity: 92,
      windSpeed: 35.0,
      uvIndex: 1,
      visibility: 2.0,
      chanceOfRain: 98,
    ),
    tempMin: 21,
    tempMax: 26,
  ),
];
