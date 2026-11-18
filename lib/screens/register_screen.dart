
// ============================================================
// FILE: register_screen.dart
// LOKASI: lib/screens/register_screen.dart
//
// FUNGSI:
// Menampilkan halaman pendaftaran akun.
//
// Username dan password dimasukkan pengguna.
// Data dikirim ke AuthService untuk disimpan.
// ============================================================

import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk membaca input username dan password.
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // Service untuk menyimpan akun.
  final _auth = AuthService();

  // Status proses registrasi.
  bool _loading = false;

  // ----------------------------------------------------------
  // 1. MENAMPILKAN SNACKBAR
  // ----------------------------------------------------------

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ----------------------------------------------------------
  // 2. PROSES REGISTER
  // ----------------------------------------------------------

  Future<void> _register() async {
    // Mengambil input username.
    final username = _usernameCtrl.text.trim();

    // Mengambil input password.
    final password = _passwordCtrl.text;

    // Memeriksa input kosong.
    if (username.isEmpty || password.isEmpty) {
      _showSnack(
        'Username dan password tidak boleh kosong',
        Colors.red,
      );
      return;
    }

    // Mengaktifkan loading.
    setState(() {
      _loading = true;
    });

    // Mengirim data akun ke AuthService.
    final bool success = await _auth.register(
      username,
      password,
    );

    // Memastikan halaman masih aktif setelah proses async.
    if (!mounted) return;

    // Menghentikan loading.
    setState(() {
      _loading = false;
    });

    if (success) {
      // Registrasi berhasil.
      _showSnack(
        'Registrasi berhasil! Silakan login.',
        Colors.green,
      );

      // Kembali ke halaman Login.
      Navigator.pop(context);
    } else {
      // Username sudah terdaftar.
      _showSnack(
        'Username sudah digunakan',
        Colors.red,
      );
    }
  }

  // ----------------------------------------------------------
  // 3. DISPOSE CONTROLLER
  // ----------------------------------------------------------

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  // ----------------------------------------------------------
  // 4. TAMPILAN REGISTER
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const SizedBox(height: 60),

            const Text(
              'Daftar Akun Baru',
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

            // Loading atau tombol Daftar.
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,

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

                    child: const Text('Daftar'),
                  ),
          ],
        ),
      ),
    );
  }
}
