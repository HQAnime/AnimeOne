import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationCache {
  static const _key = 'AnimeOne:TranslationCache';
  static const _versionKey = 'AnimeOne:TranslationCacheVer';
  static const _version = 2;
  static Map<String, String> _map = {};
  static SharedPreferences? _prefs;
  static final translationAdded = ValueNotifier<String?>(null);

  static void init(SharedPreferences prefs) {
    _prefs = prefs;
    final ver = prefs.getInt(_versionKey);
    if (ver != _version) {
      prefs.remove(_key);
      prefs.setInt(_versionKey, _version);
      _map = {};
      return;
    }
    final raw = prefs.getString(_key);
    if (raw != null) {
      _map = Map<String, String>.from(json.decode(raw) as Map);
    }
  }

  static void _save() {
    final prefs = _prefs;
    if (prefs == null) return;
    prefs.setString(_key, json.encode(_map));
  }

  static String? get(String zh) => _map[zh];

  static bool has(String zh) => _map.containsKey(zh);

  static void put(String zh, String translated) {
    _map[zh] = translated;
    _save();
    translationAdded.value = zh;
  }

  static void clear() {
    _map.clear();
    _save();
  }
}
