import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:html/dom.dart';

/// This class saves anime name, link and schedule (0 - 6)
class AnimeSchedule extends AnimeBasic {

  int weekday;

  AnimeSchedule(Node tr, int i): super.fromJson(null) {
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

  AnimeSchedule.fromJson(Map<String, dynamic> json) : 
    weekday = json['weekday'],
    super.fromJson(json);

  Map<String, dynamic> toJson() =>
  {
    'weekday': weekday,
    'name': name,
    'link': link
  };

}