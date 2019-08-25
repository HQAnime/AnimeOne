import 'package:animeone/core/GlobalData.dart';
import 'package:html/dom.dart';

/// This class saves anime name, link and schedule (0 - 6)
class AnimeSchedule {

  String name;
  String link;
  int day;

  AnimeSchedule(Node tr, int i) {
    this.day = i;
    this.name = tr.firstChild.text;
    this.link = GlobalData.domain + tr.firstChild.attributes['href'];
  }
}