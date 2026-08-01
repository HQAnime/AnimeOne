import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:animeone/l10n/app_localizations.dart';
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
      final l = AppLocalizations.of(context)!;
      return Tooltip(
        message: shouldEnterPassword() ? l.copyrightProtected : l.clickToPlay,
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
      final l = AppLocalizations.of(context)!;
      return TextButton(
        child: Text(
          l.launchBrowserForPassword,
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
      final l = AppLocalizations.of(context)!;
      return IconButton(
        tooltip: l.clickToPlay,
        onPressed: () async {
          // video.launchURL();
          if (video?.isYoutube() ?? false) {
            video?.launchURL();
          } else {
            String? url;
            Map<String, String> headers = {
              'referer': 'https://anime1.me/',
              'user-agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            };
            final v = video;
            final videoUrl = v?.video;
            if (v != null && v.hasToken == true && videoUrl != null) {
              final parser = VideoSourceParser();
              final result = await parser.resolve(videoUrl);
              url = result.url;
              final cookie = result.cookie;
              if (cookie != null) headers['Cookie'] = cookie;
            } else {
              url = videoUrl?.startsWith('http') == true ? videoUrl : null;
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
