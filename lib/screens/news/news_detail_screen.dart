/// Halaman Detail Berita — Aplikasi NEXA.
///
/// Menampilkan isi berita lengkap, metadata artikel,
/// dan navigasi kembali ke daftar berita.
/// Dilengkapi penanda eksplisit bahwa konten adalah simulasi akademik UTS.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexa_card.dart';
import '../../core/widgets/nexa_background.dart';
import '../../models/news_model.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key, required this.article});

  final NewsArticle article;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _isBookmarked = false;

  void _toggleBookmark() {
    setState(() => _isBookmarked = !_isBookmarked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Artikel disimpan ke daftar bacaan simulasi'
              : 'Artikel dihapus dari daftar bacaan',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.neonGreen, width: 0.8),
        ),
      ),
    );
  }

  void _shareArticle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Tautan artikel simulasi disalin ke clipboard',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.neonGreen, width: 0.8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          article.category.label,
          style: AppTextStyles.heading3.copyWith(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppColors.neonGreen : AppColors.textSecondary,
            ),
            tooltip: 'Simpan',
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
            tooltip: 'Bagikan',
            onPressed: _shareArticle,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 0.5,
            color: AppColors.border,
          ),
        ),
      ),
      body: Stack(
        children: [
          const NexaBackground(opacity: 0.4),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Hero Visual Banner ───────────────────────
                _buildHeroBanner(article),
                const SizedBox(height: AppSpacing.lg),

                // ─── Kategori & Waktu Baca ────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                            color: AppColors.neonGreen.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(article.category.icon,
                              size: 14, color: AppColors.neonGreen),
                          const SizedBox(width: 6),
                          Text(
                            article.category.label.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.neonGreen,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '•  ${article.readTimeMinutes} menit baca',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // ─── Judul Berita ─────────────────────────────
                Text(
                  article.title,
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 22,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // ─── Bar Informasi Penulis & Tanggal ─────────
                _buildAuthorMeta(article),
                const SizedBox(height: AppSpacing.lg),

                // ─── Lead / Ringkasan Utama ───────────────────
                NexaCard(
                  borderColor: AppColors.neonGreen.withValues(alpha: 0.3),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 3,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.neonGreen,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          article.summary,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ─── Paragraf Isi Berita ──────────────────────
                ...article.content.map(
                  (paragraph) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      paragraph,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.7,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ─── Disclaimer Konten Simulasi UTS ───────────
                _buildAcademicDisclaimer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Banner visual artikel dengan estetika neon futuristik.
  Widget _buildHeroBanner(NewsArticle article) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.neonGreen.withValues(alpha: 0.25),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceLight,
            AppColors.surface,
            AppColors.neonGreen.withValues(alpha: 0.08),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGlowSubtle,
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pattern dekoratif abstrak di pojok
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              article.iconData,
              size: 150,
              color: AppColors.neonGreen.withValues(alpha: 0.06),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                    border: Border.all(
                      color: AppColors.neonGreen.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGlow,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Icon(
                    article.iconData,
                    size: 38,
                    color: AppColors.neonGreen,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'NEXA PUBLIC INSIGHT',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neonGreenLight,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Metadata info penulis dan tanggal artikel.
  Widget _buildAuthorMeta(NewsArticle article) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceLight,
            child: const Icon(
              Icons.person_pin_rounded,
              size: 18,
              color: AppColors.neonGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.author,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  article.publishedDate,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              'Simulasi',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Banner penegasan konten akademik agar sesuai etika dan ketentuan tugas.
  Widget _buildAcademicDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.textTertiary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Artikel ini adalah materi studi kasus simulasi dalam rangka Evaluasi UTS Pemrograman Mobile. Konten tidak mencerminkan tuduhan faktual terhadap institusi atau perseorangan nyata.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
