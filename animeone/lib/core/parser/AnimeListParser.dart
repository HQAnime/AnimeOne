import 'dart:developer';

import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/core/parser/AnimeParser.dart';
import 'package:html/dom.dart';

/// This class parses all anime available from the site
class AnimeListParser extends AnimeParser {
  
  AnimeListParser(String link) : super(link);
  
  @override
  List<AnimeInfo> parseHTML(Document body) {
    List<AnimeInfo> list = [];

    final elements = body.getElementsByClassName("row-hover");
    final e = elements.first;

    if (e.hasChildNodes()) {
      e.nodes.forEach((n) {
        list.add(new AnimeInfo(n));
      });
    }

    return list;
  }

}
