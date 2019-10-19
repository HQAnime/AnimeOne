import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:html/dom.dart';

/// This class saves anime name, anime page link, anime video link,  post date, all episodes and next episode
class AnimeEntry extends AnimeBasic {

  String postDate;
  String allEpisodes;
  String nextEpisode;
  AnimeVideo videoLink;

  AnimeEntry(Element e) : super.fromJson(null) {
    try {  
      Node title = e.getElementsByClassName('entry-title')[0].nodes[0];
      this.name = title.text;
      this.link = title.attributes ['href'];

      Node post = e.getElementsByClassName('entry-date')[0];
      this.postDate = post.text;

      // Get iframe instead
      var iframe = e.getElementsByTagName('iframe');
      if (iframe.length > 0) {
        // There are exceptions where iframe is not used
        Element video = iframe[0];
        this.videoLink = new AnimeVideo(video.attributes['src']);
      } else {
        // It is a YouTube preview
        Element youtube = e.getElementsByClassName('youtubePlayer')[0];
        final link = GlobalData().getYouTubeLink(youtube.attributes['data-vid']);
        this.videoLink = new AnimeVideo(link);
      }

      // Episode links
      e.getElementsByTagName('a').forEach((n) {
        if (n.text.contains('全集')) {
          // Get all episode link
          this.allEpisodes = GlobalData.domain + n.attributes['href'];
        } else if (n.text.contains('下一集')) {
          // Get next episode link
          this.nextEpisode = GlobalData.domain + n.attributes['href'];
        }
      });
    } catch (e) {
      throw new Exception('AnimeEntry - Format changed\n${e.toString()}');
    }
  }

  /// If next episode is avaible
  bool hasNextEpisode() {
    return this.nextEpisode.endsWith('/?p=') ? false : true;
  }

  AnimeVideo getVideo() => this.videoLink;

}