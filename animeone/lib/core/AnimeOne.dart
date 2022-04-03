import 'dart:io';

import 'package:animeone/core/GlobalData.dart';
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
  Future<String>? getAnimeOneCookie() async {
    final list = await this._invokeMethod(
      'getAnimeOneCookie',
      {'link': GlobalData.requestCookieLink},
    );
    return list[0];
  }
}
