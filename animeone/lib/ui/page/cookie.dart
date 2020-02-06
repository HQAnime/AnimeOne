import 'dart:async';

import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CookiePage extends StatefulWidget {
  CookiePage({Key key}) : super(key: key);

  @override
  _CookiePageState createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  final webview = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    webview.onUrlChanged.listen((url) {
      GlobalData.nativeChannel.invokeMethod('getAnimeOneCookie').then((cookie) {
        print(cookie);
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        url: "https://anime1.me",
      ),  
    );
  }
}
