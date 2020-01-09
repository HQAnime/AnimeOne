import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

/// This is the parent of all parsers and it handles 404 not found. 
/// This is also the termination point of next page or back to home
abstract class BasicParser {

  String _link;
  /// Get the link for current page
  String getLink() => this._link;

  BasicParser(String link) {
    this._link = link;
    print(this._link);
  }

  /// Download HTML string from link
  Future<Document> downloadHTML() async {
    Map<String, String> requestHeaders = {
      'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36',
      'Cookie': '__cfduid=db8a26736d5c93da668062dc09551f88a1578089782; _ga=GA1.2.1558854639.1578089782; videopassword=0; cf_clearance=31dd67786c96bf54e97b2f6cfda727475da812b5-1578537055-0-150',
    };

    try {
      final response = await http.get(
        this._link,
        headers: requestHeaders,
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else if (response.statusCode == 503) {
        // Need to get cookie
        return Document.html('503');
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
