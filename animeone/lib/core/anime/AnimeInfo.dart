import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';

/// This class parses a Node and stores anime info like anime name, anime link, total episodes, year, season and subtitle group
class AnimeInfo {

  String name;
  String link;
  String episode;
  String year;
  String season;
  String subtitle;

  AnimeInfo(Node tr) {
    final list = tr.nodes;
    try {
      this.name = list[0].text;
      this.link = GlobalData.domain + list[0].nodes[0].attributes["href"];
      this.episode = list[1].text;
      this.year = list[2].text;
      this.season = list[3].text;
      this.subtitle = list[4].text;
      if (this.subtitle == "") this.subtitle = '-';
    } catch (e) {
      throw new Exception('AnimeInfo - Tr has been changed\n${e.toString()}');
    }
  }

  @override
  String toString() {
    return "Name: $name\nLink: $link\nEpisode: $episode\nYear: $year\nSeason: $season\nSubtitle: $subtitle";
  }

  bool contains(String t) {
    String tL = t.toLowerCase();
    String nL = this.name.toLowerCase();
    return nL.contains(tL);
  }

}
