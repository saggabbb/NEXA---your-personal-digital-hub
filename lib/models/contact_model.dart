/// Model representasi data kontak telepon pada aplikasi NEXA.
library;

class Contact {
  final String id;
  final String name;
  final String phone;
  final String category; // contoh: 'Dosen', 'Mahasiswa', 'Laboratorium', 'Kerja'
  final String email;
  final String? avatarUrl;

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.category,
    required this.email,
    this.avatarUrl,
  });

  /// Mengambil inisial 2 huruf untuk ditampilkan pada CircleAvatar jika gambar tidak tersedia
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase() : 'C';
  }
}
