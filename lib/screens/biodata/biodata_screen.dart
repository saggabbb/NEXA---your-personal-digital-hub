/// Halaman Biodata — Profil Lengkap Pemilik Aplikasi NEXA.
///
/// Memenuhi seluruh kriteria spesifikasi UTS & arahan dosen:
/// 1. Tampilan profil teks dan image foto profil dengan desain futuristik modern.
/// 2. Pengambilan / pergantian foto profil langsung via Kamera HP dan Galeri HP.
/// 3. Komponen input lengkap:
///    - Text Field (Nama, Tempat Lahir, Alamat, Email, Telepon, Hobi)
///    - Dropdown Button (Program Studi)
///    - Radio Button (Jenis Kelamin)
///    - Date Picker / Calendar (Tanggal Lahir)
/// 4. Mode Edit dan Simpan in-memory tanpa database.
/// 5. Terintegrasi langsung dengan [UserProfile] sehingga foto dan identitas
///    tersinkronisasi ke Splash Screen dan Dashboard.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/nexa_card.dart';
import '../../services/camera_service.dart';
import '../../services/storage_service.dart';
import '../../data/user_profile.dart';

class BiodataScreen extends StatefulWidget {
  const BiodataScreen({super.key});

  @override
  State<BiodataScreen> createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen> {
  // ─── Mode Edit / Simpan ────────────────────────────────
  bool _isEditing = false;

  // ─── Form Controllers ──────────────────────────────────
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  late final TextEditingController _birthPlaceController;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _hobbyController;

  // ─── State Nilai Pilihan ───────────────────────────────
  late String _selectedProdi;
  late String _selectedGender;
  late DateTime _selectedDate;

  // ─── Dropdown & Radio Options ──────────────────────────
  final List<String> _prodiOptions = const [
    'Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Teknologi Informasi',
    'Data Science',
    'Teknik Elektro',
  ];

  final List<String> _genderOptions = const [
    'Laki-laki',
    'Perempuan',
  ];

  @override
  void initState() {
    super.initState();
    _loadFromUserProfile();
  }

  void _loadFromUserProfile() {
    _nameController = TextEditingController(text: UserProfile.name);
    _nimController = TextEditingController(text: UserProfile.nim);
    _birthPlaceController = TextEditingController(text: UserProfile.birthPlace);
    _addressController = TextEditingController(text: UserProfile.address);
    _emailController = TextEditingController(text: UserProfile.email);
    _phoneController = TextEditingController(text: UserProfile.phone);
    _hobbyController = TextEditingController(text: UserProfile.hobby);

    _selectedProdi = UserProfile.prodi;
    _selectedGender = UserProfile.gender;
    _selectedDate = UserProfile.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _birthPlaceController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _hobbyController.dispose();
    super.dispose();
  }

  // ─── Actions ───────────────────────────────────────────

  /// Buka dialog pemilihan foto: Kamera atau Galeri
  void _showPhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                'Perbarui Foto Profil',
                style: AppTextStyles.heading3.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 6),
              Text(
                'Gunakan kamera HP atau pilih dari galeri foto Anda',
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),

              const SizedBox(height: AppSpacing.lg),

              Row(
                children: [
                  // Opsi Kamera
                  Expanded(
                    child: _buildSourceOptionCard(
                      icon: Icons.camera_alt_rounded,
                      label: 'Kamera HP',
                      sublabel: 'Ambil langsung',
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromCamera();
                      },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  // Opsi Galeri
                  Expanded(
                    child: _buildSourceOptionCard(
                      icon: Icons.photo_library_rounded,
                      label: 'Galeri Foto',
                      sublabel: 'Pilih file',
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromGallery();
                      },
                    ),
                  ),
                ],
              ),

