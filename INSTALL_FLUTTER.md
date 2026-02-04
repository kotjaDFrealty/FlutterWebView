# FMS Go WebView - Онлайн сборка APK

## ? Быстрый способ без установки Flutter

### Codemagic.io (Самый простой способ)

1. **Зарегистрируйтесь на Codemagic**
   - Перейдите на https://codemagic.io/start
   - Войдите через GitHub/GitLab/Bitbucket

2. **Загрузите проект**
   - Создайте новый репозиторий на GitHub
   - Загрузите все файлы проекта в репозиторий
   - Подключите репозиторий к Codemagic

3. **Настройте сборку**
   - Codemagic автоматически определит Flutter проект
   - Выберите Android сборку
   - Нажмите "Start new build"

4. **Скачайте APK**
   - После завершения сборки (5-10 минут)
   - Скачайте готовый APK файл

### Альтернатива: GitHub Actions

Создайте файл `.github/workflows/build.yml` в репозитории:

```yaml
name: Build Android APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '17'
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-release
        path: build/app/outputs/flutter-apk/app-release.apk
```

После push в GitHub, APK будет собран автоматически и доступен в разделе Actions ? Artifacts.

## ?? Вариант 2: Установка Flutter SDK локально

### Шаги установки для Windows:

1. **Скачайте Flutter SDK**
   ```powershell
   # Создайте папку для Flutter
   New-Item -Path "C:\src" -ItemType Directory -Force
   
   # Скачайте Flutter (вручную с сайта)
   # https://docs.flutter.dev/get-started/install/windows
   ```

2. **Распакуйте архив в C:\src\flutter**

3. **Добавьте Flutter в PATH**
   ```powershell
   # Добавить в PATH (от администратора)
   [Environment]::SetEnvironmentVariable(
       "Path",
       [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\src\flutter\bin",
       "User"
   )
   ```

4. **Перезапустите VS Code и терминал**

5. **Проверьте установку**
   ```powershell
   flutter doctor
   ```

6. **Установите Android SDK**
   - Скачайте Android Studio: https://developer.android.com/studio
   - Запустите Android Studio и установите Android SDK
   - Примите лицензии: `flutter doctor --android-licenses`

7. **Соберите APK**
   ```powershell
   cd "c:\Users\df\Documents\VSCode\flutter"
   flutter pub get
   flutter build apk --release
   ```

### Установка через winget (Windows 11):
```powershell
winget install -e --id=Chocolatey.Chocolatey
choco install flutter -y
```

### Установка через Chocolatey:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install flutter -y
```

## ?? Рекомендация

**Для быстрого результата**: Используйте **Codemagic.io**
- Не требует установки Flutter
- Автоматическая сборка за 5-10 минут
- Бесплатно для Open Source проектов
- Получите готовый APK

**Для долгосрочной разработки**: Установите Flutter SDK локально
- Возможность быстрой разработки и тестирования
- Полный контроль над сборкой
- Отладка на реальных устройствах

## ?? Время на установку

- **Codemagic**: 5-10 минут (только регистрация и загрузка)
- **Flutter SDK**: 30-60 минут (загрузка, установка, настройка)

## ?? Что нужно для публикации в Google Play

1. Аккаунт разработчика Google Play ($25 разовый платеж)
2. Подписанный APK или App Bundle
3. Иконка приложения (512x512 PNG)
4. Скриншоты приложения (минимум 2)
5. Описание приложения

Все файлы уже готовы для сборки!
