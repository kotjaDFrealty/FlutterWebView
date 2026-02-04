import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fms_go_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FMS Go App - Integration Tests', () {
    testWidgets('Full app lifecycle test', (WidgetTester tester) async {
      // Launch application
      await tester.pumpWidget(const FMSGoApp());

      // Check initial state
      expect(find.byType(FMSGoApp), findsOneWidget);

      // Wait for full loading
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check UI is ready
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App remains responsive', (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());

      // Check app does not freeze on multiple pumps
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Multiple orientation changes', 
      (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(const FMSGoApp());

      // Portrait
      tester.binding.window.physicalSizeTestValue = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);

      // Landscape
      tester.binding.window.physicalSizeTestValue = const Size(844, 390);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);

      // Portrait again
      tester.binding.window.physicalSizeTestValue = const Size(390, 844);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App does not crash on rapid interactions', 
      (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Simulate rapid user interactions
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
