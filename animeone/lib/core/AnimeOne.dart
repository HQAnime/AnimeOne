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

  Future? _invokeMethod(String method, [dynamic arguments]) {
    if (this._isSupported()) {
      return nativeChannel.invokeMethod(method, arguments);
    }

    return null;
  }

  /// Restart the app
  Future? restartApp() {
    return this._invokeMethod('restartAnimeOne');
  }

  /// Popup native browser and get cookie from webview
  Future? getAnimeOneCookie() {
    return this._invokeMethod(
      'getAnimeOneCookie',
      {'link': GlobalData.requestCookieLink},
    );
  }
}
