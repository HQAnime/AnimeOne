import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:html/dom.dart';

import 'BasicParser.dart';

/// This class get recent anime
class AnimeRecentParser extends BasicParser {
  AnimeRecentParser(String link) : super(link);

  @override
  List<AnimeRecent> parseHTML(Document? body) {
    List<AnimeRecent> recent = [];

    final widgets = body?.getElementsByClassName('widget-area');
    assert(widgets != null, 'AnimeRecentParser - Error parsing HTML');
    final list = widgets?.first.getElementsByTagName('ul');
    final nodes = list?.first.nodes;
    assert(nodes != null, 'AnimeRecentParser - Error parsing HTML');
    for (final tr in nodes ?? []) {
      if (tr.text?.trim() != "") {
        recent.add(AnimeRecent(tr));
      }
    }
    return recent;
  }
}
