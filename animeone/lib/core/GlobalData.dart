import 'package:animeone/core/anime/AnimeSeason.dart';
import 'package:animeone/core/parser/AnimeListParser.dart';
import 'package:html/dom.dart';
import 'package:url_launcher/url_launcher.dart';

import 'anime/AnimeInfo.dart';

/// A class has constants and also a list of all anime
class GlobalData {

  static final domain = 'https://anime1.me/';
  static final version = '0.0.1';

  static final _season = new AnimeSeason(DateTime.now());
  String getSeason() => _season.toString();
  
  List<AnimeInfo> _animeList = [];
  List<AnimeInfo> getAnimeList() => this._animeList;

  // Singleton pattern 
  GlobalData._init();
  static final GlobalData _instance = new GlobalData._init();

  // Use dart's factory constructor to implement this patternx
  factory GlobalData() {
    return _instance;
  }

  /// Get data from anime1.me
  Future init() async {
    final parser = new AnimeListParser(domain);
    Document doc = await parser.downloadHTML();
    // Check if it is valid
    if (doc != null) {
      this._animeList = parser.parseHTML(doc);
    }
  }

  /// launch wikipedia page for anime
  void getWikipediaLink(String name) {
    final link = 'https://zh.wikipedia.org/w/index.php?search=$name';
    launch(link);
  }

}
