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
    // this._cookie = '__cfduid=dd2dd11780abee190ac8692be811e4cf51567137513; _ga=GA1.2.485272290.1567142333; _gid=GA1.2.294024284.1586136978; cf_clearance=6a4e4b82b234f077e508b8be12b1b61442eac50c-1586136988-0-150; videopassword=0; _gat=1';
    print(this._link);
  }

  /// Download HTML string from link
  Future<Document> downloadHTML() async {
    try {
      Map<String, String> requestHeaders = {
        'cookie': _cookie,
        'user-agent': 'Mozilla/5.0 (Linux; Android 9; ONEPLUS A5000) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.119 Mobile Safari/537.36',
        'referer': 'https://anime1.me/',
      };
      
      final response = await http.get(
        this._link,
        headers: requestHeaders,
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else if (response.statusCode == 503) {
        // Need to get cookie
        print(response.body);
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
