
// ============================================================
// FILE: article_card.dart
// LOKASI: lib/widgets/article_card.dart
//
// FUNGSI:
// Membuat tampilan satu artikel dalam bentuk Card.
//
// Widget ini digunakan kembali di:
// 1. ListScreen
// 2. FavoriteScreen
//
// Tujuannya agar tampilan card tidak perlu ditulis ulang
// di setiap halaman.
// ============================================================

import 'package:flutter/material.dart';

import '../models/article.dart';

class ArticleCard extends StatelessWidget {
  // Data artikel yang akan ditampilkan.
  final Article article;

  // Fungsi yang dijalankan saat card ditekan.
  final VoidCallback onTap;

  // Menentukan apakah icon Favorite ditampilkan.
  final bool isFavorite;

  // Fungsi yang dijalankan ketika icon Favorite ditekan.
  // Boleh null karena card biasa tidak selalu memiliki tombol.
  final VoidCallback? onFavToggle;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.isFavorite = false,
    this.onFavToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Menghilangkan bayangan card.
      elevation: 0,

      // Warna latar card.
      color: const Color(0xFFFDF7FF),

      // Jarak card dari sisi layar.
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),

      // Mengatur sudut dan garis tepi card.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.purple.shade100,
        ),
      ),

      child: InkWell(
        // Menjalankan onTap ketika card ditekan.
        onTap: onTap,

        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ------------------------------------------------
              // 1. GAMBAR ARTIKEL
              // ------------------------------------------------
              // ClipRRect digunakan agar gambar memiliki
              // sudut yang membulat.

              ClipRRect(
                borderRadius: BorderRadius.circular(8),

                child: SizedBox(
                  width: 80,
                  height: 60,

                  // Memanggil fungsi untuk menampilkan gambar.
                  child: _buildImage(),
                ),
              ),

              const SizedBox(width: 16),

              // ------------------------------------------------
              // 2. JUDUL DAN AUTHOR
              // ------------------------------------------------
              // Expanded membuat teks menggunakan ruang
              // yang tersedia tanpa menyebabkan overflow.

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Judul artikel.
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Nama author.
                    Text(
                      article.author,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // 3. ICON FAVORITE
              // ------------------------------------------------
              // Hanya ditampilkan jika isFavorite bernilai true.

              if (isFavorite)
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),

                  onPressed: onFavToggle,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // 4. MEMBANGUN GAMBAR ARTIKEL
  // ----------------------------------------------------------
  // Fungsi terpisah agar kode build() lebih rapi.
  //
  // Jika URL kosong atau gambar gagal dimuat,
  // tampilkan gambar pengganti.

  Widget _buildImage() {
    // Memeriksa apakah URL gambar tersedia.
    if (article.imageUrl == null ||
        article.imageUrl!.isEmpty) {
      return _placeholder();
    }

    // Menggunakan proxy untuk membantu memuat gambar.
    final proxyImage =
        'https://images.weserv.nl/?url='
        '${Uri.encodeComponent(article.imageUrl!)}';

    return Image.network(
      proxyImage,

      // Mengatur cara gambar memenuhi kotak.
      fit: BoxFit.cover,

      // Ditampilkan jika gambar gagal dimuat.
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },

      // Ditampilkan ketika gambar sedang dimuat.
      loadingBuilder: (
        context,
        child,
        loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }

        return Container(
          color: Colors.grey.shade200,
        );
      },
    );
  }

  // ----------------------------------------------------------
  // 5. PLACEHOLDER GAMBAR
  // ----------------------------------------------------------
  // Tampilan pengganti ketika gambar kosong atau error.

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(
        Icons.image,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
