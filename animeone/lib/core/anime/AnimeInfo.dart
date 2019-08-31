import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';

import 'AnimeBasic.dart';

/// This class parses a Node and stores anime info like anime name, anime link, total episodes, year, season and subtitle group
class AnimeInfo extends AnimeBasic {

  String episode;
  String year;
  String season;
  String subtitle;

  AnimeInfo(Node tr) : super.fromJson(null) {
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
  bool contains(String t) {
    if (super.contains(t) || 
        this.year.contains(t) ||
        this.season.contains(t) ||
        this.subtitle.contains(t)) {
      return true;
    }

    return false;
  }

  AnimeInfo.fromJson(Map<String, dynamic> json) : 
    episode = json['episode'],
    year = json['year'],
    season = json['season'],
    subtitle = json['subtitle'],
    super.fromJson(json);

  Map<String, dynamic> toJson() =>
  {
    'subtitle': subtitle,
    'season': season,
    'year': year,
    'episode': episode,
    'name': name,
    'link': link
  };

  @override
  String toString() {
    return "Name: $name\nLink: $link\nEpisode: $episode\nYear: $year\nSeason: $season\nSubtitle: $subtitle";
  }

}
