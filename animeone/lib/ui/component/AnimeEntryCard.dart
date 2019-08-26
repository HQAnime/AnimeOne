import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/ui/component/AnimeCoverImage.dart';
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
            child: Text(this.entry.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(this.entry.postDate, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
          ),
          AnimeCoverImage(video: this.entry.getVideo()),
          Row(
            children: <Widget>[
              this.renderEpisode(this.entry.allEpisodes, '全集連結'),
              this.entry.hasNextEpisode() ? this.renderEpisode(this.entry.nextEpisode, '下一集') : Text('-')
            ],
          ),
        ],
      ),
    );
  }

  Widget renderEpisode(String link, String text) {
    if (link != null) {
      return FlatButton(
        child: Text(text),
        onPressed: () {},
      );
    } else {
      return Text('-');
    }
  }

}
