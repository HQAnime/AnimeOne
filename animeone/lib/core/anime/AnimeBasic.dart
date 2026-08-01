import 'package:animeone/core/translation/TranslationCache.dart';

/// A basic anime class that has a name and link
abstract class AnimeBasic {
  String? name;
  String? link;

  /// Check if name contains t
  bool contains(String t) {
    final tL = t.toLowerCase();
    final n = name;
    if (n == null) {
      return false;
    }
    final nL = n.toLowerCase();
    if (nL.contains(tL)) return true;
    final translated = TranslationCache.get(n);
    return translated != null && translated.toLowerCase().contains(tL);
  }

  AnimeBasic.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    name = json['name'];
    link = json['link'];
  }

  /// Check if name is loaded and not null
  bool valid() {
    final n = name;
    return n != null && n.trim().isNotEmpty;
  }

  /// Move episode number in front ([12] xxxx)
  String? formattedName() {
    final n = name;
    if (n == null) {
      return null;
    } else if (n.endsWith(']')) {
      var group = n.split(' ');
      String tag = group.removeLast();
      String rest = group.join(' ');
      String last = '$tag $rest';

      // Double check the tag is in front now
      if (last.startsWith('[')) return last;
      return n;
    } else {
      return n;
    }
  }
}