              if (UserProfile.profilePhoto != null) ...[
                const SizedBox(height: AppSpacing.md),
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await StorageService.clearProfilePhoto();
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                  label: const Text(
                    'Hapus Foto Kustom',
                    style: TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOptionCard({
    required IconData icon,
    required String label,
    required String sublabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.neonGreen, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  /// Ambil foto langsung dari Kamera HP
  Future<void> _pickFromCamera() async {
    final photo = await CameraService.takePhoto();
    if (photo != null) {
      await StorageService.saveProfilePhoto(photo);
      setState(() {});
      _showFeedbackSnackBar('Foto profil berhasil diambil & disimpan permanen!');
    }
  }

  /// Ambil foto dari Galeri HP
  Future<void> _pickFromGallery() async {
    final photo = await CameraService.pickFromGallery();
    if (photo != null) {
      await StorageService.saveProfilePhoto(photo);
      setState(() {});
      _showFeedbackSnackBar('Foto profil berhasil dipilih & disimpan permanen!');
    }
  }

  /// Buka Dialog Calendar / Date Picker dengan Dark Neon Theme
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.neonGreen,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  /// Simpan perubahan form ke StorageService & UserProfile
  Future<void> _saveChanges() async {
    await StorageService.saveUserProfile(
      name: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      prodi: _selectedProdi,
      birthPlace: _birthPlaceController.text.trim(),
      birthDate: _selectedDate,
      gender: _selectedGender,
      address: _addressController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      hobby: _hobbyController.text.trim(),
    );

    setState(() {
      _isEditing = false;
    });

    _showFeedbackSnackBar('Biodata berhasil disimpan secara permanen!');
  }

  void _showFeedbackSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: AppColors.neonGreen, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
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

  String _formatDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ─── Build ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            120, // Padding bawah agar tidak terhalang FAB
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─── 1. Header Profile & Avatar Card ──────
              _buildAvatarCard(),

              const SizedBox(height: AppSpacing.lg),

              // ─── 2. Data Akademik & Pribadi Card ──────
              _buildAcademicCard(),

              const SizedBox(height: AppSpacing.lg),

              // ─── 3. Informasi Kontak Card ────────────
              _buildContactCard(),

              const SizedBox(height: AppSpacing.lg),

              // ─── 4. Minat & Hobi Card ────────────────
              _buildHobbyCard(),
            ],
          ),
        ),

        // ─── Floating Action Button (Edit / Save) ──
        Positioned(
          bottom: AppSpacing.md,
          right: AppSpacing.md,
          child: _buildActionFab(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  // Card & Section Builders
  // ═══════════════════════════════════════════════════════

  /// Card Header dengan Avatar, Nama, dan Tombol Cepat Kamera/Galeri
  Widget _buildAvatarCard() {
    final photo = UserProfile.profilePhoto;

    return NexaCard.glass(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Avatar dengan Dual Neon Glow
          GestureDetector(
            onTap: _showPhotoSourceSheet,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.neonGreen,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGlow,
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: photo != null
                        ? Image.file(
                            photo,
                            fit: BoxFit.cover,
                            width: 110,
                            height: 110,
                          )
                        : Image.asset(
                            'assets/images/profile.jpg',
                            fit: BoxFit.cover,
                            width: 110,
                            height: 110,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.surface,
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 54,
                                  color: AppColors.neonGreen,
                                ),
                              );
                            },
                          ),
                  ),
                ),

                // Badge Kamera di pojok bawah kanan avatar
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.neonGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGlow,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Nama & NRP
          Text(
            UserProfile.name,
            style: AppTextStyles.heading2.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  'NRP: ${UserProfile.nim}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neonGreen,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Text(
                  UserProfile.prodi,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Tombol Cepat: Ambil Kamera & Pilih Galeri
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPhotoQuickButton(
                icon: Icons.camera_alt_rounded,
                label: 'Kamera HP',
                onTap: _pickFromCamera,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildPhotoQuickButton(
                icon: Icons.photo_library_rounded,
                label: 'Galeri',
                onTap: _pickFromGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoQuickButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: AppColors.neonGreen.withValues(alpha: 0.4),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.neonGreen),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.neonGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Card 1: Data Akademik & Pribadi
  Widget _buildAcademicCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('DATA AKADEMIK & PRIBADI'),
        const SizedBox(height: AppSpacing.sm),
        NexaCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _buildTextField(
                label: 'Nama Lengkap',
                controller: _nameController,
                icon: Icons.person_outline_rounded,
              ),
              _buildDivider(),
              _buildTextField(
                label: 'NIM / NRP',
                controller: _nimController,
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
              ),
              _buildDivider(),
              _buildDropdownField(),
              _buildDivider(),
              _buildTextField(
                label: 'Tempat Lahir',
                controller: _birthPlaceController,
                icon: Icons.location_city_rounded,
              ),
              _buildDivider(),
              _buildDateField(),
              _buildDivider(),
              _buildGenderField(),
            ],
          ),
        ),
      ],
    );
  }

  /// Card 2: Informasi Kontak
  Widget _buildContactCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('KONTAK & ALAMAT'),
        const SizedBox(height: AppSpacing.sm),
        NexaCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _buildTextField(
                label: 'Alamat Tempat Tinggal',
                controller: _addressController,
                icon: Icons.home_outlined,
                maxLines: 2,
              ),
              _buildDivider(),
              _buildTextField(
                label: 'Email Mahasiswa',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildDivider(),
              _buildTextField(
                label: 'Nomor WhatsApp / Telepon',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Card 3: Minat & Hobi
  Widget _buildHobbyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('MINAT & HOBI'),
        const SizedBox(height: AppSpacing.sm),
        NexaCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: _buildTextField(
            label: 'Hobi & Minat Keahlian',
            controller: _hobbyController,
            icon: Icons.interests_outlined,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  // Form Field Components
  // ═══════════════════════════════════════════════════════

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.border.withValues(alpha: 0.6),
      height: AppSpacing.lg,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: maxLines > 1 ? 4 : 0),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              size: 18,
              color: _isEditing ? AppColors.neonGreen : AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              _isEditing
                  ? TextField(
                      controller: controller,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                      ),
                      keyboardType: keyboardType,
                      maxLines: maxLines,
                      cursorColor: AppColors.neonGreen,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.sm,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(
                            color: AppColors.neonGreen,
                            width: 1,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      controller.text.isEmpty ? '-' : controller.text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            Icons.school_outlined,
            size: 18,
            color: _isEditing ? AppColors.neonGreen : AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Program Studi',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              _isEditing
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedProdi,
                        dropdownColor: AppColors.surface,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 14.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.neonGreen,
                          size: 20,
                        ),
                        items: _prodiOptions.map((prodi) {
                          return DropdownMenuItem(
                            value: prodi,
                            child: Text(prodi),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedProdi = value);
                          }
                        },
                      ),
                    )
                  : Text(
                      _selectedProdi,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: _isEditing ? AppColors.neonGreen : AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tanggal Lahir (Calendar)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              _isEditing
                  ? GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(_selectedDate),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 14.5,
                              ),
                            ),
                            const Icon(
                              Icons.edit_calendar_rounded,
                              size: 18,
                              color: AppColors.neonGreen,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(
                      _formatDate(_selectedDate),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            Icons.wc_outlined,
            size: 18,
            color: _isEditing ? AppColors.neonGreen : AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jenis Kelamin (Radio Button)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              _isEditing
                  ? Row(
                      children: _genderOptions.map((gender) {
                        final isSelected = _selectedGender == gender;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedGender = gender);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: gender == _genderOptions.first ? AppSpacing.sm : 0,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.neonGreen.withValues(alpha: 0.12)
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: isSelected ? AppColors.neonGreen : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: gender,
                                    groupValue: _selectedGender,
                                    activeColor: AppColors.neonGreen,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() => _selectedGender = value);
                                      }
                                    },
                                  ),
                                  Text(
                                    gender,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected
                                          ? AppColors.neonGreen
                                          : AppColors.textSecondary,
                                      fontWeight:
                                          isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Text(
                      _selectedGender,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  /// Floating Action Button Dinamis (Edit Mode vs Save Mode)
  Widget _buildActionFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isEditing) ...[
          FloatingActionButton.extended(
            heroTag: 'save_biodata',
            onPressed: _saveChanges,
            backgroundColor: AppColors.neonGreen,
            elevation: 4,
            icon: const Icon(Icons.check_rounded, color: AppColors.textOnPrimary),
            label: const Text(
              'Simpan',
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],

        FloatingActionButton(
          heroTag: 'toggle_edit_biodata',
          onPressed: () {
            setState(() {
              if (_isEditing) {
                // Batalkan perubahan, reload dari model
                _loadFromUserProfile();
                _isEditing = false;
              } else {
                _isEditing = true;
              }
            });
          },
          backgroundColor: _isEditing ? AppColors.surface : AppColors.neonGreen,
          elevation: 4,
          child: Icon(
            _isEditing ? Icons.close_rounded : Icons.edit_rounded,
            color: _isEditing ? AppColors.textPrimary : AppColors.textOnPrimary,
          ),
        ),
      ],
    );
  }
}
