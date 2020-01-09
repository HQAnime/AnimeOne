import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CookiePage extends StatefulWidget {
  CookiePage({Key key}) : super(key: key);

  @override
  _CookiePageState createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  final webview = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    webview.onUrlChanged.listen((s) async {
      print(s);
      var a = await webview.getCookies();
      
      a.forEach((k, v) {
        print('$k $v');
      });

      // Clean this
      GlobalData.requestCookieLink = '';
      Navigator.pop(context);
    });

    return WebviewScaffold(
      appBar: AppBar(
        title: Text('檢查瀏覽器中'),
      ),
      url: GlobalData.requestCookieLink,
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
    );
  }
}
