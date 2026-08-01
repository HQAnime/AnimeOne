import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:animeone/core/WatchEntry.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeSeason.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/other/GithubUpdate.dart';
import 'package:animeone/core/parser/AnimeListParserV2.dart';
import 'package:animeone/core/parser/AnimeRecentParser.dart';
import 'package:animeone/core/parser/AnimeScheduleParser.dart';
import 'package:animeone/core/parser/GithubParser.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'anime/AnimeInfo.dart';
import 'package:animeone/core/translation/TranslationCache.dart';
import 'package:animeone/l10n/app_localizations.dart';

/// A class has constants and also a list of all anime
class GlobalData {
  final _logger = Logger('GlobalData');
  static const domain = 'https://anime1.me/';
  static const version = '1.2.0';

  static const githubRelease =
      'https://raw.githubusercontent.com/HenryQuan/AnimeOne/api/app.json';
  static const latestRelease =
      'https://github.com/HenryQuan/AnimeOne/releases/latest';

  static const eminaOne = 'https://github.com/splitline/emina-one';
  static const oneAnime = 'https://github.com/Predidit/oneAnime';
  static const animeGo = 'https://github.com/HenryQuan/AnimeGo';

  /// if update has been checked
  bool hasUpdate = false;

  /// A flag to check if cookie is necessary
  static String? requestCookieLink = '';

  // Relating to local data
  late SharedPreferences prefs;
  static SharedPreferences? _prefsCache;

  SharedPreferences? get _prefs => _prefsCache;
  static const lastUpdate = 'AnimeOne:LastUpdate';
  static const animeList = 'AnimeOne:AnimeList';
  static const animeScedule = 'AnimeOne:AnimeScedule';
  static const scheduleIntroVideo = 'AnimeOne:SceduleIntroVideo';
  static const oneCookie = 'AnimeOne:OneCookie';
  static const oneUserAgent = 'AnimeOne:OneUserAgent';
  static const ageRestriction = 'AnimeOne:AgeRestriction';
  static const fontScaleKey = 'AnimeOne:FontScale';
  static const historyKey = 'AnimeOne:WatchHistory';
  static const darkModeKey = 'AnimeOne:ForceDark';
  static const localeKey = 'AnimeOne:Locale';
  static final localeNotifier = ValueNotifier<Locale?>(null);

  double _fontScale = 1.0;
  Locale? _locale;
  static final fontScaleNotifier = ValueNotifier<double>(1.0);
  static final historyNotifier = ValueNotifier<int>(0);
  static final darkModeNotifier = ValueNotifier<bool>(false);
  double getFontScale() => _fontScale;
  void setFontScale(double v) {
    _fontScale = v;
    prefs.setDouble(fontScaleKey, v);
    fontScaleNotifier.value = v;
  }

  void initFontScale() {
    _fontScale = prefs.getDouble(fontScaleKey) ?? 1.0;
    fontScaleNotifier.value = _fontScale;
  }

  bool getForceDark() => darkModeNotifier.value;
  void setForceDark(bool v) {
    prefs.setBool(darkModeKey, v);
    darkModeNotifier.value = v;
  }

  void initDarkMode() {
    darkModeNotifier.value = prefs.getBool(darkModeKey) ?? false;
  }

  Locale? getLocale() => _locale;
  void setLocale(String code) {
    _locale = Locale(code);
    prefs.setString(localeKey, code);
    localeNotifier.value = _locale;
  }

  void initLocale() {
    final code = prefs.getString(localeKey);
    if (code != null) {
      _locale = Locale(code);
      localeNotifier.value = _locale;
    }
  }

