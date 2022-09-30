import 'dart:io';

import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

/// This class communicates with native code
class AnimeOne {
  final _logger = Logger('AnimeOneChannel');
  // This is a channel to connect with native side
  static const nativeChannel = MethodChannel('org.github.henryquan.animeone');

  /// If native channel is supported
  bool _isSupported() {
    return Platform.isAndroid;
  }

  Future? _invokeMethod(String method, [dynamic arguments]) async {
    if (_isSupported()) {
      return await nativeChannel.invokeMethod(method, arguments);
    }

    return null;
  }

  /// Restart the app
  Future? restartApp() async {
    return await _invokeMethod('restartAnimeOne');
  }

  /// Popup native browser and get cookie from webview
  Future<List<String>>? _getAnimeOneCookie() async {
    final list = await _invokeMethod(
      'getAnimeOneCookie',
      {'link': GlobalData.requestCookieLink},
    ) as List;

    return list.map((e) => e as String).toList();
  }

  void bypassWebsiteCheck(BuildContext context) {
    _getAnimeOneCookie()?.then((output) {
      final cookie = output[0];
      final userAgent = output[1];
      if (cookie.isNotEmpty && cookie.contains('cf_clearance')) {
        _logger.info(cookie);
        final data = GlobalData();
        data.updateCookie(cookie);
        data.updateUserAgent(userAgent);

        // restart if successful, only show the error if it failed
        restartApp();
      } else {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('修復失敗'),
            content: const Text('請再次嘗試，如果連續三次都失敗的話，請查看詳細信息。'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('好的'),
              ),
            ],
          ),
        );
      }
    });
  }
}
