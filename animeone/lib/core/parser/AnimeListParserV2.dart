import 'dart:convert';

import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This class parses all anime available from the site by requesting to
class AnimeListParserV2 extends BasicParser {
  AnimeListParserV2() : super('https://d1zquzjgwo9yb.cloudfront.net/?_=');

  @override
  List<AnimeInfo> parseHTML(Document? body) {
    List<AnimeInfo> list = [];

    final text = body?.children[0].text;
    if (text == null) return list;

    final json = jsonDecode(text);
    // It should be a list of list
    if (json is List) {
      json.forEach((item) {
        // 0 means that it is 🔞
        if (item is List && item[0] > 0) {
          list.add(AnimeInfo.fromList(item));
        }
      });
    } else {
      throw Exception('Invalid json');
    }

    return list;
  }
}
