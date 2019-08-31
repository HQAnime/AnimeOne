import 'dart:convert';

import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeSeason.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/AnimeListParser.dart';
import 'package:animeone/core/parser/AnimeRecentParser.dart';
import 'package:animeone/core/parser/AnimeScheduleParser.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'anime/AnimeInfo.dart';

/// A class has constants and also a list of all anime
class GlobalData {

  static final domain = 'https://anime1.me/';
  static final version = '0.0.2';

  // Relating to local data
  SharedPreferences prefs;
  static final lastUpdate = 'AnimeOne:LastUpdate';
  static final animeList = 'AnimeOne:AnimeList';
  static final animeScedule = 'AnimeOne:AnimeScedule';
  static final scheduleIntroVide = 'AnimeOne:SceduleIntroVideo';

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
    bool shouldUpdate = false;

    prefs = await SharedPreferences.getInstance();
    // Check if data are stored properly
    // prefs.getKeys().forEach((k) {
    //   debugPrint('$k ${prefs.get(k)}');
    // });

    String update = prefs.getString(lastUpdate);
    if (update == null) {
      prefs.setString(lastUpdate, DateTime.now().toIso8601String());
      shouldUpdate = true;
    } else {
      final diff = DateTime.now().difference(DateTime.parse(update));
      // Check for update once a wekk
      if (diff.inDays >= 7) {
        shouldUpdate = true;
      }
    }

    // Get new data and save them locally
    if (shouldUpdate) {
      // Load anime list
      await this._getAnimeList();
      prefs.setString(animeList, jsonEncode(this._animeList));
      // Load anime schedule
      await this._getAnimeScedule();
      prefs.setString(animeScedule, jsonEncode(this._animeScheduleList));
      prefs.setString(scheduleIntroVide, jsonEncode(this._introductory));
    } else {
      // Load from storage
    
      List<dynamic> savedAnimeList = jsonDecode(prefs.getString(animeList));
      savedAnimeList.forEach((json) {
        this._animeList.add(AnimeInfo.fromJson(json)); 
      });

      List<dynamic> savedScheduleList = jsonDecode(prefs.getString(animeScedule));
      savedScheduleList.forEach((json) {
        this._animeScheduleList.add(AnimeSchedule.fromJson(json)); 
      });

      this._introductory = AnimeVideo.fromJson(jsonDecode(prefs.getString(scheduleIntroVide)));
    }

    // Load recent anime, you always need to load this
    await this.getRecentAnime();
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
