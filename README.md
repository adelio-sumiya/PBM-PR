## TUGAS PBM PRAKTIKUM 2026
by : Adelio Frizky - 242410102064
Aplikasi Flutter sederhana untuk tugas praktikum Pemrograman Berbasis Mobile 2026. Aplikasi ini digunakan untuk login, mengelola draft produk, dan submit link repository GitHub.


## UI
- LOGIN
<img width="497" height="648" alt="image" src="https://github.com/user-attachments/assets/0715e228-a467-4828-9768-590429ea6be1" />


- HOME SCREEN
<img width="500" height="599" alt="image" src="https://github.com/user-attachments/assets/0522a022-4232-481f-93ce-476e8ac01237" />


- ADD PRODUCT
<img width="493" height="645" alt="image" src="https://github.com/user-attachments/assets/18111f36-2078-44f7-8fb4-d5f7198983b5" />


- SUBMIT TASK
<img width="496" height="643" alt="image" src="https://github.com/user-attachments/assets/aec2d831-6a91-4d45-8d35-c6f6de880270" />

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

```
