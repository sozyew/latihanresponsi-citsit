# latihanresponsi

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

import pypandoc

readme = r"""# Spaceflight News — Flutter Responsi

Aplikasi Flutter untuk membaca informasi bertema luar angkasa dalam tiga kategori: **News, Blogs, dan Reports**. Aplikasi menyediakan registrasi, login, session lokal, daftar artikel, filter author, halaman detail, tautan ke website sumber, dan daftar Favorite.

> **Catatan penting tentang versi project ini:** meskipun nama servicenya `ApiService` dan project memiliki dependency `http`, implementasi `lib/services/api_service.dart` yang ada pada ZIP ini **belum melakukan HTTP request ke API eksternal**. Data News, Blogs, dan Reports disimpan sebagai data lokal (*hardcoded*) di dalam tiga List. Method `fetchArticles()` hanya memberi jeda 300 milidetik untuk simulasi proses pengambilan data, lalu memilih dataset berdasarkan kategori. Gambar artikel tetap dimuat dari URL internet menggunakan `Image.network` melalui proxy `images.weserv.nl`. Jadi daftar artikelnya lokal, sedangkan gambar dan link sumber membutuhkan internet.

---

## 1. Fitur aplikasi

1. **Register** — membuat akun menggunakan username dan password.
2. **Login** — memeriksa akun yang tersimpan.
3. **Session login** — menyimpan status login dan username menggunakan `SharedPreferences`.
4. **Home** — menampilkan menu News, Blog, Reports, dan Favorite.
5. **Daftar artikel** — menampilkan artikel sesuai kategori.
6. **Filter author** — menyaring daftar artikel berdasarkan author yang dipilih.
7. **Detail artikel** — menampilkan gambar, judul, author, tanggal, ringkasan, dan link sumber.
8. **Favorite** — menambahkan atau menghapus artikel dari daftar Favorite.
9. **Refresh** — menarik daftar artikel ke bawah untuk memuat ulang data.
10. **Logout** — mengakhiri session tanpa menghapus akun yang sudah terdaftar.

## 2. Teknologi dan package

| Teknologi/package | Kegunaan |
|---|---|
| Flutter | Framework untuk membangun aplikasi |
| Dart | Bahasa pemrograman |
| `shared_preferences` | Menyimpan akun, session, dan Favorite secara lokal |
| `url_launcher` | Membuka URL artikel di browser/aplikasi eksternal |
| `flutter_test` | Menjalankan widget test |
| `http` | Sudah tercantum di `pubspec.yaml`, tetapi belum digunakan oleh `ApiService` versi ini |

## 3. Struktur folder project

```text
latihanresponsi-citsit/
│
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │   └── article.dart
│   │
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── favorite_service.dart
│   │
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── home_screen.dart
│   │   ├── list_screen.dart
│   │   ├── detail_screen.dart
│   │   └── favorite_screen.dart
│   │
│   └── widgets/
│       └── article_card.dart
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

### Fungsi setiap file

| File | Tanggung jawab |
|---|---|
| `main.dart` | Titik awal aplikasi, memeriksa session, menentukan halaman pertama, dan mengatur tema |
| `models/article.dart` | Cetakan/struktur data artikel; mengubah Map JSON menjadi objek `Article` dan sebaliknya |
| `services/api_service.dart` | Menyediakan dataset News, Blogs, Reports dan mengubahnya menjadi `List<Article>` |
| `services/auth_service.dart` | Register, login, membaca session, dan logout |
| `services/favorite_service.dart` | Membaca, memeriksa, menambah, dan menghapus Favorite |
| `screens/login_screen.dart` | Form login dan navigasi ke Register/Home |
| `screens/register_screen.dart` | Form registrasi |
| `screens/home_screen.dart` | Menu kategori, akses Favorite, dan Logout |
| `screens/list_screen.dart` | Mengambil data kategori, filter author, loading/error/empty state, refresh, dan navigasi Detail |
| `screens/detail_screen.dart` | Menampilkan detail artikel, mengelola tombol Favorite, dan membuka URL artikel |
| `screens/favorite_screen.dart` | Menampilkan dan menghapus artikel Favorite |
| `widgets/article_card.dart` | Widget card artikel yang dapat dipakai ulang |
| `test/widget_test.dart` | Menguji bahwa aplikasi menampilkan teks Login saat belum ada session |

**Prinsip pembagian kode:** `screens` mengatur halaman dan interaksi pengguna, `services` mengurus proses/data, `models` mendefinisikan bentuk data, sedangkan `widgets` menyimpan komponen tampilan yang digunakan berulang.

---

## 4. Alur aplikasi dari awal sampai akhir

```text
Aplikasi dibuka
      |
      v
main.dart memanggil AuthService
      |
      v
getLoggedInUsername()
      |
      +---- username tersedia ----> HomeScreen
      |
      +---- null -----------------> LoginScreen
                                       |
                          +------------+------------+
                          |                         |
                       Register                   Login
                          |                         |
                          v                         v
                    RegisterScreen             AuthService
                                                    |
                                              Login berhasil
                                                    |
                                                    v
                                                HomeScreen
                                                    |
                    +-------------------------------+-------------------+
                    |                 |                 |               |
                   News              Blog             Reports        Favorite
                    |                 |                 |               |
                    +-----------------+-----------------+               |
                                      |                                  |
                                      v                                  |
                                  ListScreen                              |
                                      |                                  |
                              ApiService.fetchArticles                   |
                                      |                                  |
                              Article.fromJson                           |
                                      |                                  |
                              Filter author                              |
                                      |                                  |
                                ArticleCard                              |
                                      |                                  |
                                 DetailScreen                            |
                                      |                                  |
                           Favorite / Buka website                       |
                                      |                                  |
                                      +---------- FavoriteService <------+
```

### Urutan yang perlu diingat saat responsi

1. `main()` dijalankan.
2. `AuthService` memeriksa apakah ada username yang masih login.
3. `MyApp` memilih `HomeScreen` atau `LoginScreen`.
4. Setelah login berhasil, pengguna masuk ke `HomeScreen`.
5. Pengguna memilih News, Blog, atau Reports.
6. `HomeScreen` mengirim parameter `menu` dan `title` ke `ListScreen`.
7. `ListScreen` memanggil `ApiService.fetchArticles(widget.menu)`.
8. `ApiService` memilih dataset kategori dan mengubah setiap Map menjadi objek `Article`.
9. `ListScreen` membuat daftar author dan menampilkan `ArticleCard`.
10. Card ditekan, objek `Article` dikirim ke `DetailScreen`.
11. Di Detail, pengguna dapat menyimpan Favorite atau membuka URL sumber.
12. `FavoriteService` menyimpan data Favorite di `SharedPreferences`.

---

## 5. Cara kerja halaman Home dan pemilihan kategori

File: `lib/screens/home_screen.dart`

HomeScreen menerima username melalui constructor:

```dart
final String username;

const HomeScreen({
  super.key,
  required this.username,
});
```

Nama pengguna ditampilkan di AppBar:

```dart
title: Text('Hai, $username!'),
```

Ketika menu ditekan, method `_goTo()` membuka `ListScreen` dan mengirim dua parameter:

```dart
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
```

Contoh pemanggilan menu:

```dart
_goTo(context, 'news', 'News');
_goTo(context, 'blogs', 'Blog');
_goTo(context, 'reports', 'Reports');
```

- `menu` dipakai sebagai kunci untuk memilih dataset.
- `title` hanya dipakai sebagai judul AppBar pada halaman daftar.

**Penting:** nilai `menu` harus cocok dengan kondisi di `ApiService`. Di versi ini, kategori yang dikenali adalah `news`, `blogs`/`blog`, dan `reports`/`report`. Jika mengirim nilai yang tidak dikenali, hasilnya List kosong.

---

## 6. Cara kerja data dan ApiService versi project ini

File: `lib/services/api_service.dart`

### 6.1 Data disimpan di mana?

Di dalam method `fetchArticles()` terdapat tiga dataset:

- `dataNews`
- `dataBlogs`
- `dataReports`

Masing-masing berupa `List<Map<String, dynamic>>`. Satu Map mewakili satu artikel. Contoh bentuk satu item:

```dart
{
  "id": 40861,
  "title": "Sentinel-6B in Orbit Around Earth",
  "authors": [{"name": "NASA"}],
  "image_url": "https://contoh-domain/gambar.jpg",
  "news_site": "NASA",
  "summary": "Ringkasan artikel...",
  "published_at": "2026-11-16T18:52:32Z",
  "url": "https://contoh-domain/artikel"
}
```

Nama key harus sesuai dengan yang dibaca oleh `Article.fromJson()`. Misalnya, model membaca `image_url`, bukan `imageUrl`.

### 6.2 Method fetchArticles()

Bentuk method:

```dart
Future<List<Article>> fetchArticles(String menu) async {
  await Future.delayed(const Duration(milliseconds: 300));

  // Dataset lokal didefinisikan di sini.

  final normalizedMenu = menu.trim().toLowerCase();

  List<Map<String, dynamic>> selectedData = [];

  if (normalizedMenu == 'news') {
    selectedData = dataNews;
  } else if (normalizedMenu == 'blogs' ||
      normalizedMenu == 'blog') {
    selectedData = dataBlogs;
  } else if (normalizedMenu == 'reports' ||
      normalizedMenu == 'report') {
    selectedData = dataReports;
  }

  return selectedData
      .map((e) => Article.fromJson(e, normalizedMenu))
      .toList();
}
```

Penjelasan:

1. `Future<List<Article>>` berarti hasil method berupa daftar objek `Article` yang prosesnya asynchronous.
2. `async` memungkinkan penggunaan `await`.
3. `Future.delayed` memberi jeda 300 ms sebagai simulasi proses pengambilan data, bukan request jaringan.
4. `trim()` menghapus spasi di awal/akhir.
5. `toLowerCase()` mengubah kategori menjadi huruf kecil.
6. `if/else if` memilih dataset.
7. `map()` mengubah setiap Map menjadi objek `Article`.
8. `toList()` menghasilkan `List<Article>`.

### 6.3 Kalau ingin menambah atau mengubah data lokal

Buka `lib/services/api_service.dart`, lalu tambahkan satu Map ke List kategori yang tepat. Pastikan key penting tersedia dan formatnya sesuai:

- `id`: angka ID artikel.
- `title`: judul.
- `authors`: List author berbentuk Map dengan key `name`, atau sediakan `news_site` sebagai cadangan.
- `image_url`: URL gambar atau `null`/string kosong.
- `published_at`: tanggal yang dapat dibaca `DateTime.parse`.
- `summary`: ringkasan.
- `url`: link sumber.

Jika ingin kategori baru, lakukan tiga hal:
1. Buat dataset baru.
2. Tambahkan kondisi pemilihan kategori di `fetchArticles()`.
3. Tambahkan menu yang mengirim nama kategori yang sama dari `home_screen.dart`.

---

## 7. Model Article: penghubung data dengan tampilan

File: `lib/models/article.dart`

Model `Article` adalah cetakan objek artikel. Properti yang tersedia:

| Properti | Tipe | Fungsi |
|---|---|---|
| `id` | `int` | ID artikel |
| `title` | `String` | Judul |
| `imageUrl` | `String?` | URL gambar, boleh null |
| `author` | `String` | Nama author/sumber |
| `publishedAt` | `String` | Tanggal publikasi |
| `summary` | `String` | Ringkasan |
| `url` | `String` | Link artikel |
| `category` | `String` | Kategori artikel |

### 7.1 `fromJson()`

```dart
factory Article.fromJson(
  Map<String, dynamic> json,
  String category,
)
```

Tugasnya mengubah Map menjadi objek `Article`. Model mengambil author pertama dari `authors` jika tersedia. Jika `authors` kosong/tidak tersedia, model menggunakan `news_site`; jika itu juga tidak tersedia, nilai default `-`.

Contoh pemanggilan:

```dart
final article = Article.fromJson(dataMap, 'news');
```

### 7.2 `toJson()`

Mengubah objek Article menjadi Map. Method ini dipakai oleh `FavoriteService` ketika menyimpan artikel.

Ingat:
- `fromJson`: Map/JSON → objek `Article`.
- `toJson`: objek `Article` → Map/JSON.

### 7.3 Getter `formattedDate`

Getter mencoba membaca `publishedAt` menggunakan `DateTime.parse()` lalu membentuk tampilan tanggal dan waktu. Jika parsing gagal, getter mengembalikan teks tanggal aslinya.

### 7.4 Getter `favoriteKey`

```dart
String get favoriteKey => '$category-$id';
```

Kategori digabung dengan ID supaya ID yang sama dari kategori berbeda tidak dianggap sebagai artikel yang sama. Contoh: `news-100` dan `blogs-100`.

---

## 8. Logic filter author — bagian yang paling penting untuk dipahami

File: `lib/screens/list_screen.dart`

Filter author **dibuat dan dijalankan di `ListScreen`**, bukan di `ArticleCard` dan bukan di `ApiService`.

State yang digunakan:

```dart
List<Article> _all = [];
List<Article> _filtered = [];
List<String> _authors = [];
String? _selectedAuthor;
```

Fungsi masing-masing:
- `_all`: semua artikel hasil pengambilan kategori.
- `_filtered`: artikel yang saat ini ditampilkan setelah filter.
- `_authors`: daftar nama author unik untuk chip filter.
- `_selectedAuthor`: author yang dipilih; `null` berarti Semua.

### 8.1 Mengumpulkan daftar author

Setelah data diambil, kode membuat Set:

```dart
final Set<String> authors = {};

for (final article in data) {
  if (article.author.isNotEmpty &&
      article.author != '-') {
    authors.add(article.author);
  }
}
```

Kenapa `Set`? Karena Set menyimpan nilai unik. Jika NASA menulis 5 artikel, pilihan filter NASA tetap muncul satu kali.

Setelah itu hasilnya diubah menjadi List:

```dart
_authors = authors.toList();
```

### 8.2 Membuat tombol filter

Di `build()`, `ChoiceChip` pertama adalah pilihan Semua:

```dart
ChoiceChip(
  label: const Text('Semua'),
  selected: _selectedAuthor == null,
  onSelected: (_) {
    _applyFilter(null);
  },
)
```

Chip author dibuat dari `_authors`:

```dart
..._authors.map((author) {
  return ChoiceChip(
    label: Text(author),
    selected: _selectedAuthor == author,
    onSelected: (_) {
      _applyFilter(author);
    },
  );
})
```

`map()` membuat satu chip untuk setiap author. `selected` menentukan chip mana yang terlihat sedang dipilih.

### 8.3 Logika penyaringan sebenarnya

```dart
void _applyFilter(String? author) {
  setState(() {
    _selectedAuthor = author;

    if (author == null) {
      _filtered = _all;
    } else {
      _filtered = _all.where((article) {
        return article.author == author;
      }).toList();
    }
  });
}
```

Penjelasan baris per baris:

1. Method menerima author yang dipilih.
2. `setState()` memberi tahu Flutter bahwa state berubah dan UI perlu dibangun ulang.
3. `_selectedAuthor` diubah agar chip yang tepat menjadi selected.
4. Jika `author == null`, `_filtered` diisi semua artikel.
5. Jika ada author terpilih, `.where()` memeriksa setiap artikel.
6. Artikel yang `article.author == author` dipertahankan.
7. `.toList()` mengubah hasil filter menjadi List.
8. Flutter membangun ulang tampilan dengan isi `_filtered` terbaru.

**Contoh sederhana:** `_all` berisi artikel NASA, ESA, NASA, dan SpaceX. Jika memilih NASA, `_filtered` hanya berisi dua artikel NASA. Jika memilih Semua, `_filtered` kembali berisi keempat artikel.

### 8.4 Kalau dosen meminta filter berdasarkan kategori/judul

- Filter author: ubah/perluas kondisi di `_applyFilter()` pada `list_screen.dart`.
- Filter judul: kondisi dapat memeriksa `article.title.toLowerCase().contains(keyword.toLowerCase())`.
- Filter kategori: periksa `article.category`.
- Jangan mengubah `ArticleCard` untuk mengerjakan filter karena card hanya bertugas menampilkan satu artikel.

---

## 9. Logic card artikel sebelum diklik

File: `lib/widgets/article_card.dart`

`ArticleCard` adalah `StatelessWidget` yang menerima data dan callback dari halaman pemanggil:

```dart
final Article article;
final VoidCallback onTap;
final bool isFavorite;
final VoidCallback? onFavToggle;
```

Artinya:
- `article`: data yang akan ditampilkan.
- `onTap`: aksi ketika area card ditekan.
- `isFavorite`: apakah icon Favorite ditampilkan.
- `onFavToggle`: aksi ketika icon Favorite ditekan; boleh null.

Tampilan card dibuat menggunakan:
- `Card`: wadah dengan latar, margin, dan border.
- `InkWell`: membuat card dapat ditekan.
- `Row`: menyusun gambar dan teks secara horizontal.
- `ClipRRect`: membulatkan sudut gambar.
- `SizedBox`: memberi ukuran/jarak.
- `Expanded`: memberi ruang fleksibel pada teks agar tidak overflow.
- `Text`: menampilkan judul dan author.
- `IconButton`: tombol Favorite jika `isFavorite == true`.

Judul dibatasi dua baris dengan `maxLines: 2` dan `TextOverflow.ellipsis`. Ini mencegah judul panjang memenuhi seluruh card.

### 9.1 Gambar pada card

Method `_buildImage()`:
1. Memeriksa apakah `article.imageUrl` null atau kosong.
2. Jika kosong, mengembalikan `_placeholder()`.
3. Jika ada URL, membentuk URL proxy `images.weserv.nl`.
4. Menampilkan gambar menggunakan `Image.network`.
5. `loadingBuilder` menampilkan area abu-abu selama gambar dimuat.
6. `errorBuilder` menampilkan placeholder jika gambar gagal.

Jadi, **data judul dan author berasal dari objek lokal**, tetapi gambar diunduh dari internet. Jika gambar gagal, card tetap dapat tampil karena ada placeholder.

### 9.2 Card dibuat sebelum diklik dari mana?

Di `list_screen.dart`, `ListView.builder` membuat card untuk setiap artikel:

```dart
return ArticleCard(
  article: article,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(article: article),
      ),
    );
  },
);
```

`ListView.builder` membuat item berdasarkan `itemCount`. Setiap `index` mengambil satu artikel dari `_filtered`. Artikel tersebut diberikan ke `ArticleCard`.

Ketika card ditekan, callback `onTap` dijalankan dan objek artikel yang sama dikirim ke `DetailScreen`.

**Perbedaan penting:**
- `ArticleCard` = tampilan ringkas sebelum diklik.
- `DetailScreen` = tampilan informasi lebih lengkap setelah diklik.
- `ListScreen` = menentukan artikel mana yang menjadi isi card.

---

## 10. Detail artikel dan membuka website

File: `lib/screens/detail_screen.dart`

Detail menerima objek yang dikirim dari List/Favorite:

```dart
final Article article;

const DetailScreen({
  super.key,
  required this.article,
});
```

Karena data sudah dibawa melalui `widget.article`, Detail tidak perlu meminta data artikel lagi ke `ApiService`.

Informasi detail meliputi gambar, judul, author, tanggal, ringkasan, link sumber, dan tombol Favorite.

### Membuka URL

Method `_openUrl()`:
1. Menerima URL berbentuk String.
2. Mengubahnya menjadi `Uri` dengan `Uri.tryParse`.
3. Memeriksa skema URL harus `http` atau `https`.
4. Memanggil `launchUrl()` dari package `url_launcher`.
5. Jika URL tidak valid atau gagal dibuka, aplikasi menampilkan SnackBar error.

`url_launcher` hanya membuka link sumber. Ia tidak mengambil isi artikel ke dalam aplikasi.

---

## 11. Login, Register, Session, dan Logout

File utama: `lib/services/auth_service.dart`

Penyimpanan menggunakan `SharedPreferences`, yaitu penyimpanan key-value lokal pada perangkat.

Key yang dipakai:

```dart
static const String _keyUsers = 'users';
static const String _keyUsername = 'username';
static const String _keyLoggedIn = 'isLoggedIn';
```

### 11.1 Register

`register(username, password)`:
1. Mengambil instance SharedPreferences.
2. Mengambil String akun dari key `users`.
3. Jika belum ada, membuat Map kosong.
4. Jika sudah ada, decode JSON menjadi Map.
5. Memeriksa apakah username sudah digunakan.
6. Jika sudah ada, return `false`.
7. Jika belum, menyimpan pasangan username-password ke Map.
8. Encode Map menjadi JSON String dan menyimpannya.
9. Return `true`.

### 11.2 Login

`login(username, password)`:
1. Mengambil data akun.
2. Jika belum ada data akun, return `false`.
3. Decode JSON menjadi Map.
4. Memeriksa username tersedia dan password cocok.
5. Jika cocok, menyimpan `isLoggedIn = true` dan username.
6. Return `true`; jika tidak cocok, return `false`.

### 11.3 Session saat aplikasi dibuka

`main.dart` memanggil:

```dart
final savedUsername = await auth.getLoggedInUsername();
```

Method `getLoggedInUsername()` memeriksa key `isLoggedIn`. Jika false/tidak ada, ia mengembalikan `null`. Jika true, ia mengembalikan username.

Kemudian `MyApp` menentukan halaman:

```dart
home: initialUsername != null
    ? HomeScreen(username: initialUsername!)
    : const LoginScreen(),
```

Operator `? :` adalah conditional/ternary:
- Kondisi benar → HomeScreen.
- Kondisi salah → LoginScreen.

### 11.4 Logout

`logout()` mengubah `isLoggedIn` menjadi false dan menghapus key username. Data akun `users` tidak dihapus. Setelah logout, `HomeScreen` menghapus halaman navigasi sebelumnya dan mengarahkan pengguna ke Login.

**Catatan keamanan:** implementasi latihan ini menyimpan password sebagai teks biasa dalam SharedPreferences. Ini cocok untuk demonstrasi alur lokal, tetapi bukan praktik aman untuk aplikasi produksi. Aplikasi nyata sebaiknya memakai backend autentikasi dan tidak menyimpan password mentah di perangkat.

---

## 12. Favorite: menyimpan artikel lintas kategori

File: `lib/services/favorite_service.dart`

Favorite disimpan di key `favorites` sebagai `List<String>`. Setiap String berisi JSON dari satu artikel.

### Alur menambahkan Favorite

1. Detail memanggil `_favService.toggleFavorite(widget.article)`.
2. Service mengambil daftar JSON Favorite.
3. Setiap item di-decode menjadi Map.
4. Service mencari artikel yang sama menggunakan gabungan kategori dan ID.
5. Jika ditemukan, artikel dihapus.
6. Jika tidak ditemukan, `article.toJson()` ditambahkan.
7. Data di-encode kembali dan disimpan.

Method `isFavorite()` menggunakan `favoriteKey` untuk memeriksa apakah artikel sudah tersimpan.

`FavoriteScreen` memanggil `getFavorites()`, mengubah setiap JSON menjadi `Article`, lalu menampilkan hasilnya menggunakan `ArticleCard`.

Karena satu daftar Favorite dapat berisi News, Blogs, dan Reports, `favoriteKey` menggabungkan kategori dan ID agar tidak bentrok.

---

## 13. Loading, error, empty state, dan refresh

File: `lib/screens/list_screen.dart`

State yang digunakan:
- `_loading`: proses pengambilan data sedang berjalan.
- `_error`: menyimpan pesan jika proses gagal.
- `_filtered`: data yang akan ditampilkan.

Method `_buildBody()` menentukan tampilan berdasarkan urutan kondisi:

1. Jika `_loading == true`, tampilkan `CircularProgressIndicator`.
2. Jika `_error != null`, tampilkan ikon error, pesan, dan tombol `Coba Lagi`.
3. Jika `_filtered.isEmpty`, tampilkan `Tidak ada data`.
4. Jika data tersedia, tampilkan `ListView.builder` di dalam `RefreshIndicator`.

`RefreshIndicator` menjalankan `_load()` ketika daftar ditarik ke bawah.

**Catatan untuk versi lokal:** blok `try/catch` tetap berguna untuk menangani error dari proses service, tetapi `Future.delayed` bukan request jaringan. Jika kelak memakai API sungguhan, error jaringan, status HTTP, dan parsing JSON perlu ditangani secara eksplisit.

---

## 14. Jika besok diminta mengganti data lokal menjadi API sungguhan

Bagian ini adalah **panduan pengembangan**, bukan deskripsi implementasi yang sudah aktif pada ZIP.

File utama yang perlu diubah:
1. `pubspec.yaml` — pastikan dependency `http` tersedia.
2. `lib/services/api_service.dart` — ganti dataset hardcoded dengan HTTP request.
3. `lib/models/article.dart` — sesuaikan parsing JSON jika struktur API berbeda.
4. `lib/screens/list_screen.dart` — umumnya tidak perlu diubah jika `fetchArticles()` tetap mengembalikan `Future<List<Article>>`.

### 14.1 Pahami struktur JSON API terlebih dahulu

Sebelum coding:
1. Buka endpoint API di browser atau Postman.
2. Lihat apakah respons berupa List langsung atau Map yang memiliki key `results`.
3. Periksa nama key judul, gambar, author, tanggal, ringkasan, URL, dan ID.
4. Periksa apakah author berupa String atau List of Map.
5. Periksa apakah data gambar bisa null.
6. Periksa pagination: apakah semua data ada dalam satu respons atau dibagi beberapa halaman.

Jangan mengasumsikan semua API punya struktur yang sama.

### 14.2 Contoh pola ApiService untuk API dengan `results`

Contoh berikut adalah pola umum. Ganti URL dan key JSON sesuai dokumentasi API yang benar:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class ApiService {
  final String baseUrl = 'https://alamat-api-yang-benar.com';

  Future<List<Article>> fetchArticles(String menu) async {
    final String category = menu.trim().toLowerCase();

    // URL harus disesuaikan dengan endpoint API yang dipakai.
    final uri = Uri.parse('$baseUrl/$category/');

    // Mengirim HTTP GET ke server.
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 15));

    // Memastikan server mengembalikan status sukses.
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data. HTTP ${response.statusCode}',
      );
    }

    // Mengubah teks JSON menjadi struktur Dart.
    final decoded = jsonDecode(response.body);

    // Contoh API yang membungkus daftar pada key "results".
    if (decoded is! Map<String, dynamic> ||
        decoded['results'] is! List) {
      throw const FormatException(
        'Format JSON tidak sesuai: key results tidak ditemukan',
      );
    }

    final List results = decoded['results'];

    // Mengubah setiap item JSON menjadi Article.
    return results.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Format item artikel tidak valid',
        );
      }

      return Article.fromJson(item, category);
    }).toList();
  }
}
```

**Jangan menyalin contoh ini mentah-mentah sebelum memeriksa API.** Endpoint, bentuk respons, pagination, dan nama field harus mengikuti API yang benar.

### 14.3 Jika JSON API berbeda, ubah Article.fromJson()

Contoh perbedaan yang mungkin terjadi:

| Bentuk API | Penyesuaian di model |
|---|---|
| `image_url` | Baca `json['image_url']` |
| `imageUrl` | Baca `json['imageUrl']` |
| `summary` | Baca `json['summary']` |
| `description` | Baca `json['description']` |
| `authors: [{"name":"NASA"}]` | Ambil `authors[0]['name']` |
| `author: "NASA"` | Ambil langsung String `author` |
| `results: [...]` | Ambil list dari `decoded['results']` |
| Respons berupa `[...]` | Decode langsung sebagai List |

Contoh jika API memberikan author sebagai String:

```dart
author: json['author'] ?? '-',
```

Contoh jika API memberikan `description`, bukan `summary`:

```dart
summary: json['description'] ?? '-',
```

Sesuaikan juga `toJson()` jika nama field penyimpanan perlu konsisten. Pastikan data Favorite lama tetap bisa dibaca atau lakukan migrasi/bersihkan data uji jika format berubah.

### 14.4 Checklist agar data API bisa muncul

- [ ] URL endpoint benar dan bisa dibuka.
- [ ] Method HTTP sesuai dokumentasi, biasanya GET untuk membaca data.
- [ ] Status response berhasil, biasanya 200.
- [ ] Respons JSON di-decode dengan benar.
- [ ] Lokasi daftar data benar (`results`, `data`, atau List langsung).
- [ ] Nama key sesuai dengan `Article.fromJson()`.
- [ ] Tipe data sesuai (ID angka/string, author String/List, dan sebagainya).
- [ ] Nilai null ditangani dengan aman.
- [ ] Kategori yang dikirim dari Home cocok dengan endpoint.
- [ ] Pagination diperiksa jika API membatasi jumlah hasil.
- [ ] Izin internet dan konfigurasi platform diperiksa jika aplikasi tidak bisa mengakses jaringan.
- [ ] Loading, error, dan empty state diuji.
- [ ] Jalankan `flutter analyze` dan `flutter test`.

### 14.5 Penyebab umum data API tidak muncul

| Gejala | Kemungkinan penyebab | Yang dicek |
|---|---|---|
| Daftar kosong | Kategori tidak cocok | Nilai `menu` di Home dan kondisi service |
| Daftar kosong | Salah mengambil lokasi array | Apakah data berada di `results`, `data`, atau root List |
| Error parsing | Key/tipe JSON berbeda | `Article.fromJson()` |
| HTTP 404 | Endpoint salah | Dokumentasi URL endpoint |
| HTTP 401/403 | API memerlukan autentikasi/akses | API key, token, header |
| Timeout | Server lambat/koneksi bermasalah | Timeout, koneksi, status server |
| Judul tampil tapi author `-` | Struktur author tidak sesuai | Field `authors`, `author`, atau `news_site` |
| Gambar tidak tampil | URL kosong, URL tidak publik, atau host menolak | `image_url`, browser, `errorBuilder` |
| Data hanya sebagian | API memakai pagination | `next`, `limit`, `offset`, atau page |
| Data lama tetap tampil | Dataset lokal masih dipakai | Pastikan method service sudah benar-benar memakai HTTP |

### 14.6 Strategi debugging API

Untuk sementara, tampilkan informasi berikut saat debugging:
- `response.statusCode`
- sebagian `response.body`
- URL endpoint yang dipanggil
- jumlah item hasil parsing

Jangan menampilkan token rahasia/API key di log atau mengunggahnya ke GitHub.

Jika parsing gagal, periksa contoh JSON mentah lebih dahulu. Jangan langsung mengubah UI karena masalah sering terjadi di service atau model.

---

## 15. Cara menjalankan project

Pastikan Flutter dan Dart sudah terpasang, kemudian buka terminal di folder project:

```powershell
cd C:\src\latihanresponsi-citsit
```

Ambil dependency:

```powershell
flutter pub get
```

Jalankan aplikasi di browser:

```powershell
flutter run -d web-server
```

Periksa kode:

```powershell
flutter analyze
```

Jalankan pengujian:

```powershell
flutter test
```

Pada project ini, widget test memeriksa bahwa `MyApp(initialUsername: null)` menampilkan teks `Silakan Login`.

---

## 16. Cara push project ke GitHub dari awal

### 16.1 Pastikan berada di folder yang benar

```powershell
cd C:\src\latihanresponsi-citsit
Get-Location
```

Hasil yang diharapkan:

```text
C:\src\latihanresponsi-citsit
```

### 16.2 Periksa remote

```powershell
git remote -v
```

Remote project ini:

```text
origin  https://github.com/sozyew/latihanresponsi-citsit.git (fetch)
origin  https://github.com/sozyew/latihanresponsi-citsit.git (push)
```

Jika belum ada remote:

```powershell
git remote add origin https://github.com/sozyew/latihanresponsi-citsit.git
```

Jika remote salah:

```powershell
git remote set-url origin https://github.com/sozyew/latihanresponsi-citsit.git
```

### 16.3 Periksa branch dan perubahan

```powershell
git branch --show-current
git status -sb
```

Branch project ini adalah `main`.

### 16.4 Simpan perubahan ke staging

```powershell
git add .
```

### 16.5 Buat commit

```powershell
git commit -m "Update Flutter responsi application"
```

Commit adalah rekaman perubahan di repository lokal.

### 16.6 Push ke GitHub

```powershell
git push -u origin main
```

Untuk push berikutnya setelah branch sudah terhubung, biasanya cukup:

```powershell
git add .
git commit -m "Deskripsi perubahan"
git push
```

### 16.7 Arti pesan terminal yang penting

- `nothing to commit, working tree clean`: tidak ada perubahan lokal yang belum di-commit.
- `[main abc1234] ...`: commit berhasil dibuat.
- `main -> main`: branch lokal berhasil dikirim ke remote.
- `branch 'main' set up to track 'origin/main'`: branch lokal sudah melacak branch remote.
- `LF will be replaced by CRLF`: warning format akhir baris, bukan otomatis error.
- `rejected`: push ditolak; baca alasan, jangan langsung force push.
- `Everything up-to-date`: tidak ada commit baru yang perlu dikirim.

**Repository project:** https://github.com/sozyew/latihanresponsi-citsit

---

## 17. Bagian kode yang harus dibuka jika ada instruksi perubahan

| Instruksi dosen | File utama yang dibuka |
|---|---|
| Mengubah warna/tema aplikasi | `main.dart` |
| Mengubah menu News/Blog/Reports | `home_screen.dart` |
| Mengubah sumber data atau endpoint | `api_service.dart` |
| Mengubah struktur/field artikel | `article.dart` |
| Menambah filter author | `list_screen.dart` |
| Mengubah tampilan card | `article_card.dart` |
| Mengubah isi halaman detail | `detail_screen.dart` |
| Mengubah proses login | `login_screen.dart`, `auth_service.dart` |
| Mengubah proses register | `register_screen.dart`, `auth_service.dart` |
| Mengubah session/logout | `auth_service.dart`, `main.dart`, `home_screen.dart` |
| Mengubah penyimpanan Favorite | `favorite_service.dart` |
| Mengubah halaman Favorite | `favorite_screen.dart` |
| Mengubah pengujian | `test/widget_test.dart` |
| Menambah/mengubah package | `pubspec.yaml`, lalu `flutter pub get` |

## 18. Pertanyaan responsi yang mungkin ditanyakan

### A. Struktur dan konsep Flutter

**1. Apa fungsi `main.dart`?**  
Sebagai titik awal aplikasi. File ini memeriksa session login, menjalankan `runApp()`, dan menentukan halaman pertama.

**2. Apa perbedaan StatelessWidget dan StatefulWidget?**  
`StatelessWidget` digunakan ketika widget tidak mengelola state yang berubah. `StatefulWidget` digunakan ketika tampilan perlu diperbarui berdasarkan perubahan state, misalnya loading, filter, dan Favorite.

**3. Apa fungsi `setState()`?**  
Memberi tahu Flutter bahwa state berubah sehingga widget perlu dibangun ulang.

**4. Apa fungsi `initState()`?**  
Lifecycle method yang dijalankan satu kali ketika State dibuat. Di `ListScreen`, method ini memanggil `_load()` agar data diambil saat halaman dibuka.

**5. Apa fungsi `dispose()`?**  
Membersihkan resource seperti `TextEditingController` ketika State tidak digunakan lagi.

### B. Data, model, dan filter

**6. Apa fungsi model `Article`?**  
Menjadi bentuk standar data artikel agar halaman tidak perlu membaca Map mentah terus-menerus.

**7. Apa perbedaan `fromJson()` dan `toJson()`?**  
`fromJson()` mengubah Map JSON menjadi objek Article. `toJson()` mengubah objek Article menjadi Map agar dapat disimpan.

**8. Di mana filter author dibuat?**  
Di `list_screen.dart`, pada `_applyFilter()`. Daftar pilihan author dikumpulkan dari data dan dibuat menjadi `ChoiceChip`.

**9. Apa fungsi `where()`?**  
Menyaring elemen List berdasarkan kondisi. Di project ini, hanya artikel dengan author sama dengan pilihan pengguna yang dipertahankan.

**10. Kenapa menggunakan Set untuk daftar author?**  
Agar nama author tidak berulang.

**11. Apa fungsi `ListView.builder`?**  
Membangun item daftar sesuai kebutuhan berdasarkan `itemCount` dan `itemBuilder`.

**12. Kenapa kategori dikirim dari Home ke ListScreen?**  
Agar ListScreen dan ApiService tahu dataset mana yang harus ditampilkan.

### C. Card, navigasi, dan Favorite

**13. Di mana tampilan card artikel dibuat?**  
Di `widgets/article_card.dart`. Widget ini menerima objek Article dan callback.

**14. Apa yang terjadi ketika card ditekan?**  
Callback `onTap` menjalankan `Navigator.push()` dan mengirim objek Article ke DetailScreen.

**15. Kenapa DetailScreen tidak mengambil data lagi?**  
Karena objek artikel sudah dikirim dari halaman sebelumnya melalui constructor.

**16. Apa fungsi `VoidCallback`?**  
Tipe fungsi tanpa parameter dan tanpa nilai balik. Di card, callback ini dipakai untuk aksi ketika card ditekan.

**17. Bagaimana Favorite membedakan artikel?**  
Dengan `favoriteKey`, yaitu gabungan kategori dan ID artikel.

### D. Penyimpanan dan asynchronous

**18. Apa itu SharedPreferences?**  
Penyimpanan key-value sederhana di perangkat untuk data lokal seperti session dan Favorite.

**19. Apa fungsi `async` dan `await`?**  
Digunakan untuk menjalankan dan menunggu proses asynchronous tanpa memblokir alur utama aplikasi.

**20. Kenapa method register/login menggunakan Future?**  
Karena membaca dan menulis SharedPreferences membutuhkan proses asynchronous.

**21. Apakah password di project ini sudah aman untuk produksi?**  
Belum. Password disimpan sebagai teks biasa di SharedPreferences. Untuk aplikasi produksi perlu sistem autentikasi backend dan penyimpanan yang aman.

### E. Pertanyaan khusus API

**22. Apakah project ini sudah mengambil data dari API live?**  
Belum. Dataset artikel saat ini hardcoded di `api_service.dart`. Method `fetchArticles()` memilih dataset lokal dan mensimulasikan jeda 300 milidetik.

**23. Kalau besok API diganti, file mana yang diubah?**  
Pertama `api_service.dart` untuk request HTTP dan parsing respons. Jika struktur JSON berbeda, `article.dart` juga harus disesuaikan. `ListScreen` bisa tetap digunakan jika service masih mengembalikan `Future<List<Article>>`.

**24. Kenapa data API bisa gagal muncul?**  
Bisa karena URL salah, status HTTP bukan sukses, bentuk JSON berbeda, nama key tidak cocok, data null, pagination, atau koneksi bermasalah.

**25. Bagaimana memastikan API berhasil?**  
Periksa URL, status code, bentuk JSON mentah, lokasi list data, hasil parsing, dan jumlah item sebelum menghubungkannya ke UI.

---

## 19. Tips menjawab dan mengerjakan instruksi dosen

1. **Dengarkan kata kunci instruksi.** Misalnya “filter” berarti mulai dari `list_screen.dart`; “card” berarti `article_card.dart`; “API” berarti `api_service.dart`.
2. **Cari alur data sebelum mengubah kode.** Ikuti dari Home → ListScreen → ApiService → Article → ArticleCard.
3. **Jangan mengubah semua file sekaligus.** Ubah bagian yang memang bertanggung jawab atas fitur tersebut.
4. **Pertahankan tipe data.** Jika widget membutuhkan `List<Article>`, jangan mengembalikan `List<Map<String, dynamic>>` tanpa mengubah pemanggilnya.
5. **Periksa nama kategori.** `news`, `blogs`, dan `reports` harus cocok antara Home dan service.
6. **Periksa struktur JSON sebelum parsing.** Jangan menebak nama field API.
7. **Gunakan `setState()` untuk state yang berubah.** Contohnya filter, loading, dan status Favorite.
8. **Tangani data kosong dan null.** Jangan menganggap semua artikel pasti punya gambar atau author.
9. **Setelah mengubah kode, jalankan `flutter analyze`.**
10. **Jika memungkinkan, jalankan `flutter test` dan coba alur aplikasi secara langsung.**
11. **Jelaskan alasan perubahan.** Jangan hanya mengatakan “saya mengganti kode”; jelaskan input, proses, dan outputnya.

### Rumus singkat menjelaskan fitur

Saat dosen bertanya, jawab dengan pola:

- **Lokasi:** file yang mengerjakan fitur.
- **Input:** data/parameter yang diterima.
- **Proses:** method atau kondisi yang dijalankan.
- **Output:** perubahan tampilan atau data yang dihasilkan.

Contoh jawaban filter:

“Filter author ada di `list_screen.dart`. Data awal disimpan di `_all`, daftar author unik dikumpulkan menggunakan Set, lalu pilihan ditampilkan dengan `ChoiceChip`. Saat author dipilih, `_applyFilter()` memakai `where()` untuk menyaring artikel dan menyimpan hasilnya ke `_filtered`. `setState()` membuat daftar tampil ulang.”

---

## 20. Ringkasan hafalan 1 menit

- `main.dart` = mulai aplikasi dan cek session.
- `auth_service.dart` = register, login, logout.
- `home_screen.dart` = menu kategori.
- `api_service.dart` = dataset lokal dan pemilihan kategori.
- `article.dart` = model artikel dan konversi JSON.
- `list_screen.dart` = ambil data, filter author, dan daftar artikel.
- `article_card.dart` = tampilan ringkas artikel.
- `detail_screen.dart` = detail, Favorite, dan buka link.
- `favorite_service.dart` = penyimpanan Favorite.
- `favorite_screen.dart` = daftar Favorite.
- `widget_test.dart` = pengujian halaman awal Login.

**Alur data utama:**

`HomeScreen → ListScreen → ApiService → Article.fromJson() → List<Article> → ArticleCard → DetailScreen`

**Alur filter:**

`_all → _authors → ChoiceChip → _applyFilter() → _filtered → ListView.builder`

**Ingat:** pada versi ZIP ini, daftar News/Blogs/Reports masih menggunakan dataset lokal. Jangan menjawab dosen bahwa aplikasi sudah melakukan HTTP request live, karena implementasi `ApiService` yang sekarang belum melakukannya.
"""

