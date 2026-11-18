
// ============================================================
// FILE: widget_test.dart
// LOKASI: test/widget_test.dart
//
// FUNGSI:
// Menguji apakah aplikasi menampilkan halaman Login
// ketika pertama kali dibuka dan belum ada session login.
// ============================================================

// Mengimpor package Flutter Test.
// Digunakan untuk menjalankan pengujian widget.
import 'package:flutter_test/flutter_test.dart';

// Mengimpor file main.dart dari project.
// File ini berisi class MyApp yang akan diuji.
import 'package:latihanresponsi_citsit/main.dart';

// Fungsi utama untuk menjalankan pengujian.
void main() {

  // testWidgets digunakan untuk menguji tampilan widget Flutter.
  // Parameter pertama merupakan nama pengujian.
  testWidgets(
    'Aplikasi menampilkan halaman Login saat pertama dibuka',

    // WidgetTester digunakan untuk membangun dan menguji widget.
    (WidgetTester tester) async {

      // Menampilkan widget MyApp ke dalam proses pengujian.
      //
      // initialUsername: null berarti belum ada username
      // yang tersimpan atau belum ada session login.
      //
      // Berdasarkan main.dart:
      // Jika initialUsername null, aplikasi menampilkan LoginScreen.
      await tester.pumpWidget(
        const MyApp(
          initialUsername: null,
        ),
      );

      // find.text digunakan untuk mencari teks tertentu
      // pada tampilan aplikasi.
      //
      // expect digunakan untuk memeriksa hasil pengujian.
      //
      // findsOneWidget berarti teks "Silakan Login"
      // harus ditemukan tepat satu kali.
      expect(
        find.text('Silakan Login'),
        findsOneWidget,
      );
    },
  );
}
