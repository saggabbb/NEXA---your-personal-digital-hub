/// Data berita statis / simulasi untuk aplikasi NEXA.
///
/// PERHATIAN:
/// Seluruh isi berita di bawah ini merupakan KONTEN DEMONSTRASI AKADEMIK
/// untuk keperluan evaluasi Ujian Tengah Semester (UTS) Pemrograman Mobile.
/// Berita tidak menggambarkan peristiwa faktual spesifik terhadap individu nyata,
/// melainkan mengangkat studi kasus dan simulasi kebijakan publik kontemporer.
library;

import 'package:flutter/material.dart';
import '../models/news_model.dart';

/// Label sumber default untuk menandai konten demonstrasi.
const String kDemoSourceLabel = 'NEXA Public News (Simulasi Akademik)';

/// Daftar artikel berita publik terverifikasi simulasi.
final List<NewsArticle> dummyNewsArticles = [
  // 1. Kebijakan Publik (Headline / Trending)
  const NewsArticle(
    id: 'news-01',
    title: 'Transformasi Satu Data Indonesia: Standardisasi Interoperabilitas Antar Lembaga Dipercepat',
    summary:
        'Kementerian Komunikasi dan Informatika bersama Bappenas merumuskan pedoman integrasi API nasional guna menyatukan ribuan basis data sektoral kementerian ke dalam arsitektur data tunggal.',
    content: [
      'Pemerintah menargetkan percepatan program integrasi Satu Data Indonesia menyusul evaluasi efektivitas tata kelola birokrasi digital tahun 2026. Selama ini, fragmentasi data lintas instansi masih menjadi hambatan utama dalam validasi penerima bantuan sosial, perencanaan tata ruang, hingga perizinan investasi daerah.',
      'Melalui standardisasi arsitektur interoperabilitas berbasis API terbuka yang aman, kementerian dan lembaga negara diwajibkan menyelaraskan metadata dokumen. Langkah ini diproyeksikan menghemat anggaran belanja pengadaan server fisik sektoral hingga puluhan triliun rupiah.',
      'Para pakar tata kelola teknologi informasi menyambut baik langkah ini, seraya menekankan urgensi perlindungan data pribadi dan kehandalan enkripsi demi mencegah kebocoran data sensitif masyarakat.',
    ],
    category: NewsCategory.kebijakanPublik,
    author: 'Tim Riset Kebijakan Publik',
    source: kDemoSourceLabel,
    publishedDate: '11 Nov 2026',
    readTimeMinutes: 4,
    isTrending: true,
    iconData: Icons.hub_rounded,
  ),

  // 2. Korupsi & Transparansi
  const NewsArticle(
    id: 'news-02',
    title: 'Digitalisasi E-Procurement 4.0: Audit Real-Time Anggaran Proyek Strategis Nasional',
    summary:
        'Penerapan sistem audit algoritmik berbasis machine learning mulai diujicobakan pada sistem pengadaan barang dan jasa pemerintah untuk mendeteksi transaksi anomali secara dini.',
    content: [
      'Badan Pengawasan Keuangan dan Lembaga Kebijakan Pengadaan Barang/Jasa Pemerintah (LKPP) meluncurkan modul pemantauan real-time yang memindai rantai penawaran lelang tender publik secara otomatis.',
      'Sistem cerdas ini memetakan hubungan afiliasi antara vendor tender, mendeteksi pola persekongkolan harga, serta menandai dokumen penawaran yang terindikasi diduplikasi. Setiap anomali akan langsung menghasilkan peringatan risiko (risk alert) sebelum kontrak kerja disahkan.',
      'Langkah preventif ini diharapkan memutus celah gratifikasi serta mengoptimalkan efisiensi penyerapan APBN maupun APBD di berbagai penjuru tanah air.',
    ],
    category: NewsCategory.korupsiTransparansi,
    author: 'Divisi Investigasi & Tata Kelola',
    source: kDemoSourceLabel,
    publishedDate: '10 Nov 2026',
    readTimeMinutes: 5,
    isTrending: true,
    iconData: Icons.security_rounded,
  ),

  // 3. Pelayanan Publik
  const NewsArticle(
    id: 'news-03',
    title: 'Integrasi Mal Pelayanan Publik Digital Mempercepat Penerbitan Dokumen Kependudukan Jadi 15 Menit',
    summary:
        'Portal administrasi kependudukan terpadu berhasil memangkas proses perpanjangan KTP-el, kartu keluarga, dan akta kelahiran tanpa antrean loket fisik di 42 kabupaten/kota percontohan.',
    content: [
      'Program Mal Pelayanan Publik (MPP) Berbasis Digital terus memperluas jangkauan pelayanannya. Dengan sistem identitas kependudukan digital (IKD) yang terautentikasi biometrik wajah, warga kini dapat mengurus seluruh dokumen sipil langsung dari perangkat ponsel pintar.',
      'Setelah dokumen diverifikasi secara digital dalam hitungan menit, berkas digital bertanda tangan elektronik tersertifikasi (BSrE) dapat langsung diunduh secara sah tanpa harus datang dan mengantre di kantor Dispendukcapil.',
      'Masyarakat mengapresiasi terobosan ini karena dinilai meniadakan praktik percaloan serta menghadirkan kesetaraan akses layanan publik yang cepat, transparan, dan inklusif.',
    ],
    category: NewsCategory.pelayananPublik,
    author: 'Redaksi Pelayanan Warga',
    source: kDemoSourceLabel,
    publishedDate: '09 Nov 2026',
    readTimeMinutes: 3,
    iconData: Icons.badge_rounded,
  ),

  // 4. Ekonomi & Anggaran
  const NewsArticle(
    id: 'news-04',
    title: 'Evaluasi APBN Kuartal IV: Alokasi Subsidi Energi Tepat Sasaran Capai Efisiensi Signifikan',
    summary:
        'Kementerian Keuangan melaporkan transisi penyaluran subsidi tertutup via barcode digital berhasil menjaga stabilitas fiskal serta menjamin pasokan energi bagi kelompok masyarakat prasejahtera.',
    content: [
      'Realisasi anggaran belanja subsidi energi pada tahun anggaran berjalan menunjukkan tren yang semakin sehat dan akuntabel. Data terpadu kependudukan yang terus dimutakhirkan mampu memfilter jutaan transaksi agar subsidi BBM dan gas tabung benar-benar dinikmati oleh rumah tangga berhak.',
      'Sisa ruang fiskal dari efisiensi subsidi tersebut dialokasikan kembali ke sektor produktif, terutama stimulus pembiayaan modal kerja UMKM daerah dan insentif penguatan rantai pasok pangan lokal.',
      'Badan Anggaran DPR menggarisbawahi pentingnya mempertahankan disiplin fiskal ini agar ketahanan ekonomi nasional tetap kokoh menghadapi ketidakpastian pasar global.',
    ],
    category: NewsCategory.ekonomiAnggaran,
    author: 'Desk Ekonomi & Fiskal',
    source: kDemoSourceLabel,
    publishedDate: '08 Nov 2026',
    readTimeMinutes: 4,
    iconData: Icons.analytics_rounded,
  ),

  // 5. Infrastruktur
  const NewsArticle(
    id: 'news-05',
    title: 'Jaringan Palapa Ring Integrasi Hubungkan 1.200 Sekolah Daerah 3T ke Internet Berkecepatan Tinggi',
    summary:
        'Penyelesaian tulang punggung serat optik bawah laut dan BTS satelit fase lanjutan membuka akses literasi digital setara bagi para pelajar di kawasan terdepan dan kepulauan terluar.',
    content: [
      'Pemerataan infrastruktur telekomunikasi nasional mencatat tonggak sejarah baru dengan tuntasnya penyambungan konektivitas pita lebar di ribuan titik fasilitas pendidikan daerah Terdepan, Terluar, dan Tertinggal (3T).',
      'Kini, para siswa dan tenaga pendidik di pelosok nusantara dapat mengakses materi ajar interaktif, perpustakaan daring nasional, serta kurikulum komputasi secara real-time dengan kecepatan transmisi stabil.',
      'Kementerian Pekerjaan Umum dan Kominfo menegaskan bahwa konektivitas digital merupakan infrastruktur dasar esensial masa depan yang wajib dijamin keandalannya sebagaimana jalan tol dan jaringan listrik.',
    ],
    category: NewsCategory.infrastruktur,
    author: 'Reporter Infrastruktur Publik',
    source: kDemoSourceLabel,
    publishedDate: '07 Nov 2026',
    readTimeMinutes: 3,
    iconData: Icons.cell_tower_rounded,
  ),

  // 6. Pengawasan Pemerintah
  const NewsArticle(
    id: 'news-06',
    title: 'Ombudsman Rilis Indeks Kepatuhan Standar Layanan Publik: 85% Lembaga Masuk Zona Hijau',
    summary:
        'Survei independen terhadap keterbukaan informasi dan kecepatan penanganan pengaduan warga menunjukkan kenaikan kesadaran birokrasi dalam merespons masukan masyarakat.',
    content: [
      'Ombudsman Republik Indonesia memaparkan hasil penilaian kepatuhan penyelenggaraan pelayanan publik tahun 2026. Terjadi peningkatan signifikan pada indikator transparansi maklumat layanan, kejelasan tarif, kepastian waktu, dan saluran pengaduan SP4N-LAPOR!.',
      'Instansi yang memperoleh predikat Zona Hijau dengan kepatuhan tinggi tercatat mengalami peningkatan menjadi 85 persen, didorong oleh pemanfaatan dasbor pengaduan publik yang dapat dipantau langsung oleh masyarakat sipil.',
      'Kendati demikian, Ombudsman tetap memberikan catatan rekomendasi kepada beberapa pemerintah daerah agar meningkatkan fasilitas aksesibilitas ramah penyandang disabilitas di kantor pelayanan terpadu.',
    ],
    category: NewsCategory.pengawasan,
    author: 'Divisi Pengawasan Sipil',
    source: kDemoSourceLabel,
    publishedDate: '06 Nov 2026',
    readTimeMinutes: 4,
    iconData: Icons.fact_check_rounded,
  ),

  // 7. Pemerintahan
  const NewsArticle(
    id: 'news-07',
    title: 'Uji Kelayakan Calon Pejabat Publik Libatkan Panel Independen & Rekam Jejak Terbuka',
    summary:
        'Standar baru seleksi terbuka (open bidding) jabatan pimpinan tinggi mewajibkan uji publik dan penelusuran LHKPN yang dapat diakses oleh akademisi serta pers kampus.',
    content: [
      'Pemerintah memperketat mekanisme seleksi promosi jabatan struktural di lingkungan kementerian dan lembaga negara. Selain ujian kompetensi manajerial, para kandidat diwajibkan memaparkan visi pencegahan korupsi dan terobosan efisiensi anggaran di hadapan panel penilai independen.',
      'Rekam jejak kepatuhan pelaporan harta kekayaan serta penilaian kinerja integritas dari rekan sejawat menjadi salah satu parameter penentu utama dalam kelulusan seleksi.',
      'Terobosan meritokrasi ini diharapkan melahirkan aparatur sipil negara yang berintegritas tinggi, profesional, dan berorientasi melayani kepentingan bangsa di atas kepentingan kelompok.',
    ],
    category: NewsCategory.pemerintahan,
    author: 'Redaksi Reformasi Birokrasi',
    source: kDemoSourceLabel,
    publishedDate: '05 Nov 2026',
    readTimeMinutes: 3,
    iconData: Icons.how_to_reg_rounded,
  ),

  // 8. Kebijakan Publik
  const NewsArticle(
    id: 'news-08',
    title: 'Perlindungan Ekosistem Karbon: Regulasi Tata Ruang Hijau Diperketat di Seluruh Kawasan Urban',
    summary:
        'Kementerian Lingkungan Hidup menetapkan batas wajib minimal 30 persen Ruang Terbuka Hijau (RTH) bagi seluruh izin perumahan dan kawasan industri modern.',
    content: [
      'Menghadapi tantangan perubahan iklim dan kenaikan suhu perkotaan, regulasi tata ruang nasional mewajibkan setiap rencana tata ruang wilayah (RTRW) kabupaten/kota memprioritaskan pemulihan koridor hijau dan daerah resapan air.',
      'Sanksi administratif berupa pembekuan izin operasional disiapkan bagi pengembang yang melanggar ketentuan koefisien dasar hijau (KDH).',
      'Pemerintah daerah juga didorong memberikan insentif pengurangan PBB bagi warga yang memelihara taman vegetasi produktif di pekarangan rumah masing-masing.',
    ],
    category: NewsCategory.kebijakanPublik,
    author: 'Tim Telaah Lingkungan & Kota',
    source: kDemoSourceLabel,
    publishedDate: '04 Nov 2026',
    readTimeMinutes: 4,
    iconData: Icons.eco_rounded,
  ),
];
