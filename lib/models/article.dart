
// ============================================================
// FILE: article.dart
// LOKASI: lib/models/article.dart
//
// FUNGSI:
// Menjadi model atau cetakan data artikel.
//
// Data dari API diubah menjadi objek Article agar mudah
// digunakan oleh halaman List, Detail, dan Favorite.
// ============================================================

class Article {
  // ----------------------------------------------------------
  // 1. PROPERTY / ATRIBUT
  // ----------------------------------------------------------
  // final berarti nilainya tidak bisa diganti setelah objek
  // Article dibuat.
  //
  // int     : angka bulat.
  // String  : teks.
  // String? : teks yang boleh bernilai null.

  final int id;
  final String title;
  final String? imageUrl;
  final String author;
  final String publishedAt;
  final String summary;
  final String url;
  final String category;

  // ----------------------------------------------------------
  // 2. CONSTRUCTOR
  // ----------------------------------------------------------
  // Digunakan untuk membuat objek Article.
  //
  // required berarti property tersebut wajib diisi.
  // imageUrl tidak required karena gambar boleh kosong.

  Article({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.summary,
    required this.url,
    required this.category,
  });

  // ----------------------------------------------------------
  // 3. FACTORY CONSTRUCTOR: fromJson()
  // ----------------------------------------------------------
  // Mengubah data JSON menjadi objek Article.
  //
  // Parameter:
  // json     = data artikel dari API atau penyimpanan.
  // category = kategori artikel.
  //
  // Contoh:
  // Article.fromJson(data, 'news');

  factory Article.fromJson(
    Map<String, dynamic> json,
    String category,
  ) {
    // Menyiapkan author cadangan dari news_site.
    // Ini diperlukan karena beberapa artikel tidak memiliki
    // informasi authors.
    String authorName = json['news_site'] ?? '-';

    // Memeriksa apakah authors tersedia dan tidak kosong.
    if (json['authors'] is List &&
        (json['authors'] as List).isNotEmpty) {
      final firstAuthor = json['authors'][0];

      // Mengambil nama penulis pertama.
      if (firstAuthor is Map) {
        authorName = firstAuthor['name'] ?? authorName;
      }
    }

    // Membuat objek Article berdasarkan isi JSON.
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '-',
      imageUrl: json['image_url'],
      author: authorName,
      publishedAt: json['published_at'] ?? '-',
      summary: json['summary'] ?? '-',
      url: json['url'] ?? '',

      // Jika kategori diberikan, gunakan kategori tersebut.
      // Jika kosong, ambil kategori dari JSON.
      category: category.isNotEmpty
          ? category
          : (json['category'] ?? ''),
    );
  }

  // ----------------------------------------------------------
  // 4. METHOD: toJson()
  // ----------------------------------------------------------
  // Mengubah objek Article menjadi Map JSON.
  //
  // Dibutuhkan saat menyimpan artikel ke SharedPreferences.
  //
  // fromJson() : JSON menjadi objek.
  // toJson()   : objek menjadi JSON.

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'news_site': author,
      'published_at': publishedAt,
      'summary': summary,
      'url': url,
      'category': category,
    };
  }

  // ----------------------------------------------------------
  // 5. GETTER: formattedDate
  // ----------------------------------------------------------
  // Getter mengolah tanggal agar lebih mudah ditampilkan.
  //
  // Cara memanggil:
  // article.formattedDate
  //
  // Tidak perlu menambahkan tanda kurung karena ini getter.

  String get formattedDate {
    try {
      // Mengubah String tanggal menjadi DateTime.
      final dt = DateTime.parse(publishedAt);

      // Membuat format tanggal:
      // Tahun-Bulan-Tanggal Jam:Menit:Detik
      //
      // padLeft(2, '0') membuat angka menjadi dua digit.
      // Contoh: bulan 5 menjadi 05.

      return '${dt.year}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:'
          '${dt.second.toString().padLeft(2, '0')}Z';
    } catch (_) {
      // Jika tanggal gagal dibaca, tampilkan tanggal asli.
      return publishedAt;
    }
  }

  // ----------------------------------------------------------
  // 6. GETTER: favoriteKey
  // ----------------------------------------------------------
  // Membuat identitas unik untuk setiap artikel favorit.
  //
  // Kategori digabung dengan ID agar artikel dari kategori
  // berbeda tidak dianggap sebagai artikel yang sama.
  //
  // Contoh:
  // news-100
  // blogs-100

  String get favoriteKey => '$category-$id';
}
