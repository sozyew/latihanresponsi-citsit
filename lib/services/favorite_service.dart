
// ============================================================
// FILE: favorite_service.dart
// LOKASI: lib/services/favorite_service.dart
//
// FUNGSI:
// Mengelola data Favorite.
//
// Data Favorite disimpan menggunakan SharedPreferences
// sehingga tidak hilang ketika aplikasi ditutup.
//
// Artikel dari News, Blogs, dan Reports dapat disimpan
// dalam satu daftar Favorite.
// ============================================================

// Mengubah objek menjadi JSON dan sebaliknya.
import 'dart:convert';

// Penyimpanan lokal.
import 'package:shared_preferences/shared_preferences.dart';

// Model artikel.
import '../models/article.dart';

class FavoriteService {
  // Nama key untuk menyimpan data Favorite.
  static const String _key = 'favorites';

  // ----------------------------------------------------------
  // 1. MENGAMBIL SEMUA FAVORITE
  // ----------------------------------------------------------
  // Mengambil seluruh artikel yang sudah disimpan.
  //
  // Return berupa List<Article> agar dapat ditampilkan
  // menggunakan ListView di FavoriteScreen.

  Future<List<Article>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    // Mengambil list JSON dari penyimpanan.
    // Jika belum ada data, gunakan list kosong.
    final List<String> raw =
        prefs.getStringList(_key) ?? [];

    // Mengubah setiap JSON menjadi objek Article.
    return raw.map((item) {
      final Map<String, dynamic> json =
          jsonDecode(item);

      return Article.fromJson(json, '');
    }).toList();
  }

  // ----------------------------------------------------------
  // 2. MEMERIKSA FAVORITE
  // ----------------------------------------------------------
  // Memeriksa apakah artikel tertentu sudah menjadi Favorite.
  //
  // Menggunakan favoriteKey agar ID dari kategori berbeda
  // tidak dianggap sebagai artikel yang sama.

  Future<bool> isFavorite(Article article) async {
    final favorites = await getFavorites();

    return favorites.any(
      (item) => item.favoriteKey == article.favoriteKey,
    );
  }

  // ----------------------------------------------------------
  // 3. MENAMBAHKAN ATAU MENGHAPUS FAVORITE
  // ----------------------------------------------------------
  // Jika artikel belum ada, artikel akan ditambahkan.
  // Jika artikel sudah ada, artikel akan dihapus.
  //
  // Fungsi ini menggunakan konsep toggle.

  Future<void> toggleFavorite(Article article) async {
    final prefs = await SharedPreferences.getInstance();

    // Mengambil semua data Favorite.
    final List<String> raw =
        prefs.getStringList(_key) ?? [];

    // Mengubah JSON yang tersimpan menjadi Map.
    final List<Map<String, dynamic>> favorites =
        raw.map((item) {
      return Map<String, dynamic>.from(
        jsonDecode(item),
      );
    }).toList();

    // Mencari artikel berdasarkan gabungan kategori dan ID.
    final index = favorites.indexWhere((item) {
      final String category = item['category'] ?? '';
      final int id = item['id'] ?? 0;

      return '$category-$id' == article.favoriteKey;
    });

    if (index >= 0) {
      // Jika sudah ada, hapus artikel dari daftar.
      favorites.removeAt(index);
    } else {
      // Jika belum ada, tambahkan artikel.
      favorites.add(article.toJson());
    }

    // Mengubah semua data menjadi JSON String.
    final List<String> updated = favorites.map((item) {
      return jsonEncode(item);
    }).toList();

    // Menyimpan kembali daftar Favorite.
    await prefs.setStringList(_key, updated);
  }
}
