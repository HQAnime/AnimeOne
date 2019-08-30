import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';

/// This a button that accepts AnimeSchedule or AnimeRecent
class AnimeButton extends StatelessWidget {

  final AnimeBasic basic;
  
  AnimeButton({Key key, @required this.basic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(link: basic.link)));
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              basic.formattedName(), 
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