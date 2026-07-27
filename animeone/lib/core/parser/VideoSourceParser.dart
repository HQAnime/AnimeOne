import 'dart:convert';

import 'package:animeone/core/ApiService.dart';
import 'package:logging/logging.dart';

class VideoSourceResult {
  final String? url;
  final String? cookie;
  VideoSourceResult(this.url, this.cookie);
}

class VideoSourceParser {
  final _logger = Logger('VideoSourceParser');
  final _api = ApiService('https://v.anime1.me/api');

  Future<VideoSourceResult> resolve(String token) async {
    try {
      final res = await _api.post(
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'd=$token',
      );
      if (res == null) return VideoSourceResult(null, null);
      final rawJSON = json.decode(res.body);
      final src = rawJSON['s']?[0]?['src'] as String?;
      if (src == null) return VideoSourceResult(null, null);
      final url = src.contains('http') ? src : 'https:$src';
      return VideoSourceResult(url, res.headers['set-cookie']);
    } catch (e, s) {
      _logger.shout(s);
      return VideoSourceResult(null, null);
    }
  }
}
