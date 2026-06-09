// This is a basic Flutter widget test for CelenganKu application.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:celenganku/main.dart';

void main() {
  testWidgets('CelenganKu App initial route smoke test', (WidgetTester tester) async {
    // Membangun aplikasi CelenganKu dan memicu frame pertama.
    await tester.pumpWidget(const CelenganKuApp(initialRoute: '/login'));

    // Memverifikasi bahwa aplikasi berhasil memuat halaman awal (SplashScreen)
    // dengan mencari teks placeholder yang sudah kita buat sebelumnya.
    expect(find.text('CelenganKu - Splash Screen'), findsOneWidget);
    
    // Memastikan teks dari template counter bawaan sudah tidak ada.
    expect(find.text('0'), findsNothing);
  });
}