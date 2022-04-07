import 'dart:io';

import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This class communicates with native code
class AnimeOne {
  // This is a channel to connect with native side
  static final nativeChannel = MethodChannel('org.github.henryquan.animeone');

  /// If native channel is supported
  bool _isSupported() {
    return Platform.isAndroid;
  }

  Future? _invokeMethod(String method, [dynamic arguments]) async {
    if (this._isSupported()) {
      return await nativeChannel.invokeMethod(method, arguments);
    }

    return null;
  }

  /// Restart the app
  Future? restartApp() async {
    return await this._invokeMethod('restartAnimeOne');
  }

  /// Popup native browser and get cookie from webview
  Future<List<String>>? _getAnimeOneCookie() async {
    final list = await this._invokeMethod(
      'getAnimeOneCookie',
      {'link': GlobalData.requestCookieLink},
    ) as List;

    return list.map((e) => e as String).toList();
  }

  void bypassWebsiteCheck(BuildContext context) {
    _getAnimeOneCookie()?.then((output) {
      final cookie = output[0];
      final userAgent = output[1];
      if (cookie.length > 0 && cookie.contains('cf_clearance')) {
        print(cookie);
        final data = GlobalData();
        data.updateCookie(cookie);
        data.updateUserAgent(userAgent);

        // restart if successful, only show the error if it failed
        restartApp();
      } else {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('修復失敗'),
            content: Text('請再次嘗試，如果連續三次都失敗的話，請查看詳細信息。'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('好的'),
              ),
            ],
          ),
        );
      }
    });
  }
}