out="/mnt/data/README.md"
pypandoc.convert_text(readme, "md", format="md", outputfile=out, extra_args=["--standalone"])
print(f"README berhasil dibuat: {out}\nUkuran: {os.path.getsize(out):,} bytes\nBagian: {readme.count(chr(10) + '## ')} heading utama")

## 14.7 Menggunakan API Tanpa Membuat Dataset JSON Manual

Pada aplikasi ini, data artikel saat ini masih menggunakan dataset lokal yang ditulis langsung di dalam `ApiService`. Namun, jika nantinya diminta menggunakan API sungguhan, data tidak perlu dibuat atau ditulis manual dalam bentuk JSON.

API akan mengirimkan data dalam format JSON melalui endpoint. Aplikasi cukup melakukan HTTP request, menerima response, mengubah JSON menjadi objek `Article`, kemudian menampilkan data tersebut.

### Alur Pengambilan Data dari API

```text
ListScreen
    |
    v
ApiService
    |
    v
http.get(endpoint)
    |
    v
Server API
    |
    v
JSON Response
    |
    v
jsonDecode()
    |
    v
Article.fromJson()
    |
    v
List<Article>
    |
    v
ListScreen
    |
    v
ArticleCard
```

### Contoh Implementasi API Menggunakan HTTP GET

