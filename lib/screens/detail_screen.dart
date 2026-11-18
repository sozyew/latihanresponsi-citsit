
// ============================================================
// FILE: detail_screen.dart
// LOKASI: lib/screens/detail_screen.dart
//
// FUNGSI:
// Menampilkan informasi lengkap sebuah artikel.
//
// Informasi yang ditampilkan:
// 1. Gambar.
// 2. Judul.
// 3. Author.
// 4. Tanggal publikasi.
// 5. Ringkasan.
// 6. Tombol Buka Web.
// 7. Tombol Favorite.
//
// Data artikel diterima dari halaman sebelumnya melalui
// parameter widget.article.
//
// Jadi, halaman ini tidak perlu mengambil data artikel
// kembali melalui ApiService.
// ============================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import '../services/favorite_service.dart';

// ============================================================
// 1. CLASS DETAIL SCREEN
// ============================================================
// StatefulWidget digunakan karena status Favorite dapat berubah
// ketika pengguna menekan tombol Favorite.

class DetailScreen extends StatefulWidget {
  // Artikel yang dipilih dari halaman List atau Favorite.
  final Article article;

  const DetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

// ============================================================
// 2. CLASS STATE DETAIL SCREEN
// ============================================================

class _DetailScreenState extends State<DetailScreen> {
  // Service untuk mengelola data Favorite.
  final FavoriteService _favService = FavoriteService();

  // Menyimpan status Favorite artikel.
  // true berarti artikel sudah menjadi Favorite.
  // false berarti artikel belum menjadi Favorite.
  bool _isFav = false;

  // Menandakan apakah status Favorite masih diperiksa.
  bool _loadingFav = true;

  // ----------------------------------------------------------
  // 3. INIT STATE
  // ----------------------------------------------------------
  // initState() dijalankan satu kali ketika halaman dibuat.
  //
  // Pada bagian ini, aplikasi memeriksa apakah artikel
  // sudah tersimpan sebagai Favorite atau belum.

  @override
  void initState() {
    super.initState();

    _checkFav();
  }

  // ----------------------------------------------------------
  // 4. MEMERIKSA STATUS FAVORITE
  // ----------------------------------------------------------
  // isFavorite() digunakan untuk mengecek apakah artikel
  // sudah tersimpan di SharedPreferences.

  Future<void> _checkFav() async {
    final fav = await _favService.isFavorite(
      widget.article,
    );

    // Memastikan halaman masih aktif sebelum mengubah state.
    if (!mounted) return;

    setState(() {
      _isFav = fav;
      _loadingFav = false;
    });
  }

  // ----------------------------------------------------------
  // 5. MENAMBAHKAN / MENGHAPUS FAVORITE
  // ----------------------------------------------------------
  // toggleFavorite() digunakan untuk mengubah status Favorite.
  //
  // Jika artikel belum Favorite:
  // Artikel akan ditambahkan.
  //
  // Jika artikel sudah Favorite:
  // Artikel akan dihapus.

  Future<void> _toggleFav() async {
    await _favService.toggleFavorite(
      widget.article,
    );

    // Memeriksa kembali status Favorite setelah diubah.
    final now = await _favService.isFavorite(
      widget.article,
    );

    if (!mounted) return;

    setState(() {
      _isFav = now;
    });

    // Menampilkan pesan setelah pengguna menekan tombol.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          now
              ? 'Ditambahkan ke favorite'
              : 'Dihapus dari favorite',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ----------------------------------------------------------
  // 6. MEMBUKA URL ARTIKEL
  // ----------------------------------------------------------
  // url_launcher digunakan untuk membuka website artikel
  // melalui browser eksternal.

  Future<void> _openUrl(String articleUrl) async {
    // Mengubah String URL menjadi objek Uri.
    final uri = Uri.tryParse(articleUrl);

    // Memastikan URL valid dan menggunakan HTTP/HTTPS.
    if (uri == null ||
        !uri.hasScheme ||
        !(uri.scheme == 'http' || uri.scheme == 'https')) {
      _showUrlError();
      return;
    }

    try {
      // Membuka URL menggunakan aplikasi eksternal.
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      // Jika URL gagal dibuka, tampilkan pesan error.
      if (!success) {
        _showUrlError();
      }
    } catch (_) {
      _showUrlError();
    }
  }

  // ----------------------------------------------------------
  // 7. MENAMPILKAN PESAN ERROR URL
  // ----------------------------------------------------------

  void _showUrlError() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tidak dapat membuka URL'),
      ),
    );
  }

  // ----------------------------------------------------------
  // 8. MEMBANGUN GAMBAR ARTIKEL
  // ----------------------------------------------------------
  // Image.network digunakan untuk menampilkan gambar
  // berdasarkan URL yang tersimpan pada data artikel.
  //
  // errorBuilder digunakan untuk menampilkan gambar pengganti
  // apabila gambar gagal dimuat.

  Widget _buildImage(Article article) {
    // Memeriksa apakah URL gambar tersedia.
    if (article.imageUrl == null ||
        article.imageUrl!.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Icon(
          Icons.image_not_supported,
          size: 60,
          color: Colors.grey,
        ),
      );
    }

    // Menggunakan proxy gambar seperti pada ArticleCard.
    final proxyImage =
        'https://images.weserv.nl/?url='
        '${Uri.encodeComponent(article.imageUrl!)}';

    return Image.network(
      proxyImage,
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,

      // Tampilan ketika gambar sedang dimuat.
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

      // Tampilan jika gambar gagal dimuat.
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade300,
          child: const Icon(
            Icons.broken_image,
            size: 60,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // 9. BUILD METHOD
  // ----------------------------------------------------------
  // build() digunakan untuk membangun tampilan halaman Detail.
  //
  // Data artikel langsung menggunakan widget.article.
  // Tidak menggunakan FutureBuilder karena data artikel
  // sudah tersedia dari halaman sebelumnya.

  @override
  Widget build(BuildContext context) {
    // Mengambil data artikel yang dikirim dari halaman sebelumnya.
    final Article article = widget.article;

    return Scaffold(
      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------
      appBar: AppBar(
        title: const Text('Detail'),

        actions: [
          // Tombol Favorite di pojok kanan atas.
          IconButton(
            icon: Icon(
              _isFav
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _isFav ? Colors.red : Colors.white,
            ),

            // Tombol tidak aktif selama status Favorite diperiksa.
            onPressed: _loadingFav ? null : _toggleFav,
          ),
        ],
      ),

      // --------------------------------------------------------
      // BODY
      // --------------------------------------------------------
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar artikel.
            SizedBox(
              width: double.infinity,
              height: 220,
              child: _buildImage(article),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul artikel.
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Author artikel.
                  Text(
                    article.author,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.purple.shade300,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Tanggal publikasi artikel.
                  Text(
                    article.formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ringkasan artikel.
                  Text(
                    article.summary,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol untuk membuka website resmi artikel.
                  Align(
                    alignment: Alignment.centerRight,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        _openUrl(article.url);
                      },

                      icon: const Icon(
                        Icons.open_in_new,
                        size: 18,
                      ),

                      label: const Text('Buka Web'),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8DDFF),
                        foregroundColor: Colors.purple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
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
