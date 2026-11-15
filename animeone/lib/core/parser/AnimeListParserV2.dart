import 'dart:convert';

import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';
import 'package:logging/logging.dart';

/// This class parses all anime available from the site by requesting to
class AnimeListParserV2 extends BasicParser {
  AnimeListParserV2() : super('https://anime1.me/animelist.json?_=');

  final _logger = Logger('AnimeListParserV2');

  @override
  List<AnimeInfo> parseHTML(Document? body) {
    List<AnimeInfo> list = [];

    final children = body?.children;
    if (children == null || children.isEmpty) return list;
    final text = children[0].text;

    final json = jsonDecode(text);
    // It should be a list of list
    if (json is List) {
      for (final item in json) {
        // 0 means that it is 🔞
        if (item is List && item.isNotEmpty && item[0] is num && item[0] > 0) {
          // [id, name, episode, year, season, subtitle]
          if (item.length < 6) {
            _logger.warning('Skipping malformed anime list entry: $item');
            continue;
          }
          try {
            list.add(AnimeInfo.fromList(item));
          } catch (e, s) {
            // One broken entry must not break the whole list.
            _logger.warning('Skipping invalid anime list entry', e, s);
          }
        }
      }
    } else {
      throw Exception('Invalid json');
    }

    return list;
  }
}
