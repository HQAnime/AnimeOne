import 'dart:async';
import 'dart:convert';

import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class ApiService {
  final _logger = Logger('ApiService');
  final String _baseLink;
  late final String _cookie;
  late final String _userAgent;

  ApiService(this._baseLink) {
    final data = GlobalData();
    _cookie = data.getCookie();
    _userAgent = data.getUserAgent();
  }

  Map<String, String> get _defaultHeader => {
        'cookie': _cookie,
        'user-agent': _userAgent,
        'referer': 'https://anime1.me/',
      };

  Future<http.Response?> get({String? link, Map<String, String>? headers}) async {
    try {
      var target = link ?? _baseLink;
      return await http
          .get(Uri.parse(target), headers: headers ?? _defaultHeader)
          .timeout(const Duration(seconds: 10));
    } catch (e, s) {
      _logger.shout(s);
      return null;
    }
  }

  Future<http.Response?> post({
    String? link,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await http
          .post(
            Uri.parse(link ?? _baseLink),
            headers: headers ?? _defaultHeader,
            body: body,
            encoding: encoding,
          )
          .timeout(const Duration(seconds: 10));
    } catch (e, s) {
      _logger.shout(s);
      return null;
    }
  }

  Future<String> resolveRedirect(String url) async {
    String finalLink = url;
    try {
      String? redirected = url;
      while (redirected != null) {
        final request = http.Request('GET', Uri.parse(redirected))
          ..followRedirects = false;
        final response = await http.Client().send(request);
        redirected = response.headers['location'];
        if (redirected != null) finalLink = redirected;
      }
      return finalLink;
    } catch (e, s) {
      _logger.shout(s);
      return finalLink;
    }
  }

  Document? handleResponse(http.Response? response) {
    if (response == null) return null;
    if (response.statusCode == 200) {
      final encoded = const Utf8Encoder().convert(response.body);
      return parse(encoded);
    }
    if (response.statusCode == 503) {
      GlobalData.requestCookieLink = _baseLink;
    }
    return null;
  }
}
