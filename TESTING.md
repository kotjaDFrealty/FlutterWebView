# Автотестирование UI в GitHub Actions

## ?? Типы тестов в Flutter

### 1. **Unit Tests** (модульные тесты)
Тестируют отдельные функции и классы

```dart
test('Counter increments', () {
  int counter = 0;
  counter++;
  expect(counter, 1);
});
```

### 2. **Widget Tests** (тесты интерфейса)
Тестируют Flutter виджеты

```dart
testWidgets('Counter displays', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.text('0'), findsOneWidget);
});
```

### 3. **Integration Tests** (интеграционные тесты)
Тестируют полный функционал приложения

```dart
testWidgets('User can tap button', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});
```

---

## ?? Запуск тестов локально

### Запустить все тесты

```bash
flutter test
```

### Запустить конкретный тестовый файл

```bash
flutter test test/widget_test.dart
```

### Запустить интеграционные тесты

```bash
flutter test integration_test/app_test.dart
```

### С подробным выводом

```bash
flutter test --verbose
```

### Генерировать отчет о покрытии

```bash
flutter test --coverage
pub global activate coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## ?? GitHub Actions Workflow

### Что делает workflow?

1. ? **Запускает все тесты** при push в main/master
2. ? **Проверяет код** (lint, formatting)
3. ? **Генерирует отчет о покрытии** (coverage)
4. ? **Загружает артефакты** для скачивания
5. ? **Комментирует PR** с результатами

### Просмотр результатов

#### На GitHub:

1. Откройте репозиторий
2. Перейдите в **"Actions"**
3. Кликните на последний запуск workflow
4. Смотрите логи в соответствующих job'ах

#### Скачивание артефактов:

1. Откройте workflow запуск
2. Прокрутите вниз до **"Artifacts"**
3. Скачайте:
   - `test-results` - результаты тестов
   - `coverage-report` - отчет о покрытии

---

## ?? Написание тестов

### Простой Widget Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fms_go_app/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    // Запустить приложение
    await tester.pumpWidget(const FMSGoApp());
    
    // Проверить наличие виджета
    expect(find.byType(FMSGoApp), findsOneWidget);
  });
}
```

### Тестирование нажатия на кнопку

```dart
testWidgets('Button tap increments counter', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Нажать на кнопку
  await tester.tap(find.byType(FloatingActionButton));
  
  // Дождаться перестроения
  await tester.pump();
  
  // Проверить результат
  expect(find.text('1'), findsOneWidget);
});
```

### Тестирование навигации

```dart
testWidgets('Navigate to settings', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Найти и нажать кнопку Settings
  await tester.tap(find.byIcon(Icons.settings));
  
  // Дождаться анимации
  await tester.pumpAndSettle();
  
  // Проверить, что мы на новом экране
  expect(find.byType(SettingsPage), findsOneWidget);
});
```

### Тестирование экранов разных размеров

```dart
testWidgets('Responsive design', (WidgetTester tester) async {
  // Установить размер экрана (iPhone 12)
  addTearDown(tester.binding.window.physicalSizeTestValue = Size.zero);
  tester.binding.window.physicalSizeTestValue = const Size(390, 844);
  addTearDown(tester.binding.window.devicePixelRatioTestValue = 1.0);
  
  await tester.pumpWidget(const MyApp());
  expect(find.byType(Scaffold), findsOneWidget);
});
```

### Тестирование текстовых полей

```dart
testWidgets('Enter text in TextField', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Найти поле ввода
  final textField = find.byType(TextField);
  
  // Нажать на поле
  await tester.tap(textField);
  
  // Ввести текст
  await tester.typeText(textField, 'Hello World');
  
  // Проверить текст
  expect(find.text('Hello World'), findsOneWidget);
});
```

---

## ?? Best Practices

### 1. Используйте Finder для поиска виджетов

