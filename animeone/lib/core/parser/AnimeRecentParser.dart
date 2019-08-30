
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:html/dom.dart';

import 'AnimeParser.dart';

/// This class get recent anime
class AnimeRecentParser extends AnimeParser {
  
  AnimeRecentParser(String link) : super(link);

  @override
  List<AnimeRecent> parseHTML(Document body) {
    List<AnimeRecent> recent = [];

    final widgets = body.getElementsByClassName('widget-area');
    final list = widgets.first.getElementsByTagName('ul');
    list.first.nodes.forEach((tr) {
      recent.add(new AnimeRecent(tr));
    });

    return recent;
  }

}
