
// ============================================================
// FILE: login_screen.dart
// LOKASI: lib/screens/login_screen.dart
//
// FUNGSI:
// Menampilkan halaman Login.
//
// Pengguna memasukkan username dan password.
// Data diperiksa melalui AuthService.
// Jika benar, pengguna diarahkan ke HomeScreen.
// ============================================================

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller digunakan untuk membaca isi TextField.
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // Memanggil service untuk memeriksa akun.
  final _auth = AuthService();

  // Menandakan apakah proses login sedang berjalan.
  bool _loading = false;

  // ----------------------------------------------------------
  // 1. MENAMPILKAN PESAN ERROR
  // ----------------------------------------------------------
  // SnackBar digunakan untuk menampilkan pesan sementara.

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ----------------------------------------------------------
  // 2. PROSES LOGIN
  // ----------------------------------------------------------

  Future<void> _login() async {
    // Mengambil username dan menghapus spasi di awal/akhir.
    final username = _usernameCtrl.text.trim();

    // Mengambil password.
    final password = _passwordCtrl.text;

    // Memeriksa apakah input kosong.
    if (username.isEmpty || password.isEmpty) {
      _showError(
        'Username dan password tidak boleh kosong',
      );
      return;
    }

    // Mengaktifkan indikator loading.
    setState(() {
      _loading = true;
    });

    // Memeriksa akun melalui AuthService.
    final bool success = await _auth.login(
      username,
      password,
    );

    // Memeriksa apakah widget masih aktif.
    if (!mounted) return;

    // Menghentikan indikator loading.
    setState(() {
      _loading = false;
    });

    if (success) {
      // Jika login berhasil, pindah ke HomeScreen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(username: username),
        ),
      );
    } else {
      // Jika gagal, tampilkan pesan error.
      _showError(
        'Login Gagal! Pastikan sudah Register '
        'atau cek password',
      );
    }
  }

  // ----------------------------------------------------------
  // 3. MEMBERSIHKAN CONTROLLER
  // ----------------------------------------------------------
  // dispose() dipanggil ketika halaman tidak digunakan lagi.
  // Tujuannya untuk menghindari penggunaan memori berlebihan.

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  // ----------------------------------------------------------
  // 4. TAMPILAN LOGIN
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const SizedBox(height: 60),

            const Text(
              'Silakan Login',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // Input username.
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Input password.
            TextField(
              controller: _passwordCtrl,

              // Menyembunyikan karakter password.
              obscureText: true,

              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Jika loading, tampilkan indikator.
            // Jika tidak, tampilkan tombol Login.
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E0E0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    child: const Text('Login'),
                  ),

            const SizedBox(height: 16),

            // Navigasi menuju halaman Register.
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },

              child: const Text(
                'Belum punya akun? Daftar di sini',
                style: TextStyle(
                  color: Color(0xFF6C7CF0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
