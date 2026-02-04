import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(const FMSGoApp());
}

class FMSGoApp extends StatelessWidget {
  const FMSGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FMS Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _url = 'https://fms-go.com';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _enableStorage();
  }

  void _enableStorage() async {
    final cookieManager = WebViewCookieManager();
    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'flutter_app',
        value: 'true',
        domain: 'fms-go.com',
      ),
    );
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; SM-A505F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
      )
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
                _hasError = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            
            // Inject JavaScript to handle PWA features
            _controller.runJavaScript('''
              if ('serviceWorker' in navigator) {
                console.log('Service Worker supported');
              }
              
              // Disable push notification prompt if not supported
              if (!('PushManager' in window)) {
                console.log('Push notifications not supported');
              }
              
              // Enable local storage
              try {
                localStorage.setItem('flutter_webview', 'true');
              } catch(e) {
                console.log('LocalStorage error:', e);
              }
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            if (error.errorType == WebResourceErrorType.hostLookup ||
                error.errorType == WebResourceErrorType.timeout ||
                error.errorType == WebResourceErrorType.connect) {
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://fms-go.com') ||
                request.url.startsWith('https://www.fms-go.com') ||
                request.url.startsWith('https://accounts.google.com') ||
                request.url.startsWith('https://apis.google.com')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  void _reloadPage() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _controller.reload();
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _isLoading
            ? null
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () async {
                    if (await _controller.canGoBack()) {
                      _controller.goBack();
                    }
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _reloadPage,
                  ),
                ],
              ),
        body: SafeArea(
          child: Stack(
            children: [
              if (!_hasError)
                WebViewWidget(controller: _controller),
              
              if (_hasError)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load page',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please check your internet connection',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _reloadPage,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              if (_isLoading && !_hasError)
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading FMS Go...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
