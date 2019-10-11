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
  }

  /// Download HTML string from link
  Future<Document> downloadHTML() async {
    final response = await http.get(this._link);

    if (response.statusCode == 200) {
      return parse(response.body);
    } else {
      // If it is 404, the status code will tell you
      return null;
    }
  }

  /// All subclasses have different implementations
  parseHTML(Document body);

}
