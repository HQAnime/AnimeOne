import 'dart:async';

import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

/// This is the parent of all parsers and it handles 404 not found. 
/// This is also the termination point of next page or back to home
abstract class BasicParser {

  String _link;
  String _cookie;
  /// Get the link for current page
  String getLink() => this._link;

  BasicParser(String link) {
    this._link = link;
    this._cookie = GlobalData().getCookie();
    print(this._link);
  }

  /// Download HTML string from link
  Future<Document> downloadHTML() async {
    try {
      Map<String, String> requestHeaders = {
        'cookie': _cookie,
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36',
      };
      
      final response = await http.get(
        this._link,
        headers: requestHeaders,
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else if (response.statusCode == 503) {
        // Need to get cookie
        GlobalData.requestCookieLink = this._link;
        return null;
      } else {
        // If it is 404, the status code will tell you
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// All subclasses have different implementations
  parseHTML(Document body);

}
