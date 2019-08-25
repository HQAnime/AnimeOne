import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatelessWidget {

  final AnimeInfo info;

  AnimeInfoCard({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(info.name),
    );
  }
}
