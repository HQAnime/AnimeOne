import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:html/dom.dart';

/// This class saves anime name, link and schedule (0 - 6)
class AnimeSchedule extends AnimeRecent {

  int weekday;

  AnimeSchedule(Node tr) : super(tr);

  AnimeSchedule(Node tr, int i) {
    this.weekday = i;
    // Fix for Sunday (anime1 puts Sunday first)
    if (weekday == 0) weekday = 7;
    weekday -= 1;
    
    // Same are empty
    if (tr.firstChild != null) {
      this.name = tr.firstChild.text;
      this.link = GlobalData.domain + tr.firstChild.attributes['href'];
    }
  }
}