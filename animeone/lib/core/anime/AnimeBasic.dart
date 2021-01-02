/// A basic anime class that has a name and link
abstract class AnimeBasic {
  String? name;
  String? link;

  /// Check if name contains t
  bool contains(String? t) {
    String? tL = t?.toLowerCase();
    String? nL = name?.toLowerCase();

    if (tL != null) return nL?.contains(tL) ?? false;
    return false;
  }

  AnimeBasic.fromJson(Map<String, dynamic>? json) {
    name = json?['name'];
    link = json?['link'];
  }

  /// Check if name is loaded and not null
  bool valid() => name != null && name!.trim().length > 0;

  /// Move episode number in front ([12] xxxx)
  String? formattedName() {
    if (name?.endsWith(']') ?? false) {
      var group = name!.split(' ');
      String tag = group.removeLast();
      String rest = group.join(' ');
      String last = '$tag $rest';

      // Double check the tag is in front now
      if (last.startsWith('[')) return last;
      return name;
    } else {
      return name;
    }
  }
}
