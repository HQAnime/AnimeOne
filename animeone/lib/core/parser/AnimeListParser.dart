import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This class parses all anime available from the site
@Deprecated("This parser is no longer working and shouldn't be used")
class AnimeListParser extends BasicParser {
  AnimeListParser(String link) : super(link);

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
