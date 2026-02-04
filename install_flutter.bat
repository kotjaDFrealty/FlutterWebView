@echo off
echo ====================================
echo Установка Flutter SDK для Windows
echo ====================================
echo.

echo [1/5] Создание папки для Flutter...
if not exist "C:\src" mkdir "C:\src"

echo [2/5] Скачивание Flutter SDK...
echo.
echo ВНИМАНИЕ: Сейчас откроется браузер для скачивания Flutter SDK
echo.
echo Скачайте файл flutter_windows_3.16.0-stable.zip
echo и сохраните его в папку C:\src
echo.
pause

echo.
echo [3/5] Проверка скачанного файла...
if not exist "C:\src\flutter_windows_3.16.0-stable.zip" (
    echo ОШИБКА: Файл flutter_windows_3.16.0-stable.zip не найден в C:\src
    echo.
    echo Скачайте его вручную с:
    echo https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip
    echo.
    echo или с официального сайта:
    echo https://docs.flutter.dev/get-started/install/windows
    echo.
    pause
    exit /b 1
)

echo [4/5] Распаковка Flutter SDK...
echo Это может занять несколько минут...
powershell -Command "Expand-Archive -Path 'C:\src\flutter_windows_3.16.0-stable.zip' -DestinationPath 'C:\src' -Force"

echo.
echo [5/5] Добавление Flutter в PATH...
powershell -Command "[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + ';C:\src\flutter\bin', 'User')"

echo.
echo ====================================
echo Установка завершена!
echo ====================================
echo.
echo Следующие шаги:
echo 1. ПЕРЕЗАПУСТИТЕ VS Code и PowerShell
echo 2. Откройте новый терминал PowerShell
echo 3. Выполните: flutter doctor
echo 4. Выполните: flutter pub get
echo 5. Соберите APK: flutter build apk --release
echo.
pause

start https://docs.flutter.dev/get-started/install/windows
