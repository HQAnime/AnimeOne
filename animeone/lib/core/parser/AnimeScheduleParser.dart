import 'package:animeone/core/parser/AnimeParser.dart';
import 'package:html/dom.dart';

/// This class get anime schedule and possibly an introductory video
class AnimeScheduleParser extends AnimeParser {
  
  AnimeScheduleParser(String link) : super(link);

  @override
  parseHTML(Document body) {
    final elements = body.getElementsByClassName("entry-content");
    // There should only be one element
    final content = elements.first.nodes;
    final first = content[0];
    
    // Check if first is <p>

    // If not, second should be the table
  }

  _parseTable() {
    
  }

}
