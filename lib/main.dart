
// ============================================================
// FILE: main.dart
// LOKASI: lib/main.dart
//
// FUNGSI:
// Merupakan titik awal aplikasi Flutter.
//
// Tugas utama:
// 1. Menjalankan aplikasi.
// 2. Memeriksa session login.
// 3. Mengambil username yang tersimpan.
// 4. Menentukan halaman pertama aplikasi.
// 5. Mengatur tema dan konfigurasi MaterialApp.
// ============================================================

import 'package:flutter/material.dart';

// Service untuk memeriksa session login.
import 'services/auth_service.dart';

// Halaman Login.
import 'screens/login_screen.dart';

// Halaman Home.
import 'screens/home_screen.dart';

// ------------------------------------------------------------
// 1. MAIN FUNCTION
// ------------------------------------------------------------
// main() adalah fungsi pertama yang dijalankan ketika
// aplikasi Flutter dibuka.
//
// async digunakan karena pemeriksaan session membutuhkan
// proses asynchronous.

void main() async {
  // Memastikan Flutter sudah siap sebelum menggunakan
  // plugin seperti SharedPreferences.
  WidgetsFlutterBinding.ensureInitialized();

  // Membuat objek AuthService.
  final auth = AuthService();

  // Memeriksa apakah ada pengguna yang masih login.
  final savedUsername = await auth.getLoggedInUsername();

  // Menjalankan aplikasi dengan membawa data session.
  runApp(
    MyApp(
      initialUsername: savedUsername,
    ),
  );
}

// ------------------------------------------------------------
// 2. CLASS MYAPP
// ------------------------------------------------------------
// MyApp merupakan widget utama aplikasi.
//
// StatelessWidget digunakan karena tampilan utama ini
// tidak memiliki perubahan state secara langsung.
// Data session sudah diperoleh sebelum runApp().

class MyApp extends StatelessWidget {
  // Username pengguna yang masih login.
  // Jika null berarti belum ada session login.
  final String? initialUsername;

  const MyApp({
    super.key,
    required this.initialUsername,
  });

  // ----------------------------------------------------------
  // 3. BUILD METHOD
  // ----------------------------------------------------------
  // build() digunakan untuk membangun tampilan widget.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nama aplikasi.
      title: 'Spaceflight News',

      // Menghilangkan tulisan DEBUG di pojok layar.
      debugShowCheckedModeBanner: false,

      // ------------------------------------------------------
      // 4. TEMA APLIKASI
      // ------------------------------------------------------
      // ThemeData digunakan untuk mengatur tampilan global.
      //
      // Jika ingin mengganti warna utama aplikasi,
      // bagian ini dapat disesuaikan.

      theme: ThemeData(
        // Warna utama aplikasi.
        primarySwatch: Colors.indigo,

        // Warna latar halaman.
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),

        // Pengaturan AppBar untuk seluruh halaman.
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6C7CF0),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // ------------------------------------------------------
      // 5. MENENTUKAN HALAMAN PERTAMA
      // ------------------------------------------------------
      // Jika username tersedia:
      // Langsung masuk ke HomeScreen.
      //
      // Jika username null:
      // Tampilkan LoginScreen.
      //
      // Inilah bagian yang membuat session login
      // tetap tersimpan ketika aplikasi ditutup.

      home: initialUsername != null
          ? HomeScreen(
              username: initialUsername!,
            )
          : const LoginScreen(),
    );
  }
}
