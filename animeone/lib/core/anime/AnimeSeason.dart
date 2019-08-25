import 'package:animeone/core/GlobalData.dart';

/// This class asks for DateTime to get a string to indicate seasonal anime
class AnimeSeason {

  DateTime _date;
  final _seasons = ['冬季', '春季', '夏季', '秋季'];
  
  AnimeSeason(DateTime date) {
    this._date = date;
  }

  String getLink() {
    return '${GlobalData.domain}$this';
  }

  @override
  String toString() {
    int year = this._date.year;
    int month = this._date.month;

    int season;
    if (month < 4) season = 0;
    else if (month < 7) season = 1;
    else if (month < 10) season = 2;
    else season = 3;

    return '${year}年${this._seasons[season]}新番';
  }

}