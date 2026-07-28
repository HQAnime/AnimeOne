import 'dart:async';
import 'dart:convert';
import 'package:animeone/core/translation/TranslationCache.dart';
import 'package:http/http.dart' as http;

class _TranslationRequest {
  final String text;
  final String targetLang;
  final Completer<String?> completer;
  _TranslationRequest(this.text, this.targetLang, this.completer);
}

class TranslationService {
  static final List<_TranslationRequest> _queue = [];
  static final Map<String, Completer<String?>> _pending = {};
  static bool _working = false;

  static Future<String?> translate(String text, String targetLang) async {
    if (text.isEmpty) return null;

    final cached = TranslationCache.get(text);
    if (cached != null) return cached;

    final key = '$text|$targetLang';
    final existing = _pending[key];
    if (existing != null) return existing.future;

    final completer = Completer<String?>();
    _pending[key] = completer;
    _queue.add(_TranslationRequest(text, targetLang, completer));
    _processQueue();
    return completer.future;
  }

  static Future<void> _processQueue() async {
    if (_working) return;
    _working = true;
    while (_queue.isNotEmpty) {
      final req = _queue.removeAt(0);
      final key = '${req.text}|${req.targetLang}';
      _pending.remove(key);
      final result = await _fetch(req.text, req.targetLang);
      if (result != null) {
        TranslationCache.put(req.text, result);
      }
      req.completer.complete(result);
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _working = false;
  }

  static void cancelPending() {
    for (final req in _queue) {
      req.completer.complete(null);
    }
    _queue.clear();
    _pending.clear();
  }

  /// Try Wikipedia zh→target, fallback to Google Translate
  static Future<String?> _fetch(String text, String target) async {
    final zhTitle = await _searchZhWikipedia(text);
    if (zhTitle != null) {
      final direct = await _langlink('zh.wikipedia.org', zhTitle, target);
      if (direct != null) return direct;
    }
    return _tryGoogle(text, target);
  }

  /// Search zh.wikipedia for a page matching [text], return its title.
  static Future<String?> _searchZhWikipedia(String text) async {
    try {
      final uri = Uri.https('zh.wikipedia.org', '/w/api.php', {
        'action': 'query',
        'list': 'search',
        'srsearch': text,
        'format': 'json',
        'utf8': '1',
        'srlimit': '1',
      });
      final res = await http.get(uri);
      if (res.statusCode != 200) return null;
      final body = json.decode(res.body) as Map;
      final query = body['query'] as Map?;
      final searchList = query?['search'] as List?;
      if (searchList == null || searchList.isEmpty) return null;
      return (searchList[0] as Map)['title'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// Get the interlanguage link from [domain] for [title] in [targetLang].
  static Future<String?> _langlink(
      String domain, String title, String targetLang) async {
    try {
      final uri = Uri.https(domain, '/w/api.php', {
        'action': 'query',
        'titles': title,
        'prop': 'langlinks',
        'lllang': targetLang,
        'format': 'json',
        'utf8': '1',
      });
      final res = await http.get(uri);
      if (res.statusCode != 200) return null;
      final body = json.decode(res.body) as Map;
      final query = body['query'] as Map?;
      final pages = query?['pages'] as Map?;
      if (pages == null || pages.isEmpty) return null;
      final page = pages.values.first as Map?;
      if (page == null) return null;
      final langlinks = page['langlinks'] as List?;
      if (langlinks == null || langlinks.isEmpty) return null;
      return (langlinks[0] as Map)['*'] as String?;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _tryGoogle(String text, String target) async {
    try {
      final uri = Uri.https('translate.googleapis.com', '/translate_a/single', {
        'client': 'gtx',
        'sl': 'zh-cn',
        'tl': target,
        'dt': 't',
        'q': text,
      });
      final res = await http.get(uri);
      if (res.statusCode != 200) return null;
      final body = json.decode(res.body) as List;
      final sentences = body[0] as List;
      if (sentences.isEmpty) return null;
      final translated = sentences.map((s) => (s as List)[0] as String).join();
      return translated;
    } catch (_) {
      return null;
    }
  }
}
