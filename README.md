# PBM 2026 Product Catalog App

Aplikasi Flutter sederhana untuk tugas praktikum Pemrograman Berbasis Mobile 2026. Aplikasi ini digunakan untuk login, mengelola draft produk, dan submit link repository GitHub.

## Fitur

- Login menggunakan username dan password NIM.
- Menyimpan token autentikasi dengan `flutter_secure_storage`.
- Menampilkan daftar draft produk dari API.
- Menambahkan produk baru.
- Menghapus produk secara soft delete.
- Submit tugas menggunakan link repository GitHub.
- UI sederhana dengan tema biru minimalis.

## Teknologi

- Flutter
- Dart
- Package `http`
- Package `flutter_secure_storage`

## API

Base URL:

```text
https://task.itprojects.web.id/api
```

Endpoint yang digunakan:

- `POST /auth/login`
- `GET /products`
- `POST /products`
- `DELETE /products/{id}`
- `POST /products/submit`

Semua request setelah login menggunakan header:

```text
Authorization: Bearer TOKEN
Content-Type: application/json
Accept: application/json
```

## Cara Menjalankan

1. Install dependency:

```bash
flutter pub get
```

2. Jalankan aplikasi:

```bash
flutter run
```

3. Login menggunakan NIM sebagai username dan password.

## Struktur Folder Utama

```text
lib/
  models/
    product.dart
    user.dart
  screens/
    login_screen.dart
    home_screen.dart
    add_product_screen.dart
    submit_screen.dart
  services/
    auth_service.dart
    api_service.dart
  main.dart
```

## Verifikasi

Perintah pengecekan:

```bash
flutter analyze
flutter test
```
