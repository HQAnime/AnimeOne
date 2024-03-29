import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/ui/component/AnimeButton.dart';
import 'package:flutter/material.dart';

class AnimeScheduleTile extends StatelessWidget {
  AnimeScheduleTile({
    Key? key,
    required this.schedule,
  }) : super(key: key);

  final AnimeSchedule schedule;
  final GlobalData global = new GlobalData();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: new AnimeButton(basic: schedule),
        ),
        IconButton(
          tooltip: '使用維基百科搜索 動畫' + (schedule.name ?? ' ??'),
          icon: Icon(Icons.info_outline),
          onPressed: () => global.getWikipediaLink(schedule.name),
        )
      ],
    );
  }
}
