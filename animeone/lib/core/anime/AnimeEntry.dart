import 'dart:developer';

import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
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
      this.name = title.text;
      this.link = title.attributes['href'];

      Node post = e.getElementsByClassName('entry-date')[0];
      this.postDate = post.text;

      // Get iframe instead
      var iframe = e.getElementsByTagName('iframe');
      if (iframe.length > 0) {
        // There are exceptions where iframe is not used
        Element video = iframe[0];
        this.videoLink = new AnimeVideo(video.attributes['src']);
      } else {
        // Get loadView button
        var loadBtn = e.getElementsByClassName('loadvideo');
        if (loadBtn.length > 0) {
          Element btn = loadBtn[0];
          this.videoLink = new AnimeVideo(btn.attributes['data-src']);
        } else {
          // See if it needs passwords
          var password = e.getElementsByClassName('acpwd-container');
          if (password.length > 0) {
            // Use need to enter some password
          } else {
            // It is a YouTube preview
            Element youtube = e.getElementsByClassName('youtubePlayer')[0];
            final link = GlobalData().getYouTubeLink(youtube.attributes['data-vid']!);
            this.videoLink = new AnimeVideo(link);
          }
        }
      }

      // Episode links
      e.getElementsByTagName('a').forEach((n) {
        if (n.text.contains('全集')) {
          // Get all episode link
          this.allEpisodes = GlobalData.domain + n.attributes['href']!;
        } else if (n.text.contains('下一集')) {
          // Get next episode link
          this.nextEpisode = GlobalData.domain + n.attributes['href']!;
        }
      });
    } catch (e) {
      throw new Exception('AnimeEntry - Format changed\n${e.toString()}');
    }
  }

  /// Date + how many days ago
  /// - 一天前
  /// 一周前
  /// - 一個月前
  /// - 一年之前
  String getEnhancedDate() {
    String enhanced = '';

    var date = DateTime.parse(this.postDate!);
    int dayDiff = date.difference(DateTime.now()).inDays.abs();
    log(dayDiff.toString());

    if (dayDiff == 0) {
      enhanced = '今天';
    } else if (dayDiff == 1) {
      enhanced = '昨天';
    } else if (dayDiff < 7) {
      enhanced = '$dayDiff 天前';
    } else if (dayDiff < 28) {
      enhanced = '${(dayDiff / 7).round()} 周前';
    } else if (dayDiff < 365) {
      enhanced = '${(dayDiff / 30).toStringAsFixed(1)} 個月前'; // is this a good idea??
    } else {
      enhanced = '${(dayDiff / 365).toStringAsFixed(1)} 年前';
    }

    return this.postDate! + ' | $enhanced';
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
    return this.videoLink == null;
  }

  AnimeVideo? getVideo() => this.videoLink;
}