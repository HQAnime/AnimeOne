import 'dart:convert';

import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

class VideoSourceParser extends BasicParser {
  VideoSourceParser() : super('https://v.anime1.me/api');

  @override
  String? parseHTML(Document? body) {
    try {
      final rawJSON = body?.children[0];
      if (rawJSON == null) return null;
      final videoJSON = json.decode(rawJSON.text) as Map?;
      print(videoJSON);
      // it is now a list
      final videoLink = videoJSON?['s']?[0]?['src'] as String?;
      if (videoLink == null) return null;

      if (videoLink.contains('http')) return videoLink;
      return 'https:$videoLink';
    } catch (e, s) {
      print(s);
      assert(false, 'VideoSourceParser - Error parsing HTML\n$e');
      return null;
    }
  }
}
