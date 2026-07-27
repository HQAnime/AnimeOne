class WatchEntry {
  final String episodeLink;
  final String episodeName;
  int positionSec;
  int durationSec;
  bool done;
  final DateTime updatedAt;

  WatchEntry({
    required this.episodeLink,
    required this.episodeName,
    this.positionSec = 0,
    this.durationSec = 0,
    this.done = false,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  double get progress => durationSec > 0 ? positionSec / durationSec : 0.0;

  Map<String, dynamic> toJson() => {
        'episodeLink': episodeLink,
        'episodeName': episodeName,
        'positionSec': positionSec,
        'durationSec': durationSec,
        'done': done,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory WatchEntry.fromJson(Map<String, dynamic> json) => WatchEntry(
        episodeLink: json['episodeLink'] as String,
        episodeName: json['episodeName'] as String,
        positionSec: json['positionSec'] as int? ?? 0,
        durationSec: json['durationSec'] as int? ?? 0,
        done: json['done'] as bool? ?? false,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
