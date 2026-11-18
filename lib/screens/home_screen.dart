
// ============================================================
// FILE: home_screen.dart
// LOKASI: lib/screens/home_screen.dart
//
// FUNGSI:
// Menjadi halaman utama setelah pengguna berhasil login.
//
// Menampilkan:
// 1. Username pengguna.
// 2. Menu News.
// 3. Menu Blog.
// 4. Menu Reports.
// 5. Tombol Favorite.
// 6. Tombol Logout.
// ============================================================

import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'login_screen.dart';
import 'list_screen.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatelessWidget {
  // Username pengguna yang sedang login.
  final String username;

  const HomeScreen({
    super.key,
    required this.username,
  });

  // ----------------------------------------------------------
  // 1. LOGOUT
  // ----------------------------------------------------------
  // Menghapus session login dan kembali ke LoginScreen.

  Future<void> _logout(BuildContext context) async {
    // Menghapus session melalui AuthService.
    await AuthService().logout();

    // Memastikan context masih aktif.
    if (!context.mounted) return;

    // Menghapus seluruh halaman sebelumnya dari navigation.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // ----------------------------------------------------------
  // 2. NAVIGASI KE HALAMAN LIST
  // ----------------------------------------------------------
  // Parameter:
  // menu  = kategori data yang akan diambil.
  // title = judul yang ditampilkan pada AppBar.

  void _goTo(
    BuildContext context,
    String menu,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListScreen(
          menu: menu,
          title: title,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 3. TAMPILAN HOME
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menampilkan username pengguna.
        title: Text('Hai, $username!'),
        centerTitle: true,

        actions: [
          // Tombol menuju halaman Favorite.
          IconButton(
            icon: const Icon(Icons.favorite),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoriteScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // Menu News.
          _menuCard(
            context,
            icon: Icons.newspaper,
            title: 'News',
            desc:
                'Get an overview of the latest SpaceFlight '
                'news, from various sources! Easily link your '
                'users to the right websites.',
            onTap: () {
              // PERBAIKAN:
              // ApiService menggunakan kategori 'news',
              // bukan 'articles'.
              _goTo(context, 'news', 'News');
            },
          ),

          const SizedBox(height: 12),

          // Menu Blog.
          _menuCard(
            context,
            icon: Icons.article,
            title: 'Blog',
            desc:
                'Blogs often provide a more detailed overview '
                'of launches and missions. A must-have for '
                'the serious spaceflight enthusiast.',
            onTap: () {
              _goTo(context, 'blogs', 'Blog');
            },
          ),

          const SizedBox(height: 12),

          // Menu Reports.
          _menuCard(
            context,
            icon: Icons.analytics,
            title: 'Reports',
            desc:
                'Space stations and other missions often '
                'publish their data. With SNAPI, you can '
                'include it in your app.',
            onTap: () {
              _goTo(context, 'reports', 'Reports');
            },
          ),

          const SizedBox(height: 24),

          // Tombol Logout.
          Center(
            child: ElevatedButton(
              onPressed: () => _logout(context),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 4. WIDGET MENU CARD
  // ----------------------------------------------------------
  // Fungsi ini membuat card menu yang dapat digunakan
  // berulang kali untuk News, Blog, dan Reports.

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon menu.
            Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FD),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: Colors.purple,
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            // Judul dan deskripsi menu.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
