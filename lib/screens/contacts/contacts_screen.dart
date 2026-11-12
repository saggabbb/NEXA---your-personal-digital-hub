/// Halaman Daftar Kontak Telepon — Aplikasi NEXA.
///
/// Memenuhi ketentuan dosen:
/// - Daftar telepon statis (16 kontak, melebihi syarat minimal 15).
/// - Layout teks & Circle Image Avatar dengan desain Dark Futuristic Neon.
/// - Fitur pencarian instan (Search Bar) & Filter Kategori.
/// - Aksi interaktif panggil nomor / kirim pesan dummy dengan SnackBar feedback.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexa_card.dart';
import '../../models/contact_model.dart';
import '../../data/contact_data.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<String> _categories = const [
    'Semua',
    'Dosen',
    'Teman Kuliah',
    'Rekan Proyek',
    'Kampus & Jurusan',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Memfilter kontak berdasarkan query pencarian dan kategori yang dipilih
  List<Contact> get _filteredContacts {
    return ContactData.contacts.where((contact) {
      final matchesSearch = contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.phone.replaceAll('-', '').contains(_searchQuery.replaceAll('-', ''));

      if (!matchesSearch) return false;

      if (_selectedCategory == 'Semua') return true;
      if (_selectedCategory == 'Dosen') {
        return contact.category.contains('Dosen');
      }
      return contact.category == _selectedCategory;
    }).toList();
  }

  void _showContactDetailSheet(Contact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Circle Avatar Besar dengan Glow
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceLight,
                  border: Border.all(color: AppColors.neonGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGlow,
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    contact.initials,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neonGreen,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Nama & Kategori
              Text(
                contact.name,
                style: AppTextStyles.heading3.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: AppColors.neonGreen.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  contact.category,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neonGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Detail Item Telepon & Email
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Nomor Telepon',
                      value: contact.phone,
                    ),
                    const Divider(color: AppColors.border, height: 16),
                    _buildDetailRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: contact.email,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Action Buttons: Telepon & WhatsApp
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showActionToast('Memanggil ${contact.phone}...');
                      },
                      icon: const Icon(Icons.call_rounded, size: 18),
                      label: const Text('Panggil'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showActionToast('Membuka chat ke ${contact.name}...');
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                      label: const Text('Pesan'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.neonGreen),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  void _showActionToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.neonGreen, width: 0.8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _filteredContacts;

    return Column(
      children: [
        // ─── Header & Search Bar ───────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: _searchQuery.isNotEmpty ? AppColors.neonGreen : AppColors.border,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  cursorColor: AppColors.neonGreen,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau nomor telepon...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textTertiary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Filter Kategori Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() => _selectedCategory = cat);
                        },
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.neonGreen.withValues(alpha: 0.18),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? AppColors.neonGreen : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.neonGreen : AppColors.border,
                          width: 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // ─── Jumlah Kontak Ditemukan ────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DIREKTORI KONTAK (${contacts.length})',
                style: AppTextStyles.label.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Total: ${ContactData.contacts.length} Kontak',
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ),

        // ─── List Kontak ────────────────────────────────────
        Expanded(
          child: contacts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    AppSpacing.xl + 20,
                  ),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _buildContactTile(contact),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildContactTile(Contact contact) {
    return NexaCard(
      onTap: () => _showContactDetailSheet(contact),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      child: Row(
        children: [
          // Circle Avatar Beraksen Neon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
              border: Border.all(
                color: AppColors.neonGreen.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonGlowSubtle,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neonGreen,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Teks Nama, Nomor, & Kategori
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 14.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.phone_rounded, size: 12, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      contact.phone,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppColors.border,
                      width: 0.6,
                    ),
                  ),
                  child: Text(
                    contact.category,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: AppColors.neonGreen.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Panggil Cepat
          IconButton(
            icon: const Icon(Icons.phone_forwarded_rounded, size: 18),
            color: AppColors.neonGreen,
            tooltip: 'Hubungi',
            onPressed: () => _showActionToast('Menghubungi ${contact.name}...'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Kontak Tidak Ditemukan',
            style: AppTextStyles.heading3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Tidak ada kontak yang cocok dengan kata kunci "$_searchQuery"',
            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
