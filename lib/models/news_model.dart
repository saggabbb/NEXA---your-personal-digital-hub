/// Model data berita untuk aplikasi NEXA.
///
/// Menyimpan struktur informasi berita seputar isu publik,
/// kebijakan pemerintahan, transparansi, dan pelayanan masyarakat.
/// Seluruh data bersifat simulasi / konten demonstrasi untuk keperluan UTS.
library;

import 'package:flutter/material.dart';

/// Kategori isu publik & pemerintahan.
enum NewsCategory {
  semua('Semua', Icons.dashboard_outlined),
  pemerintahan('Pemerintahan', Icons.account_balance_outlined),
  kebijakanPublik('Kebijakan Publik', Icons.policy_outlined),
  korupsiTransparansi('Transparansi', Icons.shield_outlined),
  pelayananPublik('Pelayanan Publik', Icons.room_service_outlined),
  ekonomiAnggaran('Ekonomi & Anggaran', Icons.monetization_on_outlined),
  infrastruktur('Infrastruktur', Icons.construction_outlined),
  pengawasan('Pengawasan', Icons.visibility_outlined);

  const NewsCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Model artikel berita lengkap.
class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.author,
    required this.source,
    required this.publishedDate,
    required this.readTimeMinutes,
    this.isTrending = false,
    this.iconData = Icons.article_rounded,
  });

  /// ID unik berita.
  final String id;

  /// Judul berita yang menonjol dan informatif.
  final String title;

  /// Ringkasan singkat berita (lead paragraph).
  final String summary;

  /// Isi lengkap berita (multi-paragraf) untuk halaman detail.
  final List<String> content;

  /// Kategori isu publik.
  final NewsCategory category;

  /// Nama penulis / tim redaksi simulasi.
  final String author;

  /// Sumber media atau label demonstrasi.
  final String source;

  /// Tanggal publikasi (e.g., "11 Nov 2026").
  final String publishedDate;

  /// Perkiraan waktu membaca dalam menit.
  final int readTimeMinutes;

  /// Apakah berita ini disorot sebagai trending / headline.
  final bool isTrending;

  /// Ikon representasi visual thumbnail berita.
  final IconData iconData;
}
