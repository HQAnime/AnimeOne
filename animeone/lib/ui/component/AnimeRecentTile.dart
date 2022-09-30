import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/ui/component/AnimeButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimeRecentTile extends StatelessWidget {
  AnimeRecentTile({
    Key? key,
    required this.recent,
  }) : super(key: key);

  final AnimeRecent recent;
  final GlobalData global = GlobalData();

  @override
  Widget build(BuildContext context) {
    return AnimeButton(
      basic: recent,
      recent: true,
    );
  }
}
