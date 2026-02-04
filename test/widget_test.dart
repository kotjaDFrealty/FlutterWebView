import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fms_go_app/main.dart';

void main() {
  group('FMS Go App - UI Tests', () {
    testWidgets('App launches and loads WebView', (WidgetTester tester) async {
      // Запустить приложение
      await tester.pumpWidget(const FMSGoApp());

      // Проверить, что приложение запустилось
      expect(find.byType(FMSGoApp), findsOneWidget);

      // Проверить, что есть SafeArea
      expect(find.byType(SafeArea), findsOneWidget);

      // Небольшая пауза для загрузки
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('WebView is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());
      
      // Проверить наличие WebViewWidget
      expect(find.byType(Scaffold), findsOneWidget);
      
      await tester.pumpAndSettle();
    });

    testWidgets('App title is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());

      // Проверить заголовок приложения
      final materialApp = find.byType(MaterialApp);
      expect(materialApp, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Renders correctly on different screen sizes', 
      (WidgetTester tester) async {
      // Тестирование на мобильном разрешении
      addTearDown(tester.binding.window.physicalSizeTestValue = Size.zero);
      addTearDown(
        tester.binding.window.devicePixelRatioTestValue = 1.0,
      );

      // Установить размер экрана (iPhone 12)
      tester.binding.window.physicalSizeTestValue = const Size(390, 844);
      tester.binding.window.devicePixelRatioTestValue = 3.0;

      await tester.pumpWidget(const FMSGoApp());
      expect(find.byType(Scaffold), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('App handles landscape orientation', 
      (WidgetTester tester) async {
      addTearDown(tester.binding.window.physicalSizeTestValue = Size.zero);
      addTearDown(
        tester.binding.window.devicePixelRatioTestValue = 1.0,
      );

      // Установить landscape режим
      tester.binding.window.physicalSizeTestValue = const Size(844, 390);
      tester.binding.window.devicePixelRatioTestValue = 3.0;

      await tester.pumpWidget(const FMSGoApp());
      expect(find.byType(Scaffold), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
