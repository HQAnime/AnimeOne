import 'dart:developer';

import 'package:animeone/core/json/AnimeInfo.dart';
import 'package:animeone/core/parser/AnimeParser.dart';
import 'package:html/dom.dart';

/// This class parses all anime available from the site
class AnimeListParser extends AnimeParser {
  
  AnimeListParser(String link) : super(link);
  
  @override
  List<AnimeInfo> parseHTML(Document body) {
    final elements = body.getElementsByClassName("row-hover");
    if (elements.length > 0) {
      final e = elements.first;
      var list = new List<AnimeInfo>();
      e.nodes.forEach((n) {
        list.add(new AnimeInfo(n));
      });

      log(list[0].toString());
      return list;
    } else {
      // Error
      return null;
    }
  }

}
