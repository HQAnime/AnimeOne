import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';

/// This class saves anime name, link and schedule (0 - 6)
class AnimeSchedule {

  String name;
  String link;
  int weekday;

  AnimeSchedule(Node tr, int i) {
    this.weekday = i;
    // Fix for Sunday (anime1 puts Sunday first)
    if (weekday == 0) weekday = 7;

    this.name = tr.firstChild.text;
    this.link = GlobalData.domain + tr.firstChild.attributes['href'];
  }
}