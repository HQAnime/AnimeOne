import 'dart:convert';

import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeSeason.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/other/GithubUpdate.dart';
import 'package:animeone/core/parser/AnimeListParser.dart';
import 'package:animeone/core/parser/AnimeRecentParser.dart';
import 'package:animeone/core/parser/AnimeScheduleParser.dart';
import 'package:animeone/core/parser/GithubParser.dart';
import 'package:html/dom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'anime/AnimeInfo.dart';

/// A class has constants and also a list of all anime
class GlobalData {

  static final domain = 'https://anime1.me/';
  static final version = '1.0.7';

  static final githubRelease = 'https://raw.githubusercontent.com/HenryQuan/AnimeOne/api/app.json';
  static final latestRelease = 'https://github.com/HenryQuan/AnimeOne/releases/latest';

  /// if update has been checked
  bool hasUpdate = false;

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

  // Relating to Github update
  GithubUpdate _update;
  GithubUpdate getGithubUpdate() => this._update;

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
      final now = DateTime.now();
      if (now.day == 1) {
        // Update if today is 1st Jan/Apr/Jul/Oct
        final newSeasonMonth = [1, 4, 7, 10];
        if (newSeasonMonth.indexOf(now.month) > -1) {
          prefs.setString(lastUpdate, now.toIso8601String());
          shouldUpdate = true;
        }
      } else {
        final diff = now.difference(DateTime.parse(update));
        // Check for update once a wekk
        if (diff.inDays >= 7) {
          // Remember to save new date!
          prefs.setString(lastUpdate, now.toIso8601String());
          shouldUpdate = true;
        }
      }
    }

    // Get new data and save them locally
    if (shouldUpdate) {
      // Check for update first to make sure you don't messed up auto update
      await this.checkGithubUpdate();
      
      // Load anime list
      await this._getAnimeList();
      prefs.setString(animeList, jsonEncode(this._animeList));

      // Load anime schedule
      await this._getAnimeScedule();
      prefs.setString(animeScedule, jsonEncode(this._animeScheduleList));
      prefs.setString(scheduleIntroVide, jsonEncode(this._introductory));

    } else {
      // if anime list has been loaded but somehow, it failed
      // you need to reset the list so that it won't have duplicates
      this._resetList();

      // Load everything from storage
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

  void _resetList() {
    this._animeList = [];
    this._animeScheduleList = [];
  }

  Future checkGithubUpdate() async {
    if (!this.hasUpdate) {
      final parser = new GithubParser(githubRelease);
      Document body = await parser.downloadHTML();
      this._update = parser.parseHTML(body);
      this.hasUpdate = true;
    }
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
    // Somehow I need to encode on IOS but not on Android
    final link = Uri.encodeFull('https://zh.wikipedia.org/w/index.php?search=$name');
    launch(link);
  }

  /// get a string like https://youtube.com/watch?v=xxx
  String getYouTubeLink(String vid) {
    return 'https://youtube.com/watch?v=' + vid;
  }

  /// send an email to HenryQuan
  void sendEmail(String extra) {
    launch('mailto:development.henryquan@gmail.com?subject=[AnimeOne ${GlobalData.version}]&body=$extra');
  }

}
