import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';

/// This a button that accepts AnimeSchedule or AnimeRecent
class AnimeButton extends StatelessWidget {

  final AnimeRecent recent;
  
  AnimeButton({Key key, @required this.recent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(link: recent.link)));
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              recent.name, 
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
            ),
          ),
        ),
      ),
    );
  }
}