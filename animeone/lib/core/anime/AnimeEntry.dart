import 'dart:developer';

import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:html/dom.dart';

/// This class saves anime name, anime page link, anime video link,  post date, all episodes and next episode
class AnimeEntry extends AnimeBasic {
  String? postDate;
  String? allEpisodes;
  String? nextEpisode;
  AnimeVideo? videoLink;

  AnimeEntry(Element e) : super.fromJson(null) {
    try {
      // There are rare occasions where you need to enter password
      Node title = e.getElementsByClassName('entry-title')[0].nodes[0];
      name = title.text;
      if (title is Element) {
        link = title.attributes['href'];
      } else {
        var links = e.getElementsByClassName('entry-title')[0].getElementsByTagName('a');
        if (links.isNotEmpty) link = links[0].attributes['href'];
      }

      Node post = e.getElementsByClassName('entry-date')[0];
      postDate = post.text;

      // Get iframe instead
      var iframe = e.getElementsByTagName('iframe');
      if (iframe.isNotEmpty) {
        // There are exceptions where iframe is not used
        Element video = iframe[0];
        videoLink = AnimeVideo(video.attributes['src']);
      } else {
        // Get loadView button
        var loadBtn = e.getElementsByClassName('loadvideo');
        if (loadBtn.isNotEmpty) {
          Element btn = loadBtn[0];
          videoLink = AnimeVideo(btn.attributes['data-src']);
        } else {
          // See if it needs passwords
          var password = e.getElementsByClassName('acpwd-container');
          if (password.isNotEmpty) {
            // Use need to enter some password
          } else {
            // Check if it is a YouTube preview
            final youtube = e.getElementsByClassName('youtubePlayer');
            if (youtube.isNotEmpty) {
              final element = youtube[0];
              final link = GlobalData().getYouTubeLink(
                element.attributes['data-vid'],
              );
              videoLink = AnimeVideo(link);
            } else {
              // find the video tag and get data-apireq from it
              final videoTags = e.getElementsByTagName('video');
              if (videoTags.isNotEmpty) {
                final element = videoTags[0];
                final link = element.attributes['data-apireq'];
                videoLink = AnimeVideo(link);
              } else {
                // this is probably something new again
              }
            }
          }
        }
      }

      // Episode links
      e.getElementsByTagName('a').forEach((n) {
        final href = n.attributes['href'];
        if (href != null) {
          final episodeLink = GlobalData.domain + href;
          if (n.text.contains('全集')) {
            // Get all episode link
            allEpisodes = episodeLink;
          } else if (n.text.contains('下一集')) {
            // Get next episode link
            nextEpisode = episodeLink;
          }
        }
      });
    } catch (e) {
      throw Exception('AnimeEntry - Format changed\n${e.toString()}');
    }
  }

  /// Date + how many days ago
  String getEnhancedDate(AppLocalizations l) {
    String enhanced = '';
    final postDateString = postDate;
    if (postDateString != null) {
      final date = DateTime.parse(postDateString);
      int dayDiff = date.difference(DateTime.now()).inDays.abs();
      log(dayDiff.toString());

      if (dayDiff == 0) {
        enhanced = l.today;
      } else if (dayDiff == 1) {
        enhanced = l.yesterday;
      } else if (dayDiff < 7) {
        enhanced = l.daysAgo(dayDiff.toString());
      } else if (dayDiff < 28) {
        enhanced = l.weeksAgo((dayDiff / 7).round().toString());
      } else if (dayDiff < 365) {
        enhanced = l.monthsAgo((dayDiff / 30).toStringAsFixed(1));
      } else {
        enhanced = l.yearsAgo((dayDiff / 365).toStringAsFixed(1));
      }

      return '${postDate!} | $enhanced';
    } else {
      return l.unknown;
    }
  }

  /// If next episode is avaible
  bool hasNextEpisode() {
    if (nextEpisode != null) {
      return !nextEpisode!.endsWith('/?p=');
    } else {
      return false;
    }
  }

  /// In certain regions, password is needed due to copyright protection
  bool needPassword() {
    return videoLink == null;
  }

  AnimeVideo? getVideo() => videoLink;
}
