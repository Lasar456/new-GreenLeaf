import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// GreenLeaf's existing HTML remains the UI. Flutter only supplies the Android
// application shell, real system bars and Android back-button handling.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(const GreenLeafApp());
}

class GreenLeafApp extends StatelessWidget {
  const GreenLeafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenLeaf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: Colors.white),
      home: const GreenLeafHome(),
    );
  }
}

class GreenLeafHome extends StatefulWidget {
  const GreenLeafHome({super.key});

  @override
  State<GreenLeafHome> createState() => _GreenLeafHomeState();
}

class _GreenLeafHomeState extends State<GreenLeafHome> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF6F6F8))
      ..enableZoom(false)
      ..loadFlutterAsset('assets/greenleaf.html');
  }

  Future<void> _handleBack() async {
    try {
      final result = await _webViewController.runJavaScriptReturningResult(r"""
        (function () {
          const sheet = document.getElementById('modalOverlay');
          if (sheet && sheet.classList.contains('show')) {
            sheet.classList.remove('show');
            return true;
          }
          const chat = document.getElementById('conversation');
          if (chat && chat.classList.contains('open')) {
            chat.classList.remove('open');
            return true;
          }
          const home = document.getElementById('screen-home');
          if (home && !home.classList.contains('active') && window.showPage) {
            window.showPage('home');
            return true;
          }
          return false;
        })();
      """);
      if (result == true || result.toString() == 'true') return;
    } catch (_) {
      // A back press during the initial WebView load can reach here.
    }
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    const systemBars = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemBars,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) _handleBack();
        },
        child: Scaffold(
          body: Stack(
            children: [
              // On edge-to-edge Android versions, draw behind the REAL
              // status bar with the exact dark tone of the existing header.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topInset,
                child: const ColoredBox(color: Color(0xFF181727)),
              ),
              // Critical: safe areas are applied ONCE in Flutter, not twice in CSS.
              SafeArea(
                top: true,
                bottom: true,
                child: WebViewWidget(controller: _webViewController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
