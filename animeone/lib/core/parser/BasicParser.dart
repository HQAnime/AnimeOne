import 'dart:async';
import 'dart:convert';

import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

/// This is the parent of all parsers and it handles 404 not found.
/// This is also the termination point of next page or back to home
abstract class BasicParser {
  final String _link;
  late final String _cookie;

  /// Get the link for current page
  String getLink() => this._link;

  BasicParser(this._link) {
    this._cookie = GlobalData().getCookie();
    // this._cookie = '__cfduid=d51d3b47667b64ea1c0278ca1baec11f41583638164; _ga=GA1.2.1712035882.1586138123; _gid=GA1.2.378879752.1586138123; cf_clearance=b92f05ead855fb1ec43fdad0205f81c366c23ce0-1586138131-0-150; videopassword=0';
    print(this._link);
  }

  Map<String, String> get _defaultHeader {
    return {
      'cookie': _cookie,
      'user-agent':
          'Mozilla/5.0 (Linux; Android 9; SM-A705FN) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36',
    };
  }

  /// Download HTML string from link
  Future<Document?> downloadHTML() async {
    try {
      return handleReponse(await get());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> get({
    Map<String, String>? headers = null,
  }) async {
    try {
      return await http
          .get(
            Uri.parse(this._link),
            headers: headers ?? _defaultHeader,
          )
          .timeout(Duration(seconds: 10));
    } catch (e) {
      // catch timeout here
      print(e);
      return null;
    }
  }

  Future<Response?> post({
    Map<String, String>? headers = null,
    Object? body,
    Encoding? encoding,
  }) async {
    try {
      return await http
          .post(
            Uri.parse(this._link),
            headers: headers ?? _defaultHeader,
            body: body,
            encoding: encoding,
          )
          .timeout(Duration(seconds: 10));
    } catch (e) {
      // catch timeout here
      print(e);
      return null;
    }
  }

  Document? handleReponse(Response? response) {
    if (response == null) return null;

    if (response.statusCode == 200) {
      // Encoding is needed to prevent unexpected error (espcially Chinese character)
      final encoded = Utf8Encoder().convert(response.body);
      return parse(encoded);
    } else if (response.statusCode == 503) {
      // Need to get cookie
      GlobalData.requestCookieLink = this._link;
      return null;
    } else {
      // If it is 404, the status code will tell you
      return null;
    }
  }

  /// All subclasses have different implementations
  parseHTML(Document? body);
}
