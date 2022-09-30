import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/ui/page/video.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Takes an AnimeVideo object and render it to an Image
class AnimeCoverImage extends StatelessWidget {
  const AnimeCoverImage({
    Key? key,
    required this.video,
  }) : super(key: key);

  final AnimeVideo? video;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Tooltip(
        message: shouldEnterPassword() ? '因版權方要求，目前無法提供此内容。' : '點擊進入内置視頻播放器',
        child: Stack(children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FittedBox(
                child: Image.asset('lib/assets/cover/${video?.image}.jpg'),
              ),
            ),
          ),
          Positioned.fill(
            child: renderButton(context, constraint),
          ),
        ]),
      );
    });
  }

  Widget renderButton(BuildContext context, BoxConstraints constraint) {
    if (shouldEnterPassword()) {
      return TextButton(
        child: const Text(
          '啓動瀏覽器輸入密碼',
          style: TextStyle(
            backgroundColor: Colors.pink,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        onPressed: () {
          video?.launchURL();
        },
      );
    } else {
      return IconButton(
        onPressed: () {
          // video.launchURL();
          if (video?.isYoutube() ?? false) {
            video?.launchURL();
          } else {
            if (identical(0, 0.0)) {
              if (video != null && video!.video != null) launch(video!.video!);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Video(video: video),
                ),
              );
            }
          }
        },
        iconSize: constraint.maxWidth / 6,
        icon: const Icon(Icons.play_circle_outline),
        color: Colors.pink,
      );
    }
  }

  bool shouldEnterPassword() {
    return video == null;
  }
}
