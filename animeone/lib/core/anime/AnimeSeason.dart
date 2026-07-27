import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';

/// This class asks for DateTime to get a string to indicate seasonal anime
class AnimeSeason {
  late DateTime _date;

  AnimeSeason(DateTime date) {
    _date = date;
  }

  String getLink() {
    return '${GlobalData.domain}$this';
  }

  /// Link for Anime page to use
  String getAnimeLink() {
    return '${GlobalData.domain}category/$this'.replaceFirst('新番', '');
  }

  List<String> getSeasons(AppLocalizations l) {
    return [l.winter, l.spring, l.summer, l.autumn];
  }

  static const _cnSeasonChars = ['冬', '春', '夏', '秋'];
  static const _cnTypeValues = ['連載中', '劇場版', 'OVA', 'OAD'];

  /// some preset filters
  List<({String label, String value})> getQuickFilters(AppLocalizations l) {
    final seasons = getSeasons(l);
    return [
      (label: l.airing, value: _cnTypeValues[0]),
      (label: l.movie, value: _cnTypeValues[1]),
      (label: l.ova, value: _cnTypeValues[2]),
      (label: l.oad, value: _cnTypeValues[3]),
      for (int i = 0, offset = 0; i < 4; i++, offset -= 3)
        _seasonFilter(l, seasons, offset),
    ];
  }

  ({String label, String value}) _seasonFilter(
      AppLocalizations l, List<String> seasons, int offset) {
    var temp = _getYearAndSeason(_date.add(Duration(days: offset * 30)));
    return (
      label: '${temp[0]} ${seasons[temp[1]]}',
      value: '${temp[0]}${_cnSeasonChars[temp[1]]}',
    );
  }

  List<int> _getYearAndSeason(DateTime dt) {
    int year = dt.year;
    int month = dt.month;

    int season;
    if (month < 4) {
      season = 0;
    } else if (month < 7) {
      season = 1;
    } else if (month < 10) {
      season = 2;
    } else {
      season = 3;
    }

    return [year, season];
  }

  String getLocalizedName(AppLocalizations l) {
    var yas = _getYearAndSeason(_date);
    return l.seasonFormat('${yas[0]}', getSeasons(l)[yas[1]]);
  }

  @override
  String toString() {
    var yas = _getYearAndSeason(_date);
    return '${yas[0]}年${['冬季', '春季', '夏季', '秋季'][yas[1]]}新番';
  }
}
