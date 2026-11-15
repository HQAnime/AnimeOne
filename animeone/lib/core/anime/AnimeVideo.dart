import 'dart:math';

import 'package:url_launcher/url_launcher_string.dart';

/// This class save the video link and randomly choose one of the cover images
class AnimeVideo {
  final String? video;
  int? image;

  /// Cover images bundled under `lib/assets/cover`.
  static const _covers = [3, 4, 5, 6, 7, 8, 9];

  /// Asset used when the cover number is unknown or cannot be loaded.
  static const fallbackCover = 'lib/assets/cover/3.jpg';

  static int randomCover() => _covers[Random().nextInt(_covers.length)];

  static bool hasCover(int? image) => image != null && _covers.contains(image);

  static String coverAsset(int? image) =>
      hasCover(image) ? 'lib/assets/cover/$image.jpg' : fallbackCover;

  AnimeVideo(this.video) {
    image = randomCover();
  }

  AnimeVideo.fromJson(Map<String, dynamic> json)
      : video = json['video'],
        image = _coverFromJson(json['image']);

  /// Keep a cached cover only when it points at a bundled asset; otherwise an
  /// old/corrupt value would request a missing image ("Asset not found").
  static int _coverFromJson(dynamic value) {
    final parsed = value is int ? value : int.tryParse('$value');
    if (parsed != null && _covers.contains(parsed)) return parsed;
    return randomCover();
  }

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
  bool isYoutube() => video?.contains('youtube') == true;
}
