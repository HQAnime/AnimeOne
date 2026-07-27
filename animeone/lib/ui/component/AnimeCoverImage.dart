import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:animeone/ui/page/desktop_player.dart';
import 'package:flutter/material.dart';

/// Takes an AnimeVideo object and render it to an Image
class AnimeCoverImage extends StatelessWidget {
  const AnimeCoverImage({
    super.key,
    required this.video,
    this.pageLink,
    this.episodeName,
  });

  final AnimeVideo? video;
  final String? pageLink;
  final String? episodeName;

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
        child: Text(
          '啓動瀏覽器輸入密碼',
          style: TextStyle(
            backgroundColor: Theme.of(context).colorScheme.primary,
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
        onPressed: () async {
          // video.launchURL();
          if (video?.isYoutube() ?? false) {
            video?.launchURL();
          } else {
              String? url;
              Map<String, String> headers = {
                'referer': 'https://anime1.me/',
                'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              };
              if (video?.hasToken == true && video?.video != null) {
                final parser = VideoSourceParser();
                final result = await parser.resolve(video!.video!);
                url = result.url;
                if (result.cookie != null) headers['Cookie'] = result.cookie!;
              } else {
                url = video?.video?.startsWith('http') == true ? video!.video! : null;
              }
              if (url != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DesktopPlayer(
                      url: url!,
                      headers: headers,
                      episodeLink: pageLink,
                      episodeName: episodeName,
                    ),
                  ),
                );
              }
            }

        },
        iconSize: constraint.maxWidth / 6,
        icon: const Icon(Icons.play_circle_outline),
        color: Theme.of(context).colorScheme.secondary,
      );
    }
  }

  bool shouldEnterPassword() {
    return video == null;
  }
}
