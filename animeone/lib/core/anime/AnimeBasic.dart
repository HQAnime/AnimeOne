/// A basic anime class that has a name and link
abstract class AnimeBasic {
  String name;
  String link;

  /// Check if name contains t
  bool contains(String t) {
    String tL = t.toLowerCase();
    String nL = this.name.toLowerCase();
    return nL.contains(tL);
  }

  /// Check if name is loaded and not null
  bool valid() {
    return name != null && name.trim().length > 0;
  }
}