import 'dart:async';
import 'dart:convert';

import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeSeason.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/other/GithubUpdate.dart';
import 'package:animeone/core/parser/AnimeListParserV2.dart';
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
  static final version = '1.1.8';

  static final githubRelease =
      'https://raw.githubusercontent.com/HenryQuan/AnimeOne/api/app.json';
  static final latestRelease =
      'https://github.com/HenryQuan/AnimeOne/releases/latest';

  static final eminaOne = 'https://github.com/splitline/emina-one';
  static final animeGo = 'https://github.com/HenryQuan/AnimeGo';

  /// if update has been checked
  bool hasUpdate = false;

  /// A flag to check if cookie is necessary
  static String? requestCookieLink = '';

  // Relating to local data
  late SharedPreferences prefs;
  static final lastUpdate = 'AnimeOne:LastUpdate';
  static final animeList = 'AnimeOne:AnimeList';
  static final animeScedule = 'AnimeOne:AnimeScedule';
  static final scheduleIntroVideo = 'AnimeOne:SceduleIntroVideo';
  static final oneCookie = 'AnimeOne:OneCookie';
  static final oneUserAgent = 'AnimeOne:OneUserAgent';
  static final ageRestriction = 'AnimeOne:AgeRestriction';

  // Relating to seasonal anime
  static final _season = new AnimeSeason(DateTime.now());
  String getSeasonName() => _season.toString();
  String getScheduleLink() => _season.getLink();
  String getSeasonLink() => _season.getAnimeLink();
  List<String> getQuickFilters() => _season.getQuickFilters();

  // Relating to anime list (it won't be changed)
  List<AnimeInfo> _animeList = [];
  List<AnimeInfo> getAnimeList() => this._animeList;
  // Relating to anime scedule (it doesn't change as well)
  AnimeVideo? _introductory;
  AnimeVideo? getIntroVideo() => this._introductory;
  List<AnimeSchedule> _animeScheduleList = [];
  List<AnimeSchedule> getScheduleList() => this._animeScheduleList;
  // Relating to recent anime
  late AnimeRecentParser _recentParser;
  List<AnimeRecent> _recentList = [];
  List<AnimeRecent> getRecentList() => this._recentList;
  // Saved cookie for animeon
  String? _cookie;
  String? _userAgent;

  /// Use videopassword as the default cookie
  String getCookie() => _cookie ?? 'videopassword=0';
  void updateCookie(String cookie) {
    _cookie = cookie;
    // Add video password if not included
    if (!cookie.contains('videopassword')) {
      _cookie = _cookie! + '; videopassword=0';
    }

    prefs.setString(oneCookie, _cookie!);
  }

  String getUserAgent() => _userAgent ?? '';
  void updateUserAgent(String agent) {
    _userAgent = agent;
    prefs.setString(oneUserAgent, agent);
  }

  // Age restriction
  bool _showAgeAlert = false;
  bool showShowAgeAlert() => _showAgeAlert;
  void updateAgeAlert() {
    _showAgeAlert = false;
    prefs.setString(ageRestriction, jsonEncode(false));
  }

  // Relating to Github update
  GithubUpdate? _update;
  GithubUpdate? getGithubUpdate() => this._update;

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

    // Whether an age alert shoud be shown
    String? ageAlert = prefs.get(ageRestriction) as String?;
    if (ageAlert == null) {
      this._showAgeAlert = true;
    }

    // Get saved cookie
    String? savedCookie = prefs.getString(oneCookie);
    if (savedCookie != null) {
      this._cookie = savedCookie;
      print('Cookie - $savedCookie');
    }

    // Get saved user agent
    String? savedUserAgent = prefs.getString(oneUserAgent);
    if (savedUserAgent != null) {
      this._userAgent = savedUserAgent;
      print('User agent - $savedUserAgent');
    }

    // Check if this is the new version
    String? newVersion = prefs.getString(version);
    if (newVersion == null) {
      // Only update once when there is a new update
      prefs.setString(version, 'ok');
      shouldUpdate = true;
    }

    // Get last updated date
    String? update = prefs.getString(lastUpdate);
    if (update == null) {
      // Init update
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

      // Load anime schedule
      await this._getAnimeScedule();
    } else {
      // if anime list has been loaded but somehow, it failed
      // you need to reset the list so that it won't have duplicates
      this._resetList();

      // Load everything from storage
      final animeListJson = prefs.getString(animeList);
      if (animeListJson == null) {
        // cache it again if not found
        await this._getAnimeList();
      } else {
        List<dynamic> savedAnimeList = jsonDecode(animeListJson);
        savedAnimeList.forEach((json) {
          this._animeList.add(AnimeInfo.fromJson(json));
        });
      }

      // Same as anime list
      final scheduleListJson = prefs.getString(animeScedule);
      if (scheduleListJson == null) {
        // cache it again if not found
        await this._getAnimeScedule();
      } else {
        List<dynamic> savedScheduleList = jsonDecode(scheduleListJson);
        savedScheduleList.forEach((json) {
          this._animeScheduleList.add(AnimeSchedule.fromJson(json));
        });
      }

      final introductionString = prefs.getString(scheduleIntroVideo);
      // New anime introduction isn't that important so it is fine to fail
      if (introductionString != null && introductionString != "null") {
        this._introductory = AnimeVideo.fromJson(
          jsonDecode(introductionString),
        );
      }
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
      Document? body = await parser.downloadHTML();
      this._update = parser.parseHTML(body);
      this.hasUpdate = true;
    }
  }

  Future _getAnimeList() async {
    final parser = new AnimeListParserV2();
    Document? doc = await parser.downloadHTML();
    // Check if it is valid
    if (doc != null) {
      _animeList = parser.parseHTML(doc);
      if (_animeList.length > 0)
        prefs.setString(animeList, jsonEncode(_animeList));
    }
  }

  Future _getAnimeScedule() async {
    final link = this.getScheduleLink();
    final parser = new AnimeScheduleParser(link);
    final body = await parser.downloadHTML();
    _animeScheduleList = parser.parseHTML(body);
    _introductory = parser.parseIntroductoryVideo(body);
    // Only save it if it is valid
    if (_animeScheduleList.length > 0)
      prefs.setString(animeScedule, jsonEncode(_animeScheduleList));
    prefs.setString(scheduleIntroVideo, jsonEncode(_introductory));
  }

  /// Load recent anime
  Future getRecentAnime() async {
    this._recentParser = new AnimeRecentParser(GlobalData.domain);
    final body = await this._recentParser.downloadHTML();
    this._recentList = this._recentParser.parseHTML(body);
  }

  /// launch wikipedia page for anime
  void getWikipediaLink(String? name) {
    // Somehow I need to encode on IOS but not on Android
    final link = Uri.encodeFull(
      'https://zh.wikipedia.org/w/index.php?search=$name',
    );
    launch(link);
  }

  /// get a string like https://youtube.com/watch?v=xxx
  String getYouTubeLink(String? vid) {
    // you have found an easter egg maybe?
    return 'https://youtube.com/watch?v=' + (vid ?? 'dQw4w9WgXcQ');
  }

  /// send an email to HenryQuan
  void sendEmail(String? extra) {
    launch(
      'mailto:development.henryquan@gmail.com?subject=[AnimeOne ${GlobalData.version}]&body=$extra',
    );
  }
}
