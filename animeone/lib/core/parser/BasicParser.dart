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
      'Cookie': 'cf_clearance=0e4df1df533c8d5572352e4086692e8086fa02e0-1578528286-0-150; __cfduid=db2810e9e9a96c7a4b9ba7eb707c37bbc1578528286; videopassword=0; _ga=GA1.2.1767190019.1578528286; _gid=GA1.2.735201353.1578528286; _gat=1',
    };

    final response = await http.get(
      this._link,
      headers: requestHeaders,
    );

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
