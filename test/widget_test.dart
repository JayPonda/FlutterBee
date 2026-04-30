import 'package:flutter_test/flutter_test.dart';
import 'package:basics/ui/features/phone_book/views/rolodex_app.dart';

void main() {
  testWidgets('RolodexApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RolodexApp());

    // Verify that the app starts with the loader/splash (which eventually leads to AdaptiveLayout)
    // This is a minimal test to ensure the app can at least be pumped without immediate crash
    expect(find.byType(RolodexApp), findsOneWidget);
  });
}
