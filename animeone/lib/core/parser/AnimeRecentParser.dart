import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:html/dom.dart';

import 'BasicParser.dart';

/// This class get recent anime
class AnimeRecentParser extends BasicParser {
  AnimeRecentParser(String link) : super(link);

  @override
  List<AnimeRecent> parseHTML(Document body) {
    List<AnimeRecent> recent = [];

    final widgets = body.getElementsByClassName('widget-area');
    final list = widgets.first.getElementsByTagName('ul');
    list.first.nodes.forEach((tr) {
      if (tr.text.trim() != "") {
        recent.add(new AnimeRecent(tr));
      }
    });

    return recent;
  }
}