Jika API mengembalikan JSON berbentuk List secara langsung, implementasinya dapat ditulis seperti berikut:

```dart
static Future<List<Article>> fetchArticles() async {
  final response = await http.get(
    Uri.parse('https://example.com/api/articles'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);

    return data.map((item) {
      return Article.fromJson(item);
    }).toList();
  } else {
    throw Exception('Gagal mengambil data artikel');
  }
}
```

**Penjelasan:**

1. `http.get()` digunakan untuk meminta data dari endpoint API.
2. `response.statusCode` digunakan untuk memeriksa apakah request berhasil.
3. `jsonDecode(response.body)` mengubah response JSON menjadi objek Dart.
4. `Article.fromJson(item)` mengubah setiap data JSON menjadi objek `Article`.
5. `.toList()` mengubah hasil pemetaan menjadi `List<Article>`.

> Catatan: `https://example.com/api/articles` hanya contoh endpoint. URL tersebut harus diganti dengan endpoint API yang sebenarnya.

### Contoh Bentuk Response JSON

API dapat mengembalikan data dengan bentuk List langsung:

```json
[
  {
    "id": 1,
    "title": "Contoh Judul Artikel",
    "authors": [
      {
        "name": "John Doe"
      }
    ],
    "image_url": "https://example.com/image.jpg",
    "news_site": "Example News",
    "summary": "Contoh ringkasan artikel.",
    "published_at": "2026-11-18T10:00:00Z",
    "url": "https://example.com/article",
    "category": "News"
  }
]
```

