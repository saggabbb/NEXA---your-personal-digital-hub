/// Service penyimpanan lokal (Local Persistence) untuk aplikasi NEXA.
///
/// Menggunakan [SharedPreferences] dan [path_provider] untuk memastikan
/// semua data pengguna (foto profil, biodata lengkap, artikel yang disimpan,
/// kontak favorit, dan riwayat kalkulator) tetap tersimpan
/// secara permanen dan TIDAK TERESET saat aplikasi di-restart.
library;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../data/user_profile.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  StorageService._();

  static late SharedPreferences _prefs;
  static bool _isInitialized = false;

  // ─── Keys ──────────────────────────────────────────────
  static const String _keyName = 'profile_name';
  static const String _keyNim = 'profile_nim';
  static const String _keyProdi = 'profile_prodi';
  static const String _keyBirthPlace = 'profile_birth_place';
  static const String _keyBirthDate = 'profile_birth_date';
  static const String _keyGender = 'profile_gender';
  static const String _keyAddress = 'profile_address';
  static const String _keyEmail = 'profile_email';
  static const String _keyPhone = 'profile_phone';
  static const String _keyHobby = 'profile_hobby';
  static const String _keyPhotoPath = 'profile_photo_path';
  static const String _keyBookmarks = 'bookmarked_news_ids';
  static const String _keyFavorites = 'favorite_contact_ids';
  static const String _keyCalcHistory = 'calculator_history';

  // ─── Inisialisasi Awal ─────────────────────────────────
  /// Dipanggil sebelum [runApp] di main.dart.
  static Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // ─── USER PROFILE / BIODATA ────────────────────────────

  /// Memuat data profil dari storage ke [UserProfile].
  static Future<void> loadUserProfile() async {
    if (!_isInitialized) await init();

    UserProfile.name = _prefs.getString(_keyName) ?? AppInfo.ownerName;
    UserProfile.nim = _prefs.getString(_keyNim) ?? AppInfo.ownerNim;
    UserProfile.prodi = _prefs.getString(_keyProdi) ?? AppInfo.ownerProdi;
    UserProfile.birthPlace = _prefs.getString(_keyBirthPlace) ?? 'Bandung';

    final birthDateStr = _prefs.getString(_keyBirthDate);
    if (birthDateStr != null) {
      UserProfile.birthDate = DateTime.tryParse(birthDateStr) ?? DateTime(2004, 5, 20);
    } else {
      UserProfile.birthDate = DateTime(2004, 5, 20);
    }

    UserProfile.gender = _prefs.getString(_keyGender) ?? 'Laki-laki';
    UserProfile.address = _prefs.getString(_keyAddress) ??
        'Jl. Telekomunikasi No. 1, Terusan Buahbatu, Bandung';
    UserProfile.email = _prefs.getString(_keyEmail) ?? 'bagas.ravael@student.uinsgd.ac.id';
    UserProfile.phone = _prefs.getString(_keyPhone) ?? '0812-3456-7890';
    UserProfile.hobby = _prefs.getString(_keyHobby) ??
        'Mobile App Development, UI/UX Design, Gaming';

    // Muat foto profil permanen
    final savedPhotoPath = _prefs.getString(_keyPhotoPath);
    if (savedPhotoPath != null) {
      final photoFile = File(savedPhotoPath);
      if (await photoFile.exists()) {
        UserProfile.profilePhoto = photoFile;
        UserProfile.photoNotifier.value = photoFile;
      } else {
        UserProfile.profilePhoto = null;
        UserProfile.photoNotifier.value = null;
      }
    }

    UserProfile.notifyUpdate();
  }

  /// Menyimpan seluruh data profil ke storage.
  static Future<void> saveUserProfile({
    required String name,
    required String nim,
    required String prodi,
    required String birthPlace,
    required DateTime birthDate,
    required String gender,
    required String address,
    required String email,
    required String phone,
    required String hobby,
  }) async {
    if (!_isInitialized) await init();

    await _prefs.setString(_keyName, name);
    await _prefs.setString(_keyNim, nim);
    await _prefs.setString(_keyProdi, prodi);
    await _prefs.setString(_keyBirthPlace, birthPlace);
    await _prefs.setString(_keyBirthDate, birthDate.toIso8601String());
    await _prefs.setString(_keyGender, gender);
    await _prefs.setString(_keyAddress, address);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyPhone, phone);
    await _prefs.setString(_keyHobby, hobby);

    // Update state di UserProfile
    UserProfile.name = name;
    UserProfile.nim = nim;
    UserProfile.prodi = prodi;
    UserProfile.birthPlace = birthPlace;
    UserProfile.birthDate = birthDate;
    UserProfile.gender = gender;
    UserProfile.address = address;
    UserProfile.email = email;
    UserProfile.phone = phone;
    UserProfile.hobby = hobby;

    UserProfile.notifyUpdate();
  }

  /// Menyimpan foto profil secara permanen ke direktori aplikasi.
  /// Foto di-copy dari temporary cache kamera/galeri ke persistent storage
  /// sehingga aman dari pembersihan cache HP.
  static Future<File> saveProfilePhoto(File sourceFile) async {
    if (!_isInitialized) await init();

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final extension = sourceFile.path.split('.').last;
      final targetPath = '${appDir.path}/profile_avatar.$extension';

      // Salin file ke internal storage permanen
      final persistentFile = await sourceFile.copy(targetPath);

      // Simpan path permanen di SharedPreferences
      await _prefs.setString(_keyPhotoPath, persistentFile.path);

      UserProfile.setPhoto(persistentFile);
      return persistentFile;
    } catch (e) {
      if (kDebugMode) {
        print('Gagal menyimpan foto permanen: $e');
      }
      // Fallback: simpan path asli jika gagal copy
      await _prefs.setString(_keyPhotoPath, sourceFile.path);
      UserProfile.setPhoto(sourceFile);
      return sourceFile;
    }
  }

  /// Reset / hapus foto profil
  static Future<void> clearProfilePhoto() async {
    if (!_isInitialized) await init();

    final savedPhotoPath = _prefs.getString(_keyPhotoPath);
    if (savedPhotoPath != null) {
      final file = File(savedPhotoPath);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {}
      }
      await _prefs.remove(_keyPhotoPath);
    }
    UserProfile.clearPhoto();
  }

  // ─── BOOKMARKS BERITA ──────────────────────────────────

  /// Muat daftar ID artikel yang dibookmark.
  static Set<String> getBookmarkedNewsIds() {
    if (!_isInitialized) return {};
    final list = _prefs.getStringList(_keyBookmarks) ?? [];
    return list.toSet();
  }

  /// Toggle bookmark untuk satu ID berita.
  static Future<bool> toggleNewsBookmark(String articleId) async {
    if (!_isInitialized) await init();

    final current = getBookmarkedNewsIds();
    final isBookmarked = current.contains(articleId);

    if (isBookmarked) {
      current.remove(articleId);
    } else {
      current.add(articleId);
    }

    await _prefs.setStringList(_keyBookmarks, current.toList());
    return !isBookmarked;
  }

  // ─── KONTAK FAVORIT ────────────────────────────────────

  /// Muat daftar ID kontak favorit.
  static Set<String> getFavoriteContactIds() {
    if (!_isInitialized) return {};
    final list = _prefs.getStringList(_keyFavorites) ?? [];
    return list.toSet();
  }

  /// Toggle favorit kontak.
  static Future<bool> toggleContactFavorite(String contactId) async {
    if (!_isInitialized) await init();

    final current = getFavoriteContactIds();
    final isFav = current.contains(contactId);

    if (isFav) {
      current.remove(contactId);
    } else {
      current.add(contactId);
    }

    await _prefs.setStringList(_keyFavorites, current.toList());
    return !isFav;
  }

  // ─── RIWAYAT KALKULATOR ────────────────────────────────

  /// Muat riwayat perhitungan terakhir.
  static List<String> getCalculatorHistory() {
    if (!_isInitialized) return [];
    return _prefs.getStringList(_keyCalcHistory) ?? [];
  }

  /// Tambah satu riwayat perhitungan (maksimal 20 item).
  static Future<void> addCalculatorHistory(String calculation) async {
    if (!_isInitialized) await init();

    final current = getCalculatorHistory();
    current.insert(0, calculation);
    if (current.length > 20) {
      current.removeLast();
    }
    await _prefs.setStringList(_keyCalcHistory, current);
  }

  /// Hapus seluruh riwayat kalkulator.
  static Future<void> clearCalculatorHistory() async {
    if (!_isInitialized) await init();
    await _prefs.remove(_keyCalcHistory);
  }
}
