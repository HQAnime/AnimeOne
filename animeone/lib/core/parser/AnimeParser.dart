import 'package:html/parser.dart';

/// This is the parent of all parsers and it handles 404 not found. 
/// This is also the termination point of next page or back to home
class AnimeParser {

  String _link;

  AnimeParser(String link) {
    
  }

  /// Get the link for current page
  String getLink() => this._link;

}
