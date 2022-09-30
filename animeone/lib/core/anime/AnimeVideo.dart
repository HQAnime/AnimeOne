import 'dart:math';

import 'package:url_launcher/url_launcher_string.dart';

/// This class save the video link and randomly choose one of the cover images
class AnimeVideo {
  final String? video;
  int? image;

  // From 3 -> 9
  final _covers = List.generate(7, (i) => i + 3);

  AnimeVideo(this.video) {
    image = _covers[Random().nextInt(6)];
  }

  AnimeVideo.fromJson(Map<String, dynamic> json)
      : video = json['video'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'video': video,
        'image': image,
      };

  void launchURL() {
    final video = this.video;
    if (video != null) launchUrlString(video);
  }

  bool? get hasToken {
    /// It is something like this
    /// %7B%22c%22%3A%221003%22%2C%22e%22%3A%222b%22%2C%22t%22%3A1642745961%2C%22p%22%3A0%2C%22s%22%3A%220f83a764869105145b69e51e475f5ab7%22%7D
    return video?.startsWith('%7B%22');
  }

  /// Check if this is a youtube link
  bool isYoutube() {
    return video != null && video!.contains('youtube');
  }
}
