import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('the Phase 0 smoke widget mounts', (tester) async {
    await tester.pumpWidget(const LemonSmoke());

    expect(find.byType(LemonSmoke), findsOneWidget);
  });
}
