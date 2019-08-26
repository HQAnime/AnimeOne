import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

/// This class save the video link and randomly choose one of the cover images
class AnimeVideo {

  String video;
  int image;

  final _covers = [5, 6, 7, 8, 9];

  AnimeVideo(String video) {
    this.video = video;
    this.image = _covers[Random().nextInt(5)];
  }

  void launchURL() {
    launch(this.video);
  }

}