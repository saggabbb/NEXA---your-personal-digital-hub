/// Halaman Berita Publik — Aplikasi NEXA.
///
/// Menyajikan informasi isu publik dan tata kelola pemerintahan:
/// - Pencarian artikel interaktif (berdasarkan judul & ringkasan)
/// - Filter kategori chip horizontal (Semua, Pemerintahan, Kebijakan, dll)
/// - Kartu sorotan utama (Featured Headline) dengan neon glow
/// - Daftar kartu berita berulang dengan thumbnail samping & metadata
/// - Navigasi ke [NewsDetailScreen] untuk membaca artikel penuh
/// - Penanda konten demonstrasi akademik
///
/// State management: StatefulWidget
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexa_card.dart';
import '../../models/news_model.dart';
import '../../data/news_data.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  NewsCategory _selectedCategory = NewsCategory.semua;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Filter berita berdasarkan pencarian dan kategori terpilih.
  List<NewsArticle> get _filteredArticles {
    return dummyNewsArticles.where((article) {
      final matchesCategory = _selectedCategory == NewsCategory.semua ||
          article.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openDetail(NewsArticle article) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NewsDetailScreen(article: article),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final articles = _filteredArticles;
    final headlineArticle = dummyNewsArticles.firstWhere(
      (a) => a.isTrending,
      orElse: () => dummyNewsArticles.first,
    );

    return FadeTransition(
      opacity: _fadeIn,
      child: Column(
        children: [
          // ─── Search Bar & Category Chips ─────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: _buildSearchBar(),
          ),

          const SizedBox(height: AppSpacing.sm),
          _buildCategoryChips(),
          const SizedBox(height: AppSpacing.sm),

          // ─── List Konten Berita ──────────────────────────
          Expanded(
            child: articles.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    itemCount: articles.length + (_searchQuery.isEmpty && _selectedCategory == NewsCategory.semua ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Jika mode default (tidak cari & kategori semua), tampilkan headline card di paling atas
                      final showHeadline =
                          _searchQuery.isEmpty && _selectedCategory == NewsCategory.semua;

                      if (showHeadline && index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _buildHeadlineCard(headlineArticle),
                        );
                      }

                      final articleIndex = showHeadline ? index - 1 : index;
                      final article = articles[articleIndex];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _buildArticleListItem(article),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // UI Sub-components
  // ═══════════════════════════════════════════════════════

  /// Kotak pencarian berita
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        onChanged: (val) => setState(() => _searchQuery = val.trim()),
        decoration: InputDecoration(
          hintText: 'Cari isu, kebijakan, atau topik...',
          hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.neonGreen, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  /// Filter kategori horizontal chips
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: NewsCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final cat = NewsCategory.values[index];
          final isSelected = _selectedCategory == cat;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = cat),
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.neonGreen
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.neonGreen
                        : AppColors.border,
                    width: 0.8,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.neonGlowSubtle,
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.icon,
                      size: 14,
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected
                            ? AppColors.textOnPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Headline Card untuk berita trending teratas
  Widget _buildHeadlineCard(NewsArticle article) {
    return NexaCard.glass(
      hasGlow: true,
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => _openDetail(article),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row tag sorotan & waktu baca
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 12, color: AppColors.textOnPrimary),
                    const SizedBox(width: 4),
                    Text(
                      'SOROTAN UTAMA',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                article.category.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.neonGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${article.readTimeMinutes} min',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Judul Headline
          Text(
            article.title,
            style: AppTextStyles.heading3.copyWith(
              fontSize: 16,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),

          // Ringkasan
          Text(
            article.summary,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Footer info sumber simulasi
          Row(
            children: [
              Icon(Icons.verified_outlined, size: 12, color: AppColors.neonGreen.withValues(alpha: 0.8)),
              const SizedBox(width: 4),
              Text(
                'Konten Demonstrasi Akademik',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Text(
                article.publishedDate,
                style: AppTextStyles.caption.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Item daftar berita reguler (Thumbnail di kiri, Teks di kanan)
  Widget _buildArticleListItem(NewsArticle article) {
    return NexaCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      onTap: () => _openDetail(article),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Thumbnail Box di Kiri ───
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.neonGreen.withValues(alpha: 0.2),
                width: 0.8,
              ),
            ),
            child: Center(
              child: Icon(
                article.iconData,
                color: AppColors.neonGreen,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // ─── Informasi Berita di Kanan ───
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori Tag
                Row(
                  children: [
                    Text(
                      article.category.label.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neonGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 9.5,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      article.publishedDate,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                // Judul Berita yang Menonjol
                Text(
                  article.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Waktu baca & Penulis
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 11, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${article.readTimeMinutes} mnt baca',
                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        article.author,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// State kosong ketika pencarian tidak menemukan hasil
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.neonGreen.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tidak ada berita ditemukan',
            style: AppTextStyles.heading3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba ubah kata kunci atau ganti filter kategori',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
