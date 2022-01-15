import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This class parses all anime available from the site by requesting to https://d1zquzjgwo9yb.cloudfront.net/?_=
class AnimeListV2Parser extends BasicParser {
  AnimeListV2Parser(String timeStamp) {}

  @override
  List<AnimeInfo> parseHTML(Document? body) {
    List<AnimeInfo> list = [];

    final elements = body?.getElementsByClassName("row-hover");
    final e = elements?.first;

    if (e?.hasChildNodes() ?? false) {
      e?.nodes.forEach((n) => list.add(new AnimeInfo(n)));
    }

    return list;
  }
}
