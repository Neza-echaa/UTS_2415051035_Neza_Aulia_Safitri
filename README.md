# RecipeMate 🍳

**RecipeMate** adalah aplikasi resep makanan berbasis Flutter yang membantu pengguna menemukan berbagai resep, melihat detail resep, menyimpan resep favorit, serta membuat dan mengelola resep pribadi.

Project ini dibuat untuk memenuhi tugas Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile.

## Identitas Pengembang

- **Nama:** Neza Aulia Safitri
- **NIM:** 2415051035
- **Kelas:** PTI 5C
- **Program Studi:** S1 Pendidikan Teknik Informatika
- **Tema Project:** RecipeMate
- **Repository GitHub:** https://github.com/Neza-echaa/recipe_mate

## Fitur Aplikasi

1. **Beranda (Home)**  
   Menampilkan rekomendasi dan daftar resep makanan.

2. **Jelajahi (Explore)**  
   Menampilkan katalog resep yang dapat dicari dan dijelajahi pengguna.

3. **Detail Resep**  
   Menampilkan informasi resep, gambar, bahan-bahan, dan langkah memasak.

4. **Favorit**  
   Memungkinkan pengguna menandai dan menghapus resep favorit.

5. **Resepku (My Recipes)**  
   Menampilkan resep pribadi yang dibuat dan disimpan oleh pengguna.

6. **Tambah Resep**  
   Menambahkan resep baru melalui formulir yang tersedia.

7. **Edit Resep**  
   Mengubah informasi resep yang telah disimpan.

8. **Hapus Resep**  
   Menghapus resep pribadi yang sudah tidak diperlukan melalui konfirmasi.

9. **Profil**  
   Mengelola informasi nama, email, bio, dan foto profil.

10. **Pengaturan**  
    Mengatur tema terang/gelap dan bahasa aplikasi Indonesia/Inggris.

## Teknologi yang Digunakan

- **Flutter** – Framework untuk membangun aplikasi.
- **Dart** – Bahasa pemrograman.
- **Provider dan ChangeNotifier** – Mengelola state aplikasi.
- **DummyJSON Recipes API** – Menyediakan data resep dari REST API.
- **Supabase** – Backend dan database PostgreSQL untuk menyimpan resep pribadi.
- **SharedPreferences** – Menyimpan data profil, favorit, dan pengaturan secara lokal.
- **Image Picker** – Memilih foto profil dari perangkat.
- **Git dan GitHub** – Mengelola versi dan riwayat pengembangan project.

## REST API

RecipeMate menggunakan **DummyJSON Recipes API** untuk mengambil data resep makanan.

Alamat API:

https://dummyjson.com/recipes

Operasi yang digunakan:

- **GET:** Mengambil data resep dari REST API.
- **JSON Parsing:** Mengubah response JSON menjadi objek Dart Model.
- Data resep API ditampilkan pada halaman Beranda dan Jelajahi.

## Backend dan Database

RecipeMate menggunakan **Supabase** dengan database PostgreSQL.

Tabel utama yang digunakan adalah `saved_recipes`, yang berfungsi menyimpan resep pribadi pengguna.

Data yang disimpan mencakup:

- ID resep sebagai primary key.
- Nama resep.
- Deskripsi resep.
- Bahan-bahan.
- Langkah memasak.
- URL gambar.
- Jenis masakan.
- Tingkat kesulitan.
- Waktu persiapan dan memasak.
- Jumlah porsi.
- Waktu pembuatan.

Operasi database yang diterapkan:

- **Create:** Menambahkan resep baru.
- **Read:** Menampilkan resep yang tersimpan.
- **Update:** Mengubah informasi resep.
- **Delete:** Menghapus resep dari database.

## State Management

Aplikasi menggunakan **Provider dan ChangeNotifier** untuk mengelola state agar perubahan data dapat ditampilkan pada halaman yang berkaitan.

State yang dikelola meliputi:

- Data resep dari API.
- Daftar resep favorit.
- Data resep pribadi.
- Status loading dan error.
- Informasi profil pengguna.
- Pengaturan tema dan bahasa aplikasi.

SharedPreferences digunakan untuk mempertahankan data lokal setelah aplikasi dibuka kembali.

## Arsitektur Aplikasi

Project menggunakan pemisahan kode berdasarkan tanggung jawab masing-masing bagian.

Struktur folder utama:

```text
lib/
├── models/
├── services/
├── repositories/
├── providers/
├── screens/
├── widgets/
└── main.dart
```

Alur arsitektur aplikasi:

```text
Screen / Widget
       |
       v
Provider / ChangeNotifier
       |
       v
Repository
       |
       v
Service / Data Source
       |
       v
REST API / Supabase
```

Pemisahan ini bertujuan agar tampilan, pengelolaan state, dan proses pengambilan atau penyimpanan data tidak tercampur dalam satu bagian kode.

## Screenshot Aplikasi

Screenshot aplikasi akan ditambahkan pada folder `screenshots/`.

Dokumentasi screenshot meliputi:

- Halaman home.
- Halaman Jelajahi.
- Halaman Detail Resep.
- Halaman Tambah Resep.
- Halaman Edit Resep.
- Halaman Resepku.
- Halaman Favorit.
- Halaman Profil.
- Tampilan aplikasi pada ukuran layar berbeda.

## Cara Menjalankan Project

**1. Clone repository**

```bash
git clone https://github.com/Neza-echaa/recipe_mate.git
```

**2. Masuk ke folder project**

```bash
cd recipe_mate
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Konfigurasikan Supabase**

Pastikan URL Supabase dan publishable key sudah dikonfigurasikan pada aplikasi.

Gunakan publishable key, bukan secret key atau service_role key.

**5. Jalankan aplikasi**

Untuk menjalankan aplikasi melalui Chrome:

```bash
flutter run -d chrome --web-port=50648
```

## Git dan GitHub

Pengembangan RecipeMate dilakukan secara bertahap menggunakan Git dan GitHub untuk mengelola perubahan kode serta mendokumentasikan proses pengembangan aplikasi.

- **Repository:** https://github.com/Neza-echaa/recipe_mate
- **Branch utama:** `main`

Riwayat pengembangan dapat dilihat melalui repository GitHub atau menggunakan perintah:

```bash
git log --oneline
```

Dokumentasi screenshot aplikasi tersedia pada folder `screenshots/` di repository.

## Pengembang

**Neza Aulia Safitri**  
NIM: 2415051035  
Kelas: PTI 5C

Project Ujian Tengah Semester  
Mata Kuliah Pemrograman Mobile