import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimeScheduleTile extends StatelessWidget {
  
  final AnimeSchedule schedule;
  final GlobalData global = new GlobalData();

  AnimeScheduleTile({Key key, @required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 48,
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Anime(link: schedule.link)));
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    schedule.name, 
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: '使用維基百科',
          icon: Icon(Icons.info_outline),
          onPressed: () => global.getWikipediaLink(schedule.name),
        )
      ],
    );
  }
  
}