Namun, beberapa API membungkus data artikel di dalam key tertentu, misalnya `results`:

```json
{
  "results": [
    {
      "id": 1,
      "title": "Contoh Judul Artikel"
    }
  ]
}
```

Jika bentuk response seperti ini, bagian parsing perlu disesuaikan:

```dart
final Map<String, dynamic> data = jsonDecode(response.body);

final List articles = data['results'];

return articles.map((item) {
  return Article.fromJson(item);
}).toList();
```

Jadi, cara membaca response bergantung pada struktur JSON yang diberikan oleh API.

---

## 14.8 Fungsi Article.fromJson()

`Article.fromJson()` berfungsi untuk mengubah data JSON menjadi objek `Article` agar dapat digunakan oleh aplikasi Flutter.

Contoh:

```dart
factory Article.fromJson(Map<String, dynamic> json) {
  return Article(
    id: json['id'],
    title: json['title'],
    authors: json['authors']?[0]?['name'] ?? 'Unknown',
    imageUrl: json['image_url'] ?? '',
    newsSite: json['news_site'] ?? 'Unknown',
    summary: json['summary'] ?? '',
    publishedAt: json['published_at'] ?? '',
    url: json['url'] ?? '',
    category: json['category'] ?? '',
  );
}
```

**Hal yang perlu diperhatikan:**

