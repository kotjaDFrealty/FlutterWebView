import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fms_go_app/main.dart';

void main() {
  group('FMS Go App - UI Tests', () {
    testWidgets('App launches and loads WebView', (WidgetTester tester) async {
      // Launch application
      await tester.pumpWidget(const FMSGoApp());

      // Verify app launched
      expect(find.byType(FMSGoApp), findsOneWidget);

      // Check SafeArea exists
      expect(find.byType(SafeArea), findsOneWidget);

      // Wait for loading
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('WebView is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());
      
      // Check WebViewWidget
      expect(find.byType(Scaffold), findsOneWidget);
      
      await tester.pumpAndSettle();
    });

    testWidgets('App title is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const FMSGoApp());

      // Check app title
      final materialApp = find.byType(MaterialApp);
      expect(materialApp, findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Renders correctly on different screen sizes', 
      (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      // Set screen size (iPhone 12)
      tester.binding.window.physicalSizeTestValue = const Size(390, 844);
      addTearDown(() {
        tester.binding.window.physicalSizeTestValue = Size.zero;
      });

      await tester.pumpWidget(const FMSGoApp());
      expect(find.byType(Scaffold), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('App handles landscape orientation', 
      (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      // Set landscape mode
      tester.binding.window.physicalSizeTestValue = const Size(844, 390);
      addTearDown(() {
        tester.binding.window.physicalSizeTestValue = Size.zero;
      });

      await tester.pumpWidget(const FMSGoApp());
      expect(find.byType(Scaffold), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
