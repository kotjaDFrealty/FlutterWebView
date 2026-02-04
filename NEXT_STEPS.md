# Установка Android SDK и сборка APK

## Текущая ситуация

? Flutter установлен (3.16.0)  
? Android SDK не установлен

## ? БЫСТРОЕ РЕШЕНИЕ: Онлайн сборка (5 минут)

Не нужно устанавливать Android SDK! Используйте онлайн-сервис:

### Codemagic (рекомендуется)

1. **Зарегистрируйтесь**: https://codemagic.io/start
2. **Создайте GitHub репозиторий**
3. **Загрузите проект**:
   - Все файлы из `c:\Users\df\Documents\VSCode\flutter`
4. **Подключите репозиторий** к Codemagic
5. **Нажмите "Start new build"**
6. **Скачайте APK** (готов через 5-10 минут)

**Преимущества**: Бесплатно, не требует установки Android SDK, быстро

---

## ?? ПОЛНАЯ УСТАНОВКА: Android SDK (40-60 минут)

Если хотите собирать APK локально:

### Шаг 1: Установка Android Studio

1. **Скачайте Android Studio**:
   https://developer.android.com/studio

2. **Запустите установку**:
   - Установите в `C:\Program Files\Android\Android Studio`
   - Выберите "Standard" setup
   - Дождитесь скачивания Android SDK

3. **Откройте Android Studio**:
   - SDK Manager ? Android SDK
   - Установите:
     - Android SDK Platform (API 33 или 34)
     - Android SDK Command-line Tools
     - Android SDK Build-Tools
     - Android Emulator (опционально)

### Шаг 2: Настройка переменных окружения

В PowerShell (от администратора):

```powershell
# Найдите путь к Android SDK (обычно один из этих):
$androidSdk = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"
# или
# $androidSdk = "C:\Android\Sdk"

# Установите переменные окружения
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $androidSdk, "User")
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidSdk, "User")

# Добавьте инструменты в PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$androidSdk\platform-tools;$androidSdk\tools;$androidSdk\cmdline-tools\latest\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

### Шаг 3: Принятие лицензий Android

```powershell
# Перезапустите PowerShell, затем:
flutter doctor --android-licenses
# Нажимайте 'y' для всех лицензий
```

### Шаг 4: Проверка установки

```powershell
flutter doctor -v
```

Должно показать:
- ? Flutter
- ? Android toolchain
- ? Android SDK

### Шаг 5: Сборка APK

```powershell
cd "c:\Users\df\Documents\VSCode\flutter"
flutter build apk --release
```

Готовый APK будет в:
```
build\app\outputs\flutter-apk\app-release.apk
```

---

## ?? GitHub Actions (автоматическая сборка)

Файл `.github/workflows/build.yml` уже создан!

1. **Создайте репозиторий на GitHub**
2. **Загрузите все файлы проекта**
3. **Сделайте commit и push**
4. **Перейдите в "Actions"**
5. **Скачайте APK** из "Artifacts"

При каждом commit APK будет собираться автоматически!

---

## ?? Сравнение методов

| Метод | Время | Сложность | Требования |
|-------|-------|-----------|------------|
| **Codemagic** | 5-10 мин | ? Легко | Регистрация, GitHub |
| **GitHub Actions** | 10 мин | ?? Средне | GitHub аккаунт |
| **Локальная сборка** | 40-60 мин | ??? Сложно | Android Studio, 15GB места |

---

## ?? Рекомендация

**Для первой сборки**: Используйте **Codemagic** - быстро и просто!

**Для разработки**: Установите Android SDK локально - полный контроль и быстрая итерация.

---

## ?? Checklist

Что нужно для публикации в Google Play:

- [ ] Готовый APK (release, подписанный)
- [ ] Иконка приложения 512x512
- [ ] Минимум 2 скриншота (разные устройства)
- [ ] Описание приложения (краткое и полное)
- [ ] Категория приложения
- [ ] Политика конфиденциальности (URL)
- [ ] Google Play Developer аккаунт ($25 разовый платеж)

---

## ?? Решение проблем

### Flutter не найден после установки
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")
```

### Android SDK не найден
- Проверьте путь к SDK в Android Studio (Settings ? Android SDK)
- Установите ANDROID_SDK_ROOT переменную

### Ошибки при сборке
```powershell
flutter clean
flutter pub get
flutter build apk --release
```

---

## ?? Дополнительная помощь

- Flutter документация: https://docs.flutter.dev
- Android Studio: https://developer.android.com/studio
- Codemagic: https://docs.codemagic.io
