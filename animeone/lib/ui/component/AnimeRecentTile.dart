import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/ui/component/AnimeButton.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimeRecentTile extends StatelessWidget {
  
  final AnimeRecent recent;
  final GlobalData global = new GlobalData();

  AnimeRecentTile({Key key, @required this.recent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimeButton(recent: recent);
  }
  
}