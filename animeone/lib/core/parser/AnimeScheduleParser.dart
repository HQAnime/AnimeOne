import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This class get anime schedule and possibly an introductory video
class AnimeScheduleParser extends BasicParser {
  
  AnimeScheduleParser(String link) : super(link);

  @override
  List<AnimeSchedule> parseHTML(Document? body) {
    List<AnimeSchedule> schedules = [];

    final tables = body.getElementsByTagName('table');
    final tbody = tables.first.nodes[1];
    tbody.nodes.forEach((tr) {
      // anime1.me is also one line (so check the length to prevent it)
      if (tr.nodes.length > 1) {
        // It is in order so use an index to indicate the date
        int i = 0;
        tr.nodes.forEach((td) {
          AnimeSchedule t = new AnimeSchedule(td, i++);
          if (t.valid()) schedules.add(t);
        });
      }
    });

    return schedules;
  }

  /// get AnimeVideo from schedule (there might be one)
  AnimeVideo? parseIntroductoryVideo(Document? body) {
    final frames = body?.getElementsByTagName('iframe');
    if (frames == null || frames.length == 0) {
      return null;
    } else {
      return new AnimeVideo(frames.first.attributes['src']);
    }
  }

}
