# FMS Go - Android WebView App

Android приложение для PWA сайта https://beta.fms-go.com

## Описание

Это Flutter приложение, которое открывает PWA сайт FMS Go через системный WebView Android.

## Особенности

- ? Полноэкранный WebView с PWA сайтом
- ? Поддержка JavaScript
- ? Навигация назад кнопкой Android
- ? Индикатор загрузки
- ? Разрешения для камеры, геолокации, файлов
- ? Deep links для открытия ссылок FMS Go
- ? Поддержка всех ориентаций экрана

## Требования

- Flutter SDK (3.0.0 или выше)
- Android SDK
- Java/Kotlin

## Установка Flutter

1. Скачайте Flutter SDK: https://flutter.dev/docs/get-started/install/windows
2. Распакуйте в удобное место (например, C:\flutter)
3. Добавьте в PATH: C:\flutter\bin
4. Запустите `flutter doctor` для проверки установки

## Сборка APK

### 1. Установите зависимости

```bash
flutter pub get
```

### 2. Соберите debug APK

```bash
flutter build apk --debug
```

APK будет в: `build/app/outputs/flutter-apk/app-debug.apk`

### 3. Соберите release APK

```bash
flutter build apk --release
```

APK будет в: `build/app/outputs/flutter-apk/app-release.apk`

### 4. Соберите split APK (меньший размер)

```bash
flutter build apk --split-per-abi
```

APK будут в: `build/app/outputs/flutter-apk/`
- app-armeabi-v7a-release.apk (для старых устройств)
- app-arm64-v8a-release.apk (для современных устройств)
- app-x86_64-release.apk (для эмуляторов)

## Установка на устройство

### Через USB

```bash
flutter install
```

### Через ADB

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Запуск в режиме разработки

```bash
flutter run
```

## Настройка подписи для релиза (опционально)

Создайте файл `android/key.properties`:

```properties
storePassword=<пароль>
keyPassword=<пароль>
keyAlias=fmsgo
storeFile=<путь к keystore>
```

Сгенерируйте keystore:

```bash
keytool -genkey -v -keystore ~/fmsgo-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fmsgo
```

## Изменение URL сайта

Отредактируйте `lib/main.dart`, строку:

```dart
String _url = 'https://beta.fms-go.com';
```

## Структура проекта

```
flutter/
??? android/              # Android конфигурация
??? lib/
?   ??? main.dart        # Основной код приложения
??? pubspec.yaml         # Зависимости Flutter
??? README.md
```

## Разрешения

Приложение запрашивает следующие разрешения:
- Интернет
- Камера (для PWA функций)
- Геолокация (для PWA функций)
- Файловая система (для загрузок)

## Поддержка

Минимальная версия Android: 5.0 (API 21)
