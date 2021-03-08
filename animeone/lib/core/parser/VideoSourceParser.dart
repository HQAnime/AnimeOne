import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

class VideoSourceParser extends BasicParser {
  
  VideoSourceParser(String link) : super(link);
  
  @override
  String? parseHTML(Document? body) {
    if (body == null) return null;

    String? videoSrc;

    final sources = body.getElementsByTagName('source');
    if (sources.length > 0) {
      // It has a source tag
      videoSrc = sources.first.attributes['src']; 
    } else {
      // Use regex to parse source
      // The string is link https://xxx.anime1.app/xx/xxxx.mp4?h=xxx&e=xxx&ip=xxxxxxx
      String regex = 'file:\"(.*?\.mp4.*?)\"';
      RegExp ex = RegExp(regex);
      final match = ex.firstMatch(body.outerHtml);
      if (match != null) {
        videoSrc = match[1];
      }
    }

    return videoSrc;
  }

}