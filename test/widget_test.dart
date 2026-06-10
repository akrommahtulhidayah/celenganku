import 'package:flutter_test/flutter_test.dart';
import 'package:celenganku/main.dart';

void main() {
  testWidgets(
    'CelenganKu App smoke test',
    (WidgetTester tester) async {

      await tester.pumpWidget(
        const CelenganKuApp(
          isLoggedIn: false,
        ),
      );

      expect(find.text('Masuk Aplikasi'), findsOneWidget);
    },
  );
}