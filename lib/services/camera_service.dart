/// Service kamera untuk aplikasi NEXA.
///
/// Menggunakan package image_picker untuk mengakses kamera HP.
/// Service ini membungkus image_picker agar lebih mudah digunakan
/// dan menangani error secara terpusat.
///
/// Cara pakai:
/// ```dart
/// final photo = await CameraService.takePhoto();
/// if (photo != null) {
///   // Gunakan photo.path untuk menampilkan gambar
/// }
/// ```
///
/// Catatan:
/// - Permission kamera sudah dideklarasikan di AndroidManifest.xml
/// - image_picker menangani permission dialog secara otomatis
/// - Foto disimpan di cache directory (tidak perlu permission storage)
library;

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraService {
  CameraService._();

  /// Instance ImagePicker (singleton pattern sederhana).
  static final ImagePicker _picker = ImagePicker();

  /// Ambil foto menggunakan kamera HP.
  ///
  /// Mengembalikan [File] jika berhasil, atau null jika:
  /// - Pengguna membatalkan pengambilan foto
  /// - Terjadi error (permission ditolak, kamera tidak tersedia, dll)
  ///
  /// Parameter:
  /// - [maxWidth]: Lebar maksimal foto (default 800px, hemat memori)
  /// - [maxHeight]: Tinggi maksimal foto (default 800px)
  /// - [quality]: Kualitas kompresi JPEG 0-100 (default 85)
  static Future<File?> takePhoto({
    double maxWidth = 800,
    double maxHeight = 800,
    int quality = 85,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
        preferredCameraDevice: CameraDevice.front, // Kamera depan (selfie)
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      // Error bisa terjadi karena:
      // - Permission ditolak
      // - Kamera tidak tersedia di emulator
      // - Error hardware
      return null;
    }
  }

  /// Ambil foto dari galeri (opsional, untuk fleksibilitas).
  static Future<File?> pickFromGallery({
    double maxWidth = 800,
    double maxHeight = 800,
    int quality = 85,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