  List<WatchEntry> getHistory() {
    final p = _prefs;
    if (p == null) return [];
    final raw = p.getString(historyKey);
    if (raw == null) return [];
    final list = json.decode(raw) as List;
    final result = list
        .map((e) => WatchEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return result;
  }

  void saveWatchEntry(WatchEntry entry) {
    final p = _prefs;
    if (p == null) return;
    final history = getHistory();
    final abs = _absLink(entry.episodeLink);
    final idx = history.indexWhere((e) => _absLink(e.episodeLink) == abs);
    if (idx >= 0) {
      history[idx] = entry;
    } else {
      history.add(entry);
    }
    p.setString(
        historyKey, json.encode(history.map((e) => e.toJson()).toList()));
    historyNotifier.value++;
  }

  String _absLink(String link) {
    return link.startsWith('http') ? link : '$domain$link';
  }

  WatchEntry? getWatchEntry(String episodeLink) {
    final p = _prefs;
    if (p == null) return null;
    final abs = _absLink(episodeLink);
    final history = getHistory();
    final idx = history.indexWhere((e) => _absLink(e.episodeLink) == abs);
    return idx >= 0 ? history[idx] : null;
  }

  void clearHistory() {
    final p = _prefs;
    if (p == null) return;
    p.remove(historyKey);
    historyNotifier.value++;
  }

  // Relating to seasonal anime
  static final _season = AnimeSeason(DateTime.now());
  String getSeasonName([AppLocalizations? l]) =>
      l != null ? _season.getLocalizedName(l) : _season.toString();
  String getScheduleLink() => _season.getLink();
  String getSeasonLink() => _season.getAnimeLink();
  List<({String label, String value})> getQuickFilters(AppLocalizations l) =>
      _season.getQuickFilters(l);

  // Relating to anime list (it won't be changed)
  List<AnimeInfo> _animeList = [];
  List<AnimeInfo> getAnimeList() => _animeList;
  // Relating to anime scedule (it doesn't change as well)
  AnimeVideo? _introductory;
  AnimeVideo? getIntroVideo() => _introductory;
  List<AnimeSchedule> _animeScheduleList = [];
  List<AnimeSchedule> getScheduleList() => _animeScheduleList;
  // Relating to recent anime
  late AnimeRecentParser _recentParser;
  List<AnimeRecent> _recentList = [];
  List<AnimeRecent> getRecentList() => _recentList;
  // Saved cookie for animeon
  String? _cookie;
  String? _userAgent;

  /// Use videopassword as the default cookie
  String getCookie() => _cookie ?? 'videopassword=0';
  void updateCookie(String cookie) {
    _cookie = cookie;
    // Add video password if not included
    if (!cookie.contains('videopassword')) {
      _cookie = '$_cookie; videopassword=0';
    }

    prefs.setString(oneCookie, _cookie ?? 'videopassword=0');
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
  GithubUpdate? getGithubUpdate() => _update;

  // Singleton pattern
  GlobalData._init();
  static final GlobalData _instance = GlobalData._init();

  // Use dart's factory constructor to implement this patternx
  factory GlobalData() {
    return _instance;
  }

  /// Get data from anime1.me if necessary
  Future init() async {
    bool shouldUpdate = false;

    prefs = await SharedPreferences.getInstance();
    _prefsCache = prefs;
    // Check if data are stored properly
    if (kDebugMode) {
      prefs.getKeys().forEach((k) {
        debugPrint('$k ${prefs.get(k)}');
      });
    }

    // Font scale
    initFontScale();
    // Dark mode
    initDarkMode();
    // Locale
    initLocale();
    // Translation
    TranslationCache.init(prefs);

    // Whether an age alert shoud be shown
    String? ageAlert = prefs.get(ageRestriction) as String?;
    if (ageAlert == null) {
      _showAgeAlert = true;
    }

    // Get saved cookie
    String? savedCookie = prefs.getString(oneCookie);
    if (savedCookie != null) {
      _cookie = savedCookie;
      _logger.info('Cookie - $savedCookie');
    }

    // Get saved user agent
    String? savedUserAgent = prefs.getString(oneUserAgent);
    if (savedUserAgent != null) {
      _userAgent = savedUserAgent;
      _logger.info('User agent - $savedUserAgent');
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
        if (newSeasonMonth.contains(now.month)) {
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
      await checkGithubUpdate();

      // Load anime list
      await _getAnimeList();

      // Load anime schedule
      await _getAnimeScedule();
    } else {
      // if anime list has been loaded but somehow, it failed
      // you need to reset the list so that it won't have duplicates
      _resetList();

      // Load everything from storage
      final animeListJson = prefs.getString(animeList);
      if (animeListJson == null) {
        // cache it again if not found
        await _getAnimeList();
      } else {
        List<dynamic> savedAnimeList = jsonDecode(animeListJson);
        for (final json in savedAnimeList) {
          _animeList.add(AnimeInfo.fromJson(json));
        }
      }

      // Same as anime list
      final scheduleListJson = prefs.getString(animeScedule);
      if (scheduleListJson == null) {
        // cache it again if not found
        await _getAnimeScedule();
      } else {
        List<dynamic> savedScheduleList = jsonDecode(scheduleListJson);
        for (final json in savedScheduleList) {
          _animeScheduleList.add(AnimeSchedule.fromJson(json));
        }
      }

      final introductionString = prefs.getString(scheduleIntroVideo);
      // New anime introduction isn't that important so it is fine to fail
      if (introductionString != null && introductionString != "null") {
        _introductory = AnimeVideo.fromJson(
          jsonDecode(introductionString),
        );
      }
    }

    // Load recent anime, you always need to load this
    await getRecentAnime();
  }

  void _resetList() {
    _animeList = [];
    _animeScheduleList = [];
  }

  Future checkGithubUpdate() async {
    if (!hasUpdate) {
      final parser = GithubParser(githubRelease);
      Document? body = await parser.downloadHTML();
      _update = parser.parseHTML(body);
      hasUpdate = true;
    }
  }

  Future _getAnimeList() async {
    final parser = AnimeListParserV2();
    Document? doc = await parser.downloadHTML();
    // Check if it is valid
    if (doc != null) {
      _animeList = parser.parseHTML(doc);
      if (_animeList.isNotEmpty) {
        prefs.setString(animeList, jsonEncode(_animeList));
      }
    }
  }

  Future _getAnimeScedule() async {
    final link = getScheduleLink();
    final parser = AnimeScheduleParser(link);
    final body = await parser.downloadHTML();
    _animeScheduleList = parser.parseHTML(body);
    _introductory = parser.parseIntroductoryVideo(body);
    // Only save it if it is valid
    if (_animeScheduleList.isNotEmpty) {
      prefs.setString(animeScedule, jsonEncode(_animeScheduleList));
    }
    prefs.setString(scheduleIntroVideo, jsonEncode(_introductory));
  }

  /// Load recent anime
  Future getRecentAnime() async {
    _recentParser = AnimeRecentParser(GlobalData.domain);
    final body = await _recentParser.downloadHTML();
    _recentList = _recentParser.parseHTML(body);
  }

  /// launchUrlString wikipedia page for anime
  void getWikipediaLink(String? name) {
    // Somehow I need to encode on IOS but not on Android
    final link = Uri.encodeFull(
      'https://zh.wikipedia.org/w/index.php?search=$name',
    );
    launchUrlString(link);
  }

  /// get a string like https://youtube.com/watch?v=xxx
  String getYouTubeLink(String? vid) {
    // you have found an easter egg maybe?
    return 'https://youtube.com/watch?v=${vid ?? 'dQw4w9WgXcQ'}';
  }

  /// send an email to HenryQuan
  void sendEmail(String? extra) {
    launchUrlString(
      'mailto:development.henryquan@gmail.com?subject=[AnimeOne ${GlobalData.version}]&body=$extra',
    );
  }
}
