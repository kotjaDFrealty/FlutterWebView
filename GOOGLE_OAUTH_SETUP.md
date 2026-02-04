# Решение ошибок Google OAuth в WebView

## ? Ошибка 403: disallowed_useragent

**Причина:** Google блокирует User-Agent из WebView

**Решение:** 
1. ? Уже исправлено - установлен правильный User-Agent для Android
2. Обновить Google Cloud Console

---

## ?? Настройка Google Cloud Console

### Шаг 1: Получить OAuth Credentials

1. Откройте https://console.cloud.google.com
2. Выберите свой проект
3. Перейдите в **APIs & Services** ? **Credentials**
4. Создайте новые credentials типа **OAuth 2.0 Client IDs**

### Шаг 2: Добавить Android приложение

1. Нажмите **Create Credentials** ? **OAuth client ID**
2. Выберите **Android**
3. Заполните:
   - **Package name:** `com.fmsgo.fms_go_app`
   - **SHA-1 certificate fingerprint** (см. ниже)

### Шаг 3: Получить SHA-1 fingerprint

```bash
# Если у вас есть keystore
keytool -list -v -keystore <path_to_keystore> -alias <alias_name>

# Для debug keystore (Windows)
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Пример вывода:**
```
Certificate fingerprints:
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
```

Скопируйте SHA-1 и вставьте в Google Cloud Console

### Шаг 4: Обновить redirect_uri в Google Cloud

Для веб-приложения добавьте:
```
https://beta.fms-go.com/auth/google/callback
https://accounts.google.com/o/oauth2/native/callback
```

---

## ??? Безопасность WebView

### 1. Включить JavaScript

```dart
..setJavaScriptMode(JavaScriptMode.unrestricted)
```

### 2. Установить правильный User-Agent

```dart
..setUserAgent('Mozilla/5.0 (Linux; Android 13; SM-A505F) AppleWebKit/537.36')
```

### 3. Разрешить Google домены

```dart
onNavigationRequest: (NavigationRequest request) {
  if (request.url.startsWith('https://beta.fms-go.com') ||
      request.url.startsWith('https://accounts.google.com')) {
    return NavigationDecision.navigate;
  }
  return NavigationDecision.navigate;
}
```

### 4. Разрешения в AndroidManifest.xml

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

---

## ?? Тестирование Google OAuth

### Локально:

1. Запустите приложение на тестовом устройстве
2. Откройте страницу с Google Sign-In на сайте
3. Нажмите "Sign in with Google"
4. Должно перенаправить на accounts.google.com

### На Google Play:

1. Загрузите приложение (даже бета-версию)
2. Добавьте тестовые аккаунты в Google Play Console
3. Установите через внутреннее тестирование
4. Проверьте OAuth

---

## ?? Чек-лист настройки

- [ ] User-Agent установлен на `Mozilla/5.0 (Linux; Android ...)`
- [ ] Google Cloud Project создан
- [ ] OAuth Credentials для Android созданы
- [ ] SHA-1 fingerprint добавлен в Cloud Console
- [ ] Redirect URI добавлен: `https://beta.fms-go.com/auth/google/callback`
- [ ] Интернет разрешение в AndroidManifest.xml
- [ ] JavaScript включен в WebViewController
- [ ] Google домены разрешены в NavigationDelegate

---

## ?? Дополнительные проблемы

### "Это приложение не является приложением из Google Play"

**Решение:**
1. Загрузите приложение в Google Play (даже как неопубликованное)
2. Используйте SHA-1 из подписанного APK, а не debug keystore
3. Дождитесь 24 часов для распространения

### "Invalid redirect_uri"

**Решение:**
1. Проверьте точное совпадение redirect_uri в Cloud Console
2. Убедитесь, что используется HTTPS
3. Нет пробелов или опечаток

### "Client ID not found"

**Решение:**
1. Проверьте, что используется правильный Client ID
2. Убедитесь, что Android credentials созданы
3. Перепроверьте Package name: `com.fmsgo.fms_go_app`

---

## ?? Полезные ссылки

- Google OAuth 2.0: https://developers.google.com/identity/protocols/oauth2
- Android OAuth Setup: https://developers.google.com/identity/sign-in/android/sign-in
- Google Cloud Console: https://console.cloud.google.com
- Flutter WebView: https://pub.dev/packages/webview_flutter

---

## ?? Совет: Использование redirect_uri для WebView

Для работы Google OAuth в WebView без необходимости custom redirect_uri, используйте:

```dart
// Перехватываем URL изменения
onPageStarted: (String url) {
  if (url.contains('code=')) {
    // Получить authorization code и отправить на backend
    String? code = Uri.parse(url).queryParameters['code'];
    debugPrint('Authorization code: $code');
  }
}
```

Отправьте код на ваш backend для обмена на access token.
