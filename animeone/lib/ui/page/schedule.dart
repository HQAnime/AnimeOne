import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/ui/component/AnimeScheduleTile.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/page/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  
  Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
  
}

class _ScheduleState extends State<Schedule> with SingleTickerProviderStateMixin {

  final global = new GlobalData();
  String link;
  AnimeVideo video;
  List<AnimeSchedule> schedules;

  TabController controller;
  final List<Tab> tabs = <Tab>[
    Tab(text: '一'),
    Tab(text: '二'),
    Tab(text: '三'),
    Tab(text: '四'),
    Tab(text: '五'),
    Tab(text: '六'),
    Tab(text: '日'),
  ];

  @override
  void initState() {
    super.initState();

    int weekday = DateTime.now().weekday - 1;
    this.controller = TabController(vsync: this, length: tabs.length, initialIndex: weekday);

    setState(() {
      this.schedules = this.global.getScheduleList();
      this.video = this.global.getIntroVideo();
    });
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: controller,
          tabs: tabs
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: FractionallySizedBox(
            widthFactor: 0.618,
            child: MaterialButton(
              color: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Anime(link: global.getSeasonLink(), seasonal: true)
                ));
              },
              child: Text(
                global.getSeasonName(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.play_circle_outline),
            tooltip: '新番介紹視頻',
            onPressed: () {
              if (this.video != null) {
                // this.video.launchURL();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Video(video: this.video)
                ));
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('AnimeOne'),
                      content: Text('沒有發現介紹視頻'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('這樣啊'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                );
              }
            },
          )
        ]
      ),
      body: this.renderBody(),
    );
  }

  /// Render body depending on whether there are data
  Widget renderBody() {
    if (this.schedules.length > 0) {
      return TabBarView(
        controller: controller,
        children: this.renderSchedule()
      );
    } else {
      return Center(
        child: Text('竟然沒有數據 (´;ω;`)'),
      );
    }
  }

  /// Render schedule to different days
  List<Widget> renderSchedule() {
    List<Widget> children = [];
    for (int i = 0; i < this.tabs.length; i++) {
      final list = this.schedules.where((s) => s.weekday == i);
      children.add(
        SafeArea(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (c, i) {
              final item = list.elementAt(i);
              return AnimeScheduleTile(schedule: item);
            },
          ),
        )
      );
    }

    return children;
  }

}