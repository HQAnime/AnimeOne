
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:html/dom.dart';

import 'BasicParser.dart';

/// This class get recent anime
class AnimeRecentParser extends BasicParser {
  
  AnimeRecentParser(String link) : super(link);

  @override
  List<AnimeRecent> parseHTML(Document body) {
    List<AnimeRecent> recent = [];

    try {
      final widgets = body.getElementsByClassName('widget-area');
      final list = widgets.first.getElementsByTagName('ul');
      list.first.nodes.forEach((tr) {
        recent.add(new AnimeRecent(tr));
      });
    } catch (e, s) {
      print('Recent is currently not accessible');
      print(s);
    }

    return recent;
  }

}
