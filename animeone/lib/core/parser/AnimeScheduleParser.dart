import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This class get anime schedule and possibly an introductory video
class AnimeScheduleParser extends BasicParser {
  AnimeScheduleParser(super.link);

  @override
  List<AnimeSchedule> parseHTML(Document? body) {
    List<AnimeSchedule> schedules = [];

    final tables = body?.getElementsByTagName('table');
    if (tables == null || tables.isEmpty) return schedules;

    // The site sometimes ships the table without <tbody>, so all rows live
    // directly under <thead>. Looking up nodes[1] then threw
    // "RangeError: Only valid value is 0: 1" (or, with a guard, returned an
    // empty schedule). Walk every row and only accept the 7 day cells.
    final rows = tables.first.getElementsByTagName('tr');
    for (final tr in rows) {
      final cells =
          tr.children.where((c) => c.localName == 'td').toList(growable: false);
      // Header rows use <th> and the footer uses one colspan cell.
      if (cells.length < 7) continue;
      // It is in order so use an index to indicate the date
      for (int i = 0; i < 7; i++) {
        final t = AnimeSchedule(cells[i], i);
        if (t.valid()) schedules.add(t);
      }
    }

    return schedules;
  }

  /// get AnimeVideo from schedule (there might be one)
  AnimeVideo? parseIntroductoryVideo(Document? body) {
    final frames = body?.getElementsByTagName('iframe');
    if (frames == null || frames.isEmpty) {
      return null;
    } else {
      return AnimeVideo(frames.first.attributes['src']);
    }
  }
}
