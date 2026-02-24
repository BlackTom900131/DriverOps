import 'package:driversystem/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App boots and shows login screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DriverOpsApp()));
    await tester.pumpAndSettle();

    expect(find.text('Driver Access'), findsOneWidget);
    expect(find.text('Secure login'), findsOneWidget);
  });
}
