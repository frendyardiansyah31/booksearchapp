# BookSearchApp

Aplikasi pencarian & katalog buku perpustakaan (UIII) yang dibuat dengan Flutter.

## 1. Prasyarat (Wajib Diinstal Dulu)

Sebelum mulai, pastikan versi tools di komputer kamu **sama atau lebih baru** dari daftar ini. Kalau versinya beda jauh, aplikasi bisa gagal di-build.

| Tools | Versi yang dipakai di project ini |
| --- | --- |
| Flutter SDK | 3.50.0 (channel stable) |
| Dart SDK | 3.14.0 (otomatis ikut terpasang bareng Flutter) |
| Gradle | 9.3.1 (otomatis terunduh lewat Gradle Wrapper, tidak perlu instal manual) |
| Android Gradle Plugin (AGP) | 9.1.1 |
| Kotlin | 2.2.10 |
| JDK (Java) | 17 atau lebih baru |
| Git | versi berapa saja, buat clone project |

Alat lain yang perlu diinstal sesuai kebutuhan:
- **Android Studio** → kalau mau jalankan/build ke Android (emulator atau HP Android).
- **Xcode** (khusus pengguna Mac) → kalau mau jalankan/build ke iOS.
- **Google Chrome** → kalau mau coba jalankan versi web-nya.

Cek instalasi Flutter sudah benar dengan menjalankan:

```
flutter doctor
```

Kalau ada tanda `[✓]` di Flutter dan minimal satu platform (Android/iOS/Chrome), berarti sudah siap.

## 2. Tech Stack & Library yang Dipakai

- **Flutter & Dart** — framework utama untuk membuat tampilan dan logic aplikasi.
- **http** — untuk mengambil data buku dari API.
- **shared_preferences** — untuk menyimpan data buku favorit langsung di HP (tersimpan walau app ditutup).
- **device_preview** — bantu melihat tampilan app di berbagai ukuran layar/device.
- **cupertino_icons** — kumpulan ikon bergaya iOS.

## 3. Folder & File Penting

- **`lib/`** → folder paling penting, isinya **semua kode aplikasi** (tampilan, logic, dll). Kalau mau ubah fitur, cari filenya di sini.
  - `main.dart` — titik awal aplikasi dijalankan.
  - `homepage.dart`, `search_result_page.dart`, `book_detail_page.dart`, `favorites_page.dart`, `settings_page.dart` — halaman-halaman utama app.
  - `models/` — struktur data, misal `book.dart` (data buku).
  - `services/` — logic penyimpanan data, misal `favorites_service.dart` (buku favorit).
- **`pubspec.yaml`** → file konfigurasi project. Isinya nama app, versi, dan daftar library (dependency) yang dipakai. Kalau mau tambah/ubah library, edit file ini.
- `android/` dan `ios/` → konfigurasi khusus untuk build ke Android/iOS, biasanya tidak perlu diubah.

## 4. Cara Install & Setup

1. Instal Flutter SDK versi 3.50.0 kalau belum ada, ikuti panduan resmi: https://docs.flutter.dev/get-started/install
2. Clone project ini:
   ```
   git clone https://github.com/frendyardiansyah31/booksearchapp.git
   cd booksearchapp
   ```
3. Install semua library yang dibutuhkan:
   ```
   flutter pub get
   ```
4. Pastikan semuanya siap:
   ```
   flutter doctor
   ```

## 5. Cara Menjalankan Aplikasi

1. Siapkan tempat untuk menjalankan app, pilih salah satu:
   - Emulator Android (buka lewat Android Studio), atau
   - HP Android asli (sambungkan via USB, aktifkan mode "USB debugging"), atau
   - Simulator iOS (khusus Mac, lewat Xcode), atau
   - Browser Chrome (untuk versi web).
2. Cek device sudah terdeteksi:
   ```
   flutter devices
   ```
3. Jalankan aplikasinya:
   ```
   flutter run
   ```
   Kalau ada lebih dari satu device terdeteksi, pilih salah satu pakai:
   ```
   flutter run -d <device_id>
   ```
4. Tunggu proses build pertama (bisa beberapa menit), setelah selesai aplikasi otomatis terbuka di device/emulator kamu.

## 6. (Opsional) Build Aplikasi Jadi File Install

- Android (file `.apk`):
  ```
  flutter build apk
  ```
- iOS (khusus Mac + Xcode):
  ```
  flutter build ios
  ```

## 7. Catatan

- Aplikasi ini mengambil data buku dari API: `https://catalogue.uiii.ac.id`
- Kalau muncul error saat build terkait Gradle/Kotlin/AGP, cek lagi versi-versi di tabel Prasyarat di atas — kemungkinan versi di komputer kamu tidak cocok.
