/// Model dan data terpusat untuk profil pengguna aplikasi NEXA.
///
/// Menyimpan data in-memory (tanpa database) sesuai ketentuan tugas UTS:
/// - Nama Lengkap
/// - NIM / NRP
/// - Program Studi
/// - Tempat & Tanggal Lahir
/// - Jenis Kelamin
/// - Alamat, Email, No. Telepon
/// - Hobi
/// - Foto Profil (File dari Kamera atau Galeri)
///
/// Menggunakan [ValueNotifier] agar perubahan data (seperti ganti foto atau nama)
/// langsung terdeteksi dan memperbarui tampilan di Splash Screen, Dashboard,
/// dan Halaman Biodata secara reaktif.
library;

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';

class UserProfile {
  UserProfile._(); // Private constructor

  // ─── Data In-Memory ────────────────────────────────────
  static String name = AppInfo.ownerName;
  static String nim = AppInfo.ownerNim;
  static String prodi = AppInfo.ownerProdi;
  static String birthPlace = 'Bandung';
  static DateTime birthDate = DateTime(2006, 1, 31);
  static String gender = 'Laki-laki';
  static String address = 'Jln. Laswi, Baleendah, Bandung, Jawa Barat';
  static String email = 'bagas.adigia@mhs.itenas.ac.id';
  static String phone = '0858-5207-3211';
  static String hobby = 'Mobile App Development, UI/UX Design, Gaming';

  /// File foto profil yang telah diambil dari kamera atau dipilih dari galeri.
  static File? profilePhoto;

  // ─── Reactive Notifiers ────────────────────────────────
  /// Notifier untuk perubahan foto profil
  static final ValueNotifier<File?> photoNotifier = ValueNotifier<File?>(null);

  /// Notifier untuk data biodata (nama, nim, prodi)
  static final ValueNotifier<int> updateNotifier = ValueNotifier<int>(0);

  /// Memperbarui foto profil
  static void setPhoto(File photo) {
    profilePhoto = photo;
    photoNotifier.value = photo;
    notifyUpdate();
  }

  /// Menghapus / reset foto profil
  static void clearPhoto() {
    profilePhoto = null;
    photoNotifier.value = null;
    notifyUpdate();
  }

  /// Memberitahu seluruh listener bahwa data profil telah diperbarui
  static void notifyUpdate() {
    updateNotifier.value++;
  }
}