- Nama key pada JSON harus disesuaikan dengan field yang dibaca di `Article.fromJson()`.
- Jika nama field dari API berbeda, bagian pemetaan perlu diubah.
- Operator `??` digunakan untuk memberikan nilai pengganti jika data bernilai `null`.
- Jika struktur JSON berubah, proses parsing juga harus disesuaikan.

Dengan demikian, data dari API dapat diubah menjadi objek yang memiliki struktur sesuai kebutuhan aplikasi.

---

## 14.9 Apakah ListScreen Harus Diubah Ketika Menggunakan API?

Tidak selalu. Jika `ApiService` tetap mengembalikan data dengan tipe:

```dart
Future<List<Article>>
```

maka `ListScreen` tetap dapat menggunakan hasilnya seperti sebelumnya.

Contohnya:

```dart
final articles = await ApiService.fetchArticles();
```

Artinya, bagian yang perlu diubah terutama adalah proses pengambilan data di `ApiService`, bukan keseluruhan tampilan aplikasi.

Selama data yang dikembalikan tetap berupa `List<Article>`, proses filter, pembuatan card, dan navigasi detail dapat tetap menggunakan struktur yang sudah ada.

---

## 14.10 Catatan Implementasi pada Project

Pada versi project ini, data News, Blogs, dan Reports masih menggunakan dataset lokal yang terdapat di `ApiService`.

Contoh penggunaan `http.get()` pada bagian sebelumnya merupakan gambaran apabila aplikasi nantinya dikembangkan menggunakan API sungguhan. Contoh tersebut belum menjadi implementasi aktif pada versi project saat ini.

**Kesimpulan:**

- Dataset lokal: data ditulis dan disediakan langsung oleh aplikasi.
- API sungguhan: data diambil dari server melalui HTTP request.
- JSON: format data yang diterima dari server.
- `jsonDecode()`: mengubah JSON menjadi objek Dart.
- `Article.fromJson()`: mengubah data JSON menjadi objek `Article`.
- `List<Article>`: hasil akhir yang digunakan untuk menampilkan artikel pada aplikasi.
