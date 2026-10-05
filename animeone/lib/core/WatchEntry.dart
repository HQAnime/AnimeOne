class WatchEntry {
  final String episodeLink;
  final String episodeName;
  final String? animeLink;
  final String? animeName;
  int positionSec;
  int durationSec;
  bool done;
  final DateTime updatedAt;

  WatchEntry({
    required this.episodeLink,
    required this.episodeName,
    this.animeLink,
    this.animeName,
    this.positionSec = 0,
    this.durationSec = 0,
    this.done = false,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  double get progress => durationSec > 0 ? positionSec / durationSec : 0.0;

  /// Key used to group episodes that share the same main anime title.
  String get groupKey {
    final title = WatchEntry.animeTitle(animeName ?? episodeName);
    if (title != null && title.isNotEmpty) {
      return title.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
    }
    return animeLink ?? episodeLink;
  }

  /// Title to show in a grouped header.
  String get groupTitle =>
      WatchEntry.animeTitle(animeName ?? episodeName) ?? episodeName;

  static final _episodeMarker = RegExp(r'\s*第\s*\d+(\.\d+)?\s*[話话集].*$');
  static final _leadingEpisodeNumber =
      RegExp(r'^\s*[\[【(（]\s*\d+(\.\d+)?\s*[\]】)）]\s*');
  static final _trailingEpisodeNumber =
      RegExp(r'\s*[\[【(（]\s*\d+(\.\d+)?\s*[\]】)）]\s*$');

  /// Strip episode markers such as "[01]" or trailing "第1話".
  static String? animeTitle(String episodeTitle) {
    final stripped = episodeTitle
        .replaceAll(_leadingEpisodeNumber, '')
        .replaceAll(_trailingEpisodeNumber, '')
        .replaceAll(_episodeMarker, '')
        .trim();
    return stripped.isEmpty ? null : stripped;
  }

  Map<String, dynamic> toJson() => {
        'episodeLink': episodeLink,
        'episodeName': episodeName,
        'animeLink': animeLink,
        'animeName': animeName,
        'positionSec': positionSec,
        'durationSec': durationSec,
        'done': done,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory WatchEntry.fromJson(Map<String, dynamic> json) => WatchEntry(
        episodeLink: json['episodeLink'] as String,
        episodeName: json['episodeName'] as String,
        animeLink: json['animeLink'] as String?,
        animeName: json['animeName'] as String?,
        positionSec: json['positionSec'] as int? ?? 0,
        durationSec: json['durationSec'] as int? ?? 0,
        done: json['done'] as bool? ?? false,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
