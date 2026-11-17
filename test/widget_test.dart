import 'package:flutter_test/flutter_test.dart';
import 'package:latihanresponsi/main.dart';

void main() {
  testWidgets('Aplikasi menampilkan halaman Login saat pertama dibuka', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isLoggedIn: false, username: ''));

    // Verifikasi bahwa teks "Silakan Login" muncul di layar
    expect(find.text('Silakan Login'), findsOneWidget);
  });
}