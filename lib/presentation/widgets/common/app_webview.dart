import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:nuevo_app/core/theme/app_theme.dart';

class AppWebView extends StatefulWidget {
  final String url;
  final String title;

  const AppWebView({
    super.key,
    required this.url,
    required this.title,
  });

  static void open(BuildContext context, {required String url, required String title}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppWebView(url: url, title: title),
      ),
    );
  }

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final WebViewController controller;
  bool isLoading = true;
  double loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Normalize URL to ensuring trailing slash consistency for comparison if needed
    // But for now, we rely on exact match or strict containment for initial load.
    
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                loadingProgress = progress / 100;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            // debugPrint('WebResourceError: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

           // debugPrint("Navigating to: $url");

            if (url.startsWith("http") || url.startsWith("https")) {
              return NavigationDecision.navigate;
            }

            // Handle external schemes
            return NavigationDecision.prevent;
          },
          onUrlChange: (UrlChange change) {
            //debugPrint('WebView URL Changed: ${change.url}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppTextStyles.h3.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading || loadingProgress < 1.0)
            LinearProgressIndicator(
              value: loadingProgress,
              color: AppColors.primaryColor,
              backgroundColor: AppColors.roseSurface,
              minHeight: 2,
            ),
        ],
      ),
    );
  }
}
