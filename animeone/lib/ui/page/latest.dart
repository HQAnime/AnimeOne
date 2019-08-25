import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/ui/component/AnimeInfoCard.dart';
import 'package:flutter/cupertino.dart';

class Latest extends StatelessWidget {
  
  final GlobalData global = new GlobalData();
  final int count = 100;

  @override
  Widget build(BuildContext context) {
    final list = global.getAnimeList().take(count);
    return Container(
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return AnimeInfoCard(info: list.elementAt(index));
        },
      ),
    );
  }

}