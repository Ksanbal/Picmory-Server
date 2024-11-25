import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picmory/common/components/common/icon_button_comp.dart';
import 'package:picmory/common/tokens/colors_token.dart';
import 'package:picmory/common/tokens/icons_token.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatelessWidget {
  const WebView({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      backgroundColor: ColorsToken.white,
      appBar: AppBar(
        leading: IconButtonComp(
          onPressed: context.pop,
          icon: IconsToken().altArrowLeftLinear,
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
