import 'dart:async';

import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';

class CookiePage extends StatefulWidget {
  CookiePage({Key key}) : super(key: key);

  @override
  _CookiePageState createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
  // final Completer<WebViewController> _controller = Completer<WebViewController>();
  // WebViewController c;
      
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('檢查瀏覽器中...'),
  //     ),
  //     // We're using a Builder here so we have a context that is below the Scaffold
  //     // to allow calling Scaffold.of(context) so we can show a snackbar.
  //     body: Builder(builder: (BuildContext context) {
  //       return WebView(
  //         initialUrl: GlobalData.requestCookieLink,
  //         javascriptMode: JavascriptMode.unrestricted,
  //         onWebViewCreated: (WebViewController webViewController) {
  //           _controller.complete(webViewController);
  //           this.c = webViewController;
  //         },
  //         onPageStarted: (String url) {
  //           print('Page started loading: $url');
  //         },
  //         onPageFinished: (String url) {
  //           print('Page finished loading: $url');
  //         },
  //         gestureNavigationEnabled: true,
  //       );
  //     }),
  //   );
  // }
}
