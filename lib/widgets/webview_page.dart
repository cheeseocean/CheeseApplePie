import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  WebViewPage({this.title, this.url});

  @override
  State createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  String _title;
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SafeArea(
          child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
      )),
    );
  }
}
