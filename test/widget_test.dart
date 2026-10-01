import 'package:flutter_test/flutter_test.dart';
import 'package:social_scheduler/main.dart';

void main() {
  testWidgets('loads the Social Scheduler dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Social Scheduler'), findsOneWidget);
    expect(find.text('Lanzamiento de Producto'), findsOneWidget);
  });
}
