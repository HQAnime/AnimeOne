import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';

import 'AnimeBasic.dart';

/// This class parses a Node and stores anime info like anime name, anime link, total episodes, year, season and subtitle group
class AnimeInfo extends AnimeBasic {
  String? episode;
  String? year;
  String? season;
  String? subtitle;

  AnimeInfo(Node tr) : super.fromJson(null) {
    final list = tr.nodes;
    try {
      name = list[0].text;
      final href = list[0].nodes[0].attributes["href"];
      if (href != null) link = GlobalData.domain + href;
      episode = list[1].text;
      year = list[2].text;
      season = list[3].text;
      subtitle = list[4].text ?? "-";
    } catch (e) {
      throw Exception('AnimeInfo - Tr has been changed\n${e.toString()}');
    }
  }

  @override
  bool contains(String t) {
    // emm, any better way of writing this?
    if (super.contains(t)) return true;
    if (year != null && season != null && (year! + season!).contains(t)) {
      return true;
    }
    if (episode != null && episode!.contains(t)) return true;
    if (subtitle != null && subtitle!.contains(t)) return true;

    return false;
  }

  AnimeInfo.fromJson(Map<String, dynamic> json)
      : episode = json['episode'],
        year = json['year'],
        season = json['season'],
        subtitle = json['subtitle'],
        super.fromJson(json);

  AnimeInfo.fromList(List list) : super.fromJson(null) {
    // The ID is the link
    link = 'https://anime1.me/?cat=${list[0]}';
    name = list[1];
    episode = list[2];
    year = list[3];
    season = list[4];
    subtitle = list[5];
  }

  Map<String, dynamic> toJson() => {
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
