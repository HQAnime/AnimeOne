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
      margin: EdgeInsets.all(4),
      child: InkWell(
        onTap: () {},
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
      ),
    );
  }
}
