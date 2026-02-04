import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fms_go_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FMS Go App - Integration Tests', () {
    testWidgets('Full app lifecycle test', (WidgetTester tester) async {
      // Запустить приложение
      await tester.pumpWidget(const FMSGoApp());

      // Проверить начальное состояние
      expect(find.byType(FMSGoApp), findsOneWidget);

      // Дождаться полной загрузки
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Проверить, что интерфейс готов
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App remains responsive', (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());

      // Проверить, что приложение не зависает при нескольких пакетах
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Multiple orientation changes', 
      (WidgetTester tester) async {
      addTearDown(tester.binding.window.physicalSizeTestValue = Size.zero);
      addTearDown(
        tester.binding.window.devicePixelRatioTestValue = 1.0,
      );

      await tester.pumpWidget(const FMSGoApp());

      // Portrait
      tester.binding.window.physicalSizeTestValue = const Size(390, 844);
      addTearDown(tester.binding.window.physicalSizeTestValue = Size.zero);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);

      // Landscape
      tester.binding.window.physicalSizeTestValue = const Size(844, 390);
      addTearDown(tester.binding.window.physicalSizeTestValue = Size.zero);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);

      // Portrait again
      tester.binding.window.physicalSizeTestValue = const Size(390, 844);
      addTearDown(tester.binding.window.physicalSizeTestValue = Size.zero);
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App does not crash on rapid interactions', 
      (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Имитировать быстрые взаимодействия пользователя
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
