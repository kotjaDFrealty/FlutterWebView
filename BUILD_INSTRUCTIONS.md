# Инструкция по сборке APK для FMS Go

## Быстрый старт (без Flutter SDK)

Если у вас нет Flutter SDK, используйте онлайн-сервисы для сборки:

### Вариант 1: Codemagic (рекомендуется)
1. Зарегистрируйтесь на https://codemagic.io
2. Подключите GitHub репозиторий с проектом
3. Codemagic автоматически соберет APK
4. Скачайте готовый APK

### Вариант 2: GitHub Actions
1. Загрузите проект на GitHub
2. Настройте GitHub Actions workflow
3. APK будет собран автоматически

### Вариант 3: Установка Flutter локально

#### Шаг 1: Установка Flutter SDK

**Windows:**
1. Скачайте Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Распакуйте архив в `C:\src\flutter`
3. Добавьте в PATH: `C:\src\flutter\bin`
4. Перезапустите терминал

**Проверка установки:**
```bash
flutter doctor
```

#### Шаг 2: Установка Android SDK

1. Скачайте Android Studio: https://developer.android.com/studio
2. Установите Android SDK через Android Studio
3. Запустите `flutter doctor --android-licenses` и примите лицензии

#### Шаг 3: Сборка APK

Откройте терминал в папке проекта:

```bash
# Установить зависимости
flutter pub get

# Собрать release APK
flutter build apk --release

# Или собрать split APK (рекомендуется, меньший размер)
flutter build apk --split-per-abi --release
```

**Готовый APK будет находиться в:**
- `build/app/outputs/flutter-apk/app-release.apk` (универсальный)
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (для современных телефонов)

#### Шаг 4: Установка на телефон

**Вариант 1: Через USB**
1. Включите режим разработчика на телефоне
2. Включите отладку по USB
3. Подключите телефон к компьютеру
4. Запустите: `flutter install`

**Вариант 2: Через файл**
1. Скопируйте APK на телефон
2. Откройте файл APK на телефоне
3. Разрешите установку из неизвестных источников
4. Установите приложение

## Размер приложения

- Универсальный APK: ~40-50 MB
- Split APK (arm64-v8a): ~20-25 MB

## Настройка иконки приложения

Замените файлы иконок в:
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

Или используйте плагин flutter_launcher_icons:
```bash
flutter pub add flutter_launcher_icons
flutter pub run flutter_launcher_icons:main
```

## Публикация в Google Play

1. Создайте keystore для подписи
2. Настройте подпись в android/app/build.gradle
3. Соберите App Bundle: `flutter build appbundle`
4. Загрузите в Google Play Console

## Решение проблем

### Flutter не найден
- Проверьте PATH: `echo $PATH` (Linux/Mac) или `echo %PATH%` (Windows)
- Добавьте Flutter в PATH

### Android SDK не найден
- Запустите `flutter doctor`
- Установите Android Studio
- Настройте Android SDK в Android Studio

### Ошибки при сборке
- Запустите `flutter clean`
- Удалите папки `.dart_tool`, `.pub-cache`
- Запустите `flutter pub get`
- Попробуйте снова собрать

### Приложение не устанавливается
- Проверьте, включена ли установка из неизвестных источников
- Удалите старую версию приложения
- Попробуйте снова установить

## Полезные команды

```bash
# Проверка Flutter
flutter doctor -v

# Очистка проекта
flutter clean

# Обновление зависимостей
flutter pub get

# Запуск на эмуляторе
flutter run

# Сборка debug APK (для тестирования)
flutter build apk --debug

# Сборка release APK
flutter build apk --release

# Сборка App Bundle (для Google Play)
flutter build appbundle

# Список подключенных устройств
flutter devices

# Установка на устройство
flutter install
```

## Дополнительные ресурсы

- Flutter документация: https://docs.flutter.dev
- Android документация: https://developer.android.com
- Flutter WebView плагин: https://pub.dev/packages/webview_flutter
