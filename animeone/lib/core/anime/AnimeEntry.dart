import 'package:html/dom.dart';

/// This class saves anime name, anime page link, anime video link,  post date, all episodes and next episode
class AnimeEntry {

  String name;
  String link;
  String postDate;
  String videoLink;
  String allEpisodes;
  String nextEpisode;

  AnimeEntry(Element e) {
    try {  
      Node title = e.getElementsByClassName('entry-title')[0].nodes[0];
      this.name = title.text;
      this.link = title.attributes['href'];

      Node post = e.getElementsByClassName('entry-date')[0];
      this.postDate = post.text;

      Node content = e.getElementsByClassName('entry-content')[0];
      Node video = content.nodes[0].nodes[0];
      this.videoLink = video.attributes['src'];

      // Episode links
      Node episode = content.nodes[1];
      episode.nodes.forEach((n) {
        if (n.text.contains('全集')) {
          // Get all episode link
          this.allEpisodes = n.attributes['href'];
        } else if (n.text.contains('下一集')) {
          // Get next episode link
          this.nextEpisode = n.attributes['href'];
        }
      });
    } catch (e) {
      throw new Exception('AnimeEntry - Format changed\n${e.toString()}');
    }
  }

  /// If next episode is avaible
  bool hasNextEpisode() {
    return this.nextEpisode == '/?p=' ? false : true;
  }

}