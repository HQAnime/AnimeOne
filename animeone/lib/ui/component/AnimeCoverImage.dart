import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/ui/page/video.dart';
import 'package:flutter/material.dart';

/// Takes an AnimeVideo object and render it to an Image
class AnimeCoverImage extends StatelessWidget {

  final AnimeVideo video;

  AnimeCoverImage({Key key, @required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Tooltip(
          message: '點擊進入内置視頻播放器',
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FittedBox(
                    child: Image.asset('lib/assets/cover/${video.image}.jpg')
                  ),
                )
              ),
              Positioned.fill(
                child: IconButton(
                  onPressed: () {
                    // video.launchURL();
                    if (video.isYoutube()) {
                      video.launchURL();
                    } else {
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => Video(video: this.video)));
                    }
                  },
                  iconSize: constraint.maxWidth / 6,
                  icon: Icon(Icons.play_circle_outline),
                  color: Colors.pink,
                ),
              )
            ]
          ),
        );
      }
    );
  }

}
