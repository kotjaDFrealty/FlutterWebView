# Скрипт для автоматической установки Flutter на Windows
Write-Host "====================================" -ForegroundColor Green
Write-Host "Установка Flutter SDK для Windows" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Проверка прав администратора
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ВНИМАНИЕ: Скрипт запущен без прав администратора" -ForegroundColor Yellow
    Write-Host "Некоторые операции могут не работать" -ForegroundColor Yellow
    Write-Host ""
}

# Шаг 1: Создание директории
Write-Host "[1/6] Создание папки для Flutter..." -ForegroundColor Cyan
$flutterPath = "C:\src\flutter"
$srcPath = "C:\src"

if (-not (Test-Path $srcPath)) {
    New-Item -Path $srcPath -ItemType Directory -Force | Out-Null
    Write-Host "? Папка C:\src создана" -ForegroundColor Green
} else {
    Write-Host "? Папка C:\src уже существует" -ForegroundColor Green
}

# Шаг 2: Скачивание Flutter
Write-Host ""
Write-Host "[2/6] Скачивание Flutter SDK..." -ForegroundColor Cyan
$flutterZip = "$srcPath\flutter_windows_stable.zip"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip"

if (Test-Path $flutterZip) {
    Write-Host "Файл уже скачан, пропускаем..." -ForegroundColor Yellow
} else {
    Write-Host "Скачивание Flutter SDK (это может занять несколько минут)..." -ForegroundColor Yellow
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip
        Write-Host "? Flutter SDK скачан" -ForegroundColor Green
    } catch {
        Write-Host "? Ошибка скачивания: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Скачайте вручную с:" -ForegroundColor Yellow
        Write-Host $flutterUrl -ForegroundColor White
        Write-Host "и сохраните в: $flutterZip" -ForegroundColor White
        pause
        exit 1
    }
}

# Шаг 3: Удаление старой версии
Write-Host ""
Write-Host "[3/6] Проверка существующей установки..." -ForegroundColor Cyan
if (Test-Path $flutterPath) {
    Write-Host "Найдена существующая установка Flutter" -ForegroundColor Yellow
    $remove = Read-Host "Удалить и переустановить? (Y/N)"
    if ($remove -eq "Y" -or $remove -eq "y") {
        Remove-Item -Path $flutterPath -Recurse -Force
        Write-Host "? Старая версия удалена" -ForegroundColor Green
    } else {
        Write-Host "Установка отменена" -ForegroundColor Yellow
        exit 0
    }
}

# Шаг 4: Распаковка
Write-Host ""
Write-Host "[4/6] Распаковка Flutter SDK..." -ForegroundColor Cyan
Write-Host "Это может занять несколько минут..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $flutterZip -DestinationPath $srcPath -Force
    Write-Host "? Flutter SDK распакован" -ForegroundColor Green
} catch {
    Write-Host "? Ошибка распаковки: $_" -ForegroundColor Red
    pause
    exit 1
}

# Шаг 5: Добавление в PATH
Write-Host ""
Write-Host "[5/6] Добавление Flutter в PATH..." -ForegroundColor Cyan
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$flutterBin = "$flutterPath\bin"

if ($userPath -notlike "*$flutterBin*") {
    try {
        [Environment]::SetEnvironmentVariable(
            "Path",
            $userPath + ";$flutterBin",
            "User"
        )
        Write-Host "? Flutter добавлен в PATH" -ForegroundColor Green
    } catch {
        Write-Host "? Не удалось добавить в PATH (нужны права администратора)" -ForegroundColor Red
        Write-Host ""
        Write-Host "Добавьте вручную в PATH:" -ForegroundColor Yellow
        Write-Host $flutterBin -ForegroundColor White
    }
} else {
    Write-Host "? Flutter уже в PATH" -ForegroundColor Green
}

# Шаг 6: Обновление переменных окружения в текущей сессии
Write-Host ""
Write-Host "[6/6] Обновление переменных окружения..." -ForegroundColor Cyan
$env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")

# Проверка установки
Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "Проверка установки..." -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

if (Test-Path "$flutterBin\flutter.bat") {
    Write-Host "? Flutter установлен успешно!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Версия Flutter:" -ForegroundColor Cyan
    & "$flutterBin\flutter.bat" --version
} else {
    Write-Host "? Flutter не найден" -ForegroundColor Red
}

# Инструкции
Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "Следующие шаги:" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "1. ПЕРЕЗАПУСТИТЕ VS Code полностью" -ForegroundColor Yellow
Write-Host "2. Откройте новый терминал PowerShell" -ForegroundColor Yellow
Write-Host "3. Выполните: flutter doctor" -ForegroundColor White
Write-Host "4. Перейдите в папку проекта:" -ForegroundColor Yellow
Write-Host "   cd 'c:\Users\df\Documents\VSCode\flutter'" -ForegroundColor White
Write-Host "5. Установите зависимости:" -ForegroundColor Yellow
Write-Host "   flutter pub get" -ForegroundColor White
Write-Host "6. Соберите APK:" -ForegroundColor Yellow
Write-Host "   flutter build apk --release" -ForegroundColor White
Write-Host ""
Write-Host "Готовый APK будет в:" -ForegroundColor Cyan
Write-Host "build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
Write-Host ""

# Очистка
$cleanup = Read-Host "Удалить скачанный ZIP файл? (Y/N)"
if ($cleanup -eq "Y" -or $cleanup -eq "y") {
    Remove-Item -Path $flutterZip -Force
    Write-Host "? ZIP файл удален" -ForegroundColor Green
}

Write-Host ""
Write-Host "Нажмите любую клавишу для выхода..." -ForegroundColor Gray
pause
