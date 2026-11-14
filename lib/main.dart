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
import 'services/storage_service.dart';

void main() async {
  // Memastikan binding Flutter sudah diinisialisasi.
  // Diperlukan jika ada operasi async sebelum runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi local persistence & muat profil tersimpan
  await StorageService.init();
  await StorageService.loadUserProfile();

  // Jalankan aplikasi NEXA
  runApp(const NexaApp());
}
