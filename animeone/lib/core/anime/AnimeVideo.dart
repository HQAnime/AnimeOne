import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

/// This class save the video link and randomly choose one of the cover images
class AnimeVideo {
  String? video;
  int? image;

  // From 3 -> 9
  final _covers = List.generate(7, (i) => i + 3);

  AnimeVideo(String? video) {
    this.video = video;
    this.image = _covers[Random().nextInt(5)];
  }

  AnimeVideo.fromJson(Map<String, dynamic> json)
      : video = json['video'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'video': video,
        'image': image,
      };

  void launchURL() {
    launch(this.video!);
  }

  /// Check if this is a youtube link
  bool isYoutube() {
    return video != null && video!.contains('youtube');
  }
}
