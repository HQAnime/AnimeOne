import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatelessWidget {

  final AnimeInfo info;

  AnimeInfoCard({Key key, @required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Text(info.name),
            Table(
              children: [
                TableRow(
                  children: [
                    Text(info.episode, textAlign: TextAlign.center),
                    Text(info.year, textAlign: TextAlign.center),
                    Text(info.season, textAlign: TextAlign.center),
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
