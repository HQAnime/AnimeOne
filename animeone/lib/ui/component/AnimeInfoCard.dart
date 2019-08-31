import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatelessWidget {

  final AnimeInfo info;
  final int index;

  AnimeInfoCard({Key key, @required this.info, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color first = isDark ? Colors.grey[900] : Colors.white;
    Color second = isDark ? Colors.grey[800] : Colors.grey[200];
    return FlatButton(
      color: index % 2 == 0 ? first : second,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(link: this.info.link)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(info.name, maxLines: 1, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            Table(
              children: [
                TableRow(
                  children: [
                    Text(info.episode, textAlign: TextAlign.center),
                    Text(info.year + info.season, textAlign: TextAlign.center),
                    Text(info.subtitle, textAlign: TextAlign.center, maxLines: 1),
                  ]
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
