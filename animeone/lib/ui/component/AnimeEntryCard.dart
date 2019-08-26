import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/ui/component/AnimeCoverImage.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';

/// Takes an AnimeEntry object and render it to a card
class AnimeEntryCard extends StatelessWidget {

  final AnimeEntry entry;

  AnimeEntryCard({Key key, @required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(this.entry.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700), maxLines: 2),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(this.entry.postDate, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          ),
          AnimeCoverImage(video: this.entry.getVideo()),
          Row(
            children: <Widget>[
              this.renderAllEpisode(context),
              this.renderNextEpisode(context)
            ],
          ),
        ],
      ),
    );
  }

  Widget renderAllEpisode(BuildContext context) {
    if (this.entry.allEpisodes != null) {
      return FlatButton(
        child: Text('全集連結'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(link: this.entry.allEpisodes)));
        },
      );
    } else {
      return Text('-');
    }
  }

  Widget renderNextEpisode(BuildContext context) {
    // Check if this is the last episode
    if (this.entry.nextEpisode != null && this.entry.hasNextEpisode()) {
      return FlatButton(
        child: Text('下一集'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(link: this.entry.nextEpisode)));
        },
      );
    } else {
      return Text('-');
    }
  }

}