```dart
// ? Плохо - может быть нестабильным
await tester.tap(find.byType(Button));

// ? Хорошо - явно указываем
await tester.tap(find.byKey(const Key('submitButton')));
```

### 2. Всегда дождитесь завершения анимации

```dart
// ? Плохо - может быть еще анимация
await tester.pump();

// ? Хорошо - ждет всех анимаций
await tester.pumpAndSettle();
```

### 3. Используйте группировку тестов

```dart
group('Login Screen', () {
  testWidgets('Shows login form', (WidgetTester tester) async {
    // ...
  });

  testWidgets('Validates email', (WidgetTester tester) async {
    // ...
  });

  testWidgets('Login succeeds', (WidgetTester tester) async {
    // ...
  });
});
```

### 4. Мокируйте сетевые запросы

```dart
import 'package:mockito/mockito.dart';

class MockApiService extends Mock implements ApiService {}

testWidgets('Displays data from API', (WidgetTester tester) async {
  final mockApi = MockApiService();
  when(mockApi.fetchData()).thenAnswer((_) => Future.value(mockData));
  
  await tester.pumpWidget(MyApp(apiService: mockApi));
  await tester.pumpAndSettle();
  
  expect(find.text('Expected Data'), findsOneWidget);
});
```

### 5. Тестируйте обработку ошибок

```dart
testWidgets('Shows error message on API failure', 
  (WidgetTester tester) async {
  final mockApi = MockApiService();
  when(mockApi.fetchData())
    .thenThrow(Exception('Network error'));
  
  await tester.pumpWidget(MyApp(apiService: mockApi));
  await tester.pumpAndSettle();
  
  expect(find.text('Network error'), findsOneWidget);
});
```

---

## ?? Метрики и Отчеты

### Покрытие кода (Code Coverage)

```bash
# Сгенерировать отчет
flutter test --coverage

# Просмотреть в браузере
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

Цель: **минимум 80% покрытия**

### Фиксация регрессии

Сохраняйте скриншоты:

```dart
await expectLater(
  find.byType(MyWidget),
  matchesGoldenFile('my_widget.png'),
);
```

---

## ?? Отладка тестов

### Вывести виджет в консоль

```dart
debugPrint(tester.getSemantics(find.byType(Text)).toString());
```

### Пауза в тесте

```dart
await Future.delayed(const Duration(seconds: 5));
```

### Вывести дерево виджетов

```dart
addTearDown(tester.printToConsole);
```

### Запустить тест в режиме отладки

```bash
flutter test --verbose -d linux test/widget_test.dart
```

---

## ?? Решение проблем

### "Could not find any widgets matching..."

Убедитесь, что:
- Виджет отрендерился (`pumpAndSettle`)
- Используется правильный Finder
- Виджет действительно на экране

### "setState() called during build"

Это означает, что состояние изменяется во время построения. Используйте Future:

```dart
// Вместо этого
onBuild: () => setState(() { ... }),

// Используйте это
WidgetsBinding.instance.addPostFrameCallback((_) {
  setState(() { ... });
});
```

### Тесты зависают

Используйте timeout:

```bash
flutter test --timeout=30s
```

---

## ?? CI/CD Integration

### Статус Badge в README

```markdown
[![Flutter Tests](https://github.com/kotjaDFrealty/FlutterWebView/actions/workflows/tests.yml/badge.svg)](https://github.com/kotjaDFrealty/FlutterWebView/actions)
```

### Требование прохождения тестов перед merge

В GitHub репозитории:
1. Settings ? Branches ? Add rule
2. Branch protection rule:
   - Require status checks to pass
   - Выберите "Flutter Tests" workflow
3. Save

---

## ?? Дополнительные ресурсы

- Flutter Testing Docs: https://docs.flutter.dev/testing
- Flutter Test API: https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html
- Mockito: https://pub.dev/packages/mockito
- Golden Files: https://docs.flutter.dev/testing/unit-testing#golden-files
