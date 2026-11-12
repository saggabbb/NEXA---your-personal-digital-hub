/// Entry point aplikasi NEXA.
///
/// File ini hanya bertugas menjalankan aplikasi.
/// Seluruh konfigurasi MaterialApp ada di [NexaApp] (app/app.dart).
///
/// Kenapa dipisahkan? Agar main.dart tetap bersih dan singkat.
/// Ini adalah praktik standar dalam arsitektur Flutter yang modular.
library;

import 'package:flutter/material.dart';
import 'app/app.dart';

void main() {
  // Memastikan binding Flutter sudah diinisialisasi.
  // Diperlukan jika ada operasi async sebelum runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Jalankan aplikasi NEXA
  runApp(const NexaApp());
}
