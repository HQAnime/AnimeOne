import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeSeason.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/AnimeListParser.dart';
import 'package:animeone/core/parser/AnimeRecentParser.dart';
import 'package:animeone/core/parser/AnimeScheduleParser.dart';
import 'package:html/dom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'anime/AnimeInfo.dart';

/// A class has constants and also a list of all anime
class GlobalData {

  static final domain = 'https://anime1.me/';
  static final version = '0.0.2';

  // Relating to local data
  final prefs = SharedPreferences.getInstance();
  static final lastUpdate = 'AnimeOne:LastUpdate';
  static final animeList = 'AnimeOne:LastUpdate';
  static final animeScedule = 'AnimeOne:LastUpdate';

  // Relating to seasonal anime
  static final _season = new AnimeSeason(DateTime.now());
  String getSeasonName() => _season.toString();
  String getScheduleLink() => _season.getLink();
  String getSeasonLink() => _season.getAnimeLink();
  
  // Relating to anime list (it won't be changed)
  List<AnimeInfo> _animeList = [];
  List<AnimeInfo> getAnimeList() => this._animeList;
  // Relating to anime scedule (it doesn't change as well)
  AnimeVideo _introductory;
  AnimeVideo getIntroVideo() => this._introductory;
  List<AnimeSchedule> _animeScheduleList = [];
  List<AnimeSchedule> getScheduleList() => this._animeScheduleList;
  // Relating to recent anime
  AnimeRecentParser _recentParser;
  List<AnimeRecent> _recentList = [];
  List<AnimeRecent> getRecentList() => this._recentList;

  // Singleton pattern 
  GlobalData._init();
  static final GlobalData _instance = new GlobalData._init();

  // Use dart's factory constructor to implement this patternx
  factory GlobalData() {
    return _instance;
  }

  /// Get data from anime1.me if necessary
  Future init() async {
    // Load anime list
    this._getAnimeList();

    // Load anime schedule
    this._getAnimeScedule();

    // Load recent anime 
    this.getRecentAnime();
  }

  Future _getAnimeList() async {
    final parser = new AnimeListParser(domain);
    Document doc = await parser.downloadHTML();
    // Check if it is valid
    if (doc != null) {
      this._animeList = parser.parseHTML(doc);
    }
  }

  Future _getAnimeScedule() async {
    final parser = new AnimeScheduleParser(this.getScheduleLink());
    final body = await parser.downloadHTML();
    this._animeScheduleList = parser.parseHTML(body);
    this._introductory = parser.parseIntroductoryVideo(body);
  }

  /// Load recent anime
  Future getRecentAnime() async {
    this._recentParser = new AnimeRecentParser(GlobalData.domain + '留言板');
    final body = await this._recentParser.downloadHTML();
    this._recentList = this._recentParser.parseHTML(body);
  }

  /// launch wikipedia page for anime
  void getWikipediaLink(String name) {
    final link = 'https://zh.wikipedia.org/w/index.php?search=$name';
    launch(link);
  }

}
