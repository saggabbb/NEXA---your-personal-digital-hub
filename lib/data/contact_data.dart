/// Data statis kontak telepon untuk aplikasi NEXA.
///
/// Berisi 16 kontak dummy yang memenuhi persyaratan minimal 15 kontak UTS.
library;

import '../models/contact_model.dart';

class ContactData {
  ContactData._();

  static const List<Contact> contacts = [
    Contact(
      id: 'c1',
      name: 'Dr. Ir. Hendra Gunawan, M.T.',
      phone: '0811-2233-4455',
      category: 'Dosen Pembimbing',
      email: 'hendra.gunawan@itenas.ac.id',
    ),
    Contact(
      id: 'c2',
      name: 'Prof. Siti Nurhaliza, Ph.D.',
      phone: '0812-9876-5432',
      category: 'Dosen Pengampu',
      email: 'siti.nurhaliza@itenas.ac.id',
    ),
    Contact(
      id: 'c3',
      name: 'Rian Pratama (Ketua Tingkat)',
      phone: '0857-1122-3344',
      category: 'Teman Kuliah',
      email: 'rian.pratama@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c4',
      name: 'Aisyah Putri Ramadhani',
      phone: '0813-4455-6677',
      category: 'Teman Kuliah',
      email: 'aisyah.putri@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c5',
      name: 'Fajar Nugraha (Lab Asisten)',
      phone: '0821-3344-5566',
      category: 'Laboratorium',
      email: 'fajar.nugraha@lab.itenas.ac.id',
    ),
    Contact(
      id: 'c6',
      name: 'Budi Santoso, M.Kom.',
      phone: '0813-8899-0011',
      category: 'Dosen Pengampu',
      email: 'budi.santoso@itenas.ac.id',
    ),
    Contact(
      id: 'c7',
      name: 'Dimas Aditya (Rekan Mobile)',
      phone: '0878-2233-9988',
      category: 'Rekan Proyek',
      email: 'dimas.aditya@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c8',
      name: 'Nadia Safitri (UI/UX Designer)',
      phone: '0896-1234-5678',
      category: 'Rekan Proyek',
      email: 'nadia.safitri@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c9',
      name: 'Kevin Jonathan (Backend Dev)',
      phone: '0812-3344-9900',
      category: 'Rekan Proyek',
      email: 'kevin.j@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c10',
      name: 'Sekretariat Jurusan Informatika',
      phone: '022-780-0123',
      category: 'Kampus & Jurusan',
      email: 'informatika@itenas.ac.id',
    ),
    Contact(
      id: 'c11',
      name: 'Helpdesk IT Center Itenas',
      phone: '022-780-0999',
      category: 'Kampus & Jurusan',
      email: 'itcenter@itenas.ac.id',
    ),
    Contact(
      id: 'c12',
      name: 'Muhammad Rizky Ramadhan',
      phone: '0852-7788-9900',
      category: 'Teman Kuliah',
      email: 'm.rizky@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c13',
      name: 'Tiara Andini (Himpunan)',
      phone: '0819-3322-1100',
      category: 'Teman Kuliah',
      email: 'tiara.andini@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c14',
      name: 'Farhan Maulana (DevOps)',
      phone: '0858-6655-4433',
      category: 'Rekan Proyek',
      email: 'farhan.m@mhs.itenas.ac.id',
    ),
    Contact(
      id: 'c15',
      name: 'Perpustakaan Utama Kampus',
      phone: '022-780-0456',
      category: 'Kampus & Jurusan',
      email: 'perpustakaan@itenas.ac.id',
    ),
    Contact(
      id: 'c16',
      name: 'Pusat Karir & Alumni',
      phone: '022-780-0789',
      category: 'Kampus & Jurusan',
      email: 'karir@itenas.ac.id',
    ),
  ];
}
