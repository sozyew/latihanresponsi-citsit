
// ============================================================
// FILE: auth_service.dart
// LOKASI: lib/services/auth_service.dart
//
// FUNGSI:
// Mengelola proses Register, Login, dan Logout.
//
// SharedPreferences digunakan untuk menyimpan data secara
// lokal agar tetap tersedia ketika aplikasi ditutup.
// ============================================================

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Key untuk menyimpan seluruh akun yang sudah terdaftar.
  static const String _keyUsers = 'users';

  // Key untuk menyimpan username yang sedang login.
  static const String _keyUsername = 'username';

  // Key untuk mengetahui apakah pengguna sedang login.
  static const String _keyLoggedIn = 'isLoggedIn';

  // ----------------------------------------------------------
  // 1. REGISTER
  // ----------------------------------------------------------
  // Mendaftarkan akun baru.
  //
  // Parameter:
  // username = nama pengguna.
  // password = kata sandi.
  //
  // Return:
  // true  = registrasi berhasil.
  // false = username sudah digunakan.

  Future<bool> register(
    String username,
    String password,
  ) async {
    // Mengakses penyimpanan lokal.
    final prefs = await SharedPreferences.getInstance();

    // Mengambil data akun yang sudah tersimpan.
    // Jika belum ada, gunakan list kosong.
    final String? existing = prefs.getString(_keyUsers);

    // Mengubah data JSON menjadi Map akun.
    final Map<String, dynamic> users = existing == null
        ? {}
        : Map<String, dynamic>.from(jsonDecode(existing));

    // Memeriksa apakah username sudah digunakan.
    if (users.containsKey(username)) {
      return false;
    }

    // Menambahkan username dan password ke data akun.
    users[username] = password;

    // Mengubah Map menjadi JSON lalu menyimpannya.
    await prefs.setString(
      _keyUsers,
      jsonEncode(users),
    );

    return true;
  }

  // ----------------------------------------------------------
  // 2. LOGIN
  // ----------------------------------------------------------
  // Memeriksa username dan password yang dimasukkan.
  //
  // Jika cocok, session login disimpan.
  //
  // Return:
  // true  = login berhasil.
  // false = username atau password salah.

  Future<bool> login(
    String username,
    String password,
  ) async {
    // Mengakses penyimpanan lokal.
    final prefs = await SharedPreferences.getInstance();

    // Mengambil data akun yang sudah terdaftar.
    final String? existing = prefs.getString(_keyUsers);

    // Jika belum ada akun yang terdaftar, login gagal.
    if (existing == null) {
      return false;
    }

    // Mengubah JSON menjadi Map.
    final Map<String, dynamic> users =
        Map<String, dynamic>.from(jsonDecode(existing));

    // Memeriksa apakah username tersedia dan password cocok.
    if (users.containsKey(username) &&
        users[username] == password) {
      // Menyimpan status login.
      await prefs.setBool(_keyLoggedIn, true);

      // Menyimpan username pengguna yang sedang login.
      await prefs.setString(_keyUsername, username);

      return true;
    }

    return false;
  }

  // ----------------------------------------------------------
  // 3. MENGAMBIL SESSION LOGIN
  // ----------------------------------------------------------
  // Digunakan saat aplikasi pertama kali dibuka.
  //
  // Jika pengguna sebelumnya belum logout, username
  // masih tersedia sehingga aplikasi dapat langsung
  // menampilkan HomeScreen.

  Future<String?> getLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();

    // Memeriksa status login.
    final bool isLoggedIn =
        prefs.getBool(_keyLoggedIn) ?? false;

    // Jika tidak login, kembalikan null.
    if (!isLoggedIn) {
      return null;
    }

    // Jika login, kembalikan username.
    return prefs.getString(_keyUsername);
  }

  // ----------------------------------------------------------
  // 4. LOGOUT
  // ----------------------------------------------------------
  // Mengakhiri session pengguna.
  //
  // Data akun yang sudah terdaftar tidak dihapus.
  // Hanya status login dan username session yang dihapus.

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Mengubah status login menjadi false.
    await prefs.setBool(_keyLoggedIn, false);

    // Menghapus username yang sedang login.
    await prefs.remove(_keyUsername);
  }
}
