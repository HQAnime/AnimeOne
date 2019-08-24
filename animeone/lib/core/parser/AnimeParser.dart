import 'dart:math';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

/// This is the parent of all parsers and it handles 404 not found. 
/// This is also the termination point of next page or back to home
abstract class AnimeParser {

  String _link;
  /// Get the link for current page
  String getLink() => this._link;

  AnimeParser(String link) {
    this._link = link;
  }

  /// Download HTML string from link
  Future<Document> downloadHTML() async {
    final response = await http.get(this._link);

    if (response.statusCode == 200) {
      // Try parsing the string
      var website = parse(response.body);
      // Make sure this page has content
      var check404 = website.getElementsByClassName("error-404");
      log(check404.length);
      if (check404.length == 0) {
        return website;
      } else {
        throw Exception('404 Anime Not Found');
      }
    } else {
      throw Exception('Failed to load HTML from server');
    }
  }



}
