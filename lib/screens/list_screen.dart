
// ============================================================
// FILE: list_screen.dart
// LOKASI: lib/screens/list_screen.dart
//
// FUNGSI:
// Menampilkan daftar artikel dari kategori yang dipilih.
//
// Fitur:
// 1. Mengambil data melalui ApiService.
// 2. Menampilkan artikel menggunakan ArticleCard.
// 3. Memfilter artikel berdasarkan author.
// 4. Membuka DetailScreen.
// 5. Memuat ulang data menggunakan RefreshIndicator.
// ============================================================

import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/article_card.dart';

import 'detail_screen.dart';
import 'favorite_screen.dart';

class ListScreen extends StatefulWidget {
  // Kategori API yang akan diambil.
  final String menu;

  // Judul halaman yang ditampilkan.
  final String title;

  const ListScreen({
    super.key,
    required this.menu,
    required this.title,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // Service untuk mengambil data API.
  final ApiService _api = ApiService();

  // Semua artikel dari API.
  List<Article> _all = [];

  // Artikel setelah proses filter.
  List<Article> _filtered = [];

  // Daftar author untuk pilihan filter.
  List<String> _authors = [];

  // Author yang sedang dipilih.
  // Null berarti semua author ditampilkan.
  String? _selectedAuthor;

  // Status loading.
  bool _loading = true;

  // Menyimpan pesan error jika API gagal.
  String? _error;

  // ----------------------------------------------------------
  // 1. INIT STATE
  // ----------------------------------------------------------
  // initState() dijalankan satu kali saat halaman dibuat.
  //
  // _load() dipanggil agar data langsung diambil ketika
  // halaman dibuka.

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ----------------------------------------------------------
  // 2. MENGAMBIL DATA ARTIKEL
  // ----------------------------------------------------------

  Future<void> _load() async {
    // Mengaktifkan loading dan menghapus error sebelumnya.
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Mengambil data sesuai kategori yang dipilih.
      final data = await _api.fetchArticles(widget.menu);

      // Set digunakan agar nama author tidak berulang.
      final Set<String> authors = {};

      // Mengumpulkan author dari seluruh artikel.
      for (final article in data) {
        if (article.author.isNotEmpty &&
            article.author != '-') {
          authors.add(article.author);
        }
      }

      // Memeriksa apakah halaman masih aktif.
      if (!mounted) return;

      // Memperbarui data yang akan ditampilkan.
      setState(() {
        _all = data;
        _filtered = data;
        _authors = authors.toList();
        _selectedAuthor = null;
        _loading = false;
      });
    } catch (e) {
      // Jika terjadi error, simpan pesan error.
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // ----------------------------------------------------------
  // 3. FILTER AUTHOR
  // ----------------------------------------------------------
  // Fungsi ini digunakan untuk menampilkan artikel
  // berdasarkan author yang dipilih.
  //
  // Jika author null, semua artikel ditampilkan.

  void _applyFilter(String? author) {
    setState(() {
      _selectedAuthor = author;

      if (author == null) {
        // Menampilkan semua artikel.
        _filtered = _all;
      } else {
        // Hanya menampilkan artikel dari author terpilih.
        _filtered = _all.where((article) {
          return article.author == author;
        }).toList();
      }
    });
  }

  // ----------------------------------------------------------
  // 4. TAMPILAN HALAMAN LIST
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

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

      body: Column(
        children: [
          // ----------------------------------------------------
          // FILTER AUTHOR
          // ----------------------------------------------------
          // ListView horizontal digunakan agar chip filter
          // dapat digeser ke kanan dan kiri.

          SizedBox(
            height: 60,

            child: ListView(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              children: [
                // Filter untuk menampilkan semua artikel.
                Padding(
                  padding: const EdgeInsets.only(right: 8),

                  child: ChoiceChip(
                    label: const Text('Semua'),

                    selected: _selectedAuthor == null,

                    selectedColor: const Color(0xFFE8DDFF),

                    onSelected: (_) {
                      _applyFilter(null);
                    },
                  ),
                ),

                // Membuat chip berdasarkan daftar author.
                ..._authors.map((author) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),

                    child: ChoiceChip(
                      label: Text(author),

                      selected: _selectedAuthor == author,

                      selectedColor: const Color(0xFFE8DDFF),

                      onSelected: (_) {
                        _applyFilter(author);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bagian daftar artikel.
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // 5. MEMBANGUN ISI HALAMAN
  // ----------------------------------------------------------
  // Fungsi ini menentukan tampilan berdasarkan kondisi:
  // loading, error, data kosong, atau data tersedia.

  Widget _buildBody() {
    // Jika data masih dimuat, tampilkan loading.
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Jika terjadi error, tampilkan pesan dan tombol ulang.
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),

            const SizedBox(height: 8),

            Text(
              _error!,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _load,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    // Jika hasil filter kosong, tampilkan pesan.
    if (_filtered.isEmpty) {
      return const Center(
        child: Text('Tidak ada data'),
      );
    }

    // Menampilkan daftar artikel.
    return RefreshIndicator(
      // Menjalankan ulang pengambilan data saat ditarik.
      onRefresh: _load,

      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),

        // Jumlah item sesuai hasil filter.
        itemCount: _filtered.length,

        // Membuat setiap item artikel.
        itemBuilder: (context, index) {
          final article = _filtered[index];

          return ArticleCard(
            article: article,

            // Membuka halaman detail ketika card ditekan.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return DetailScreen(article: article);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
