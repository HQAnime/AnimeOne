import 'dart:io';

import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
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
    return Platform.isAndroid || Platform.isWindows;
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
    // Let the native webview match the app's light/dark theme.
    final dark = GlobalData().getForceDark() ||
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    final list = await _invokeMethod(
      'getAnimeOneCookie',
      {'link': GlobalData.requestCookieLink, 'dark': dark},
    ) as List;

    // Windows hands back one URL-encoded "cookie|userAgent" blob. Split on
    // the literal separator BEFORE decoding, so a %7C inside the content
    // cannot be mistaken for the separator.
    if (Platform.isWindows) {
      final blob = list[0] as String;
      final sep = blob.indexOf('|');
      if (sep < 0) return ['', ''];
      return [
        Uri.decodeComponent(blob.substring(0, sep)),
        Uri.decodeComponent(blob.substring(sep + 1)),
      ];
    }
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
        // Refetch failed data with the new cookie (Android restarts the app
        // anyway; desktop reloads in place).
        data.refreshData();

        // restart if successful, only show the error if it failed
        restartApp();
      } else {
        if (!context.mounted) return;
        final l = AppLocalizations.of(context)!;
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(l.fixFailed),
            content: Text(l.fixFailedContent),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.ok),
              ),
            ],
          ),
        );
      }
    });
  }
}
