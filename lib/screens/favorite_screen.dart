
// ============================================================
// FILE: favorite_screen.dart
// LOKASI: lib/screens/favorite_screen.dart
//
// FUNGSI:
// Menampilkan seluruh artikel yang sudah ditambahkan
// ke Favorite.
//
// Fitur:
// 1. Mengambil data Favorite dari SharedPreferences.
// 2. Menampilkan artikel menggunakan ArticleCard.
// 3. Menghapus artikel dari Favorite.
// 4. Membuka halaman Detail.
// 5. Memuat ulang daftar ketika kembali dari Detail.
// ============================================================

import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/favorite_service.dart';
import '../widgets/article_card.dart';

import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Service untuk mengelola data Favorite.
  final FavoriteService _favService = FavoriteService();

  // Menyimpan daftar artikel Favorite.
  List<Article> _favorites = [];

  // Status loading.
  bool _loading = true;

  // ----------------------------------------------------------
  // 1. INIT STATE
  // ----------------------------------------------------------
  // Ketika halaman dibuka, data Favorite langsung dimuat.

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ----------------------------------------------------------
  // 2. MEMUAT DATA FAVORITE
  // ----------------------------------------------------------

  Future<void> _load() async {
    // Mengaktifkan loading.
    setState(() {
      _loading = true;
    });

    // Mengambil seluruh artikel Favorite.
    final favs = await _favService.getFavorites();

    if (!mounted) return;

    // Memperbarui daftar artikel.
    setState(() {
      _favorites = favs;
      _loading = false;
    });
  }

  // ----------------------------------------------------------
  // 3. MENGHAPUS FAVORITE
  // ----------------------------------------------------------
  // Jika icon love ditekan, artikel dihapus dari penyimpanan.
  // Setelah itu daftar Favorite dimuat kembali.

  Future<void> _removeFavorite(Article article) async {
    await _favService.toggleFavorite(article);

    if (!mounted) return;

    await _load();
  }

  // ----------------------------------------------------------
  // 4. TAMPILAN FAVORITE
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),

      // Menentukan tampilan berdasarkan kondisi data.
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          // Jika belum ada Favorite.
          : _favorites.isEmpty
              ? const Center(
                  child: Text('Belum ada data favorite'),
                )

              // Jika terdapat data Favorite.
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16),

                  itemCount: _favorites.length,

                  itemBuilder: (context, index) {
                    final article = _favorites[index];

                    return ArticleCard(
                      article: article,

                      // Memunculkan icon love merah.
                      isFavorite: true,

                      // Menghapus artikel dari Favorite.
                      onFavToggle: () {
                        _removeFavorite(article);
                      },

                      // Membuka halaman Detail.
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return DetailScreen(
                                article: article,
                              );
                            },
                          ),
                        ).then((_) {
                          // Memuat ulang data ketika kembali
                          // dari halaman Detail.
                          _load();
                        });
                      },
                    );
                  },
                ),
    );
  }
}
