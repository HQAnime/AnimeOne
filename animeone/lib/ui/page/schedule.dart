import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/ui/component/AnimeScheduleTile.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/page/video.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule>
    with SingleTickerProviderStateMixin {
  final global = GlobalData();
  String? link;
  AnimeVideo? video;
  late List<AnimeSchedule> schedules;

  TabController? controller;
  final List<Tab> tabs = <Tab>[
    const Tab(text: '一'),
    const Tab(text: '二'),
    const Tab(text: '三'),
    const Tab(text: '四'),
    const Tab(text: '五'),
    const Tab(text: '六'),
    const Tab(text: '日'),
  ];

  @override
  void initState() {
    super.initState();

    int weekday = DateTime.now().weekday - 1;
    controller = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: weekday,
    );

    setState(() {
      schedules = global.getScheduleList();
      video = global.getIntroVideo();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: TabBar(
            controller: controller,
            tabs: tabs,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Anime(link: global.getSeasonLink(), seasonal: true),
                    ),
                  );
                },
                child: Text(
                  global.getSeasonName(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              tooltip: '新番介紹視頻',
              onPressed: () {
                if (video != null) {
                  // this.video.launchURL();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Video(video: video),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('AnimeOne'),
                        content: const Text('沒有發現介紹視頻'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('這樣啊'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
            )
          ]),
      body: renderBody(),
    );
  }

  /// Render body depending on whether there are data
  Widget renderBody() {
    if (schedules.isNotEmpty) {
      return TabBarView(
        controller: controller,
        children: renderSchedule(),
      );
    } else {
      return const Center(
        child: Text('數據還沒有更新 (´;ω;`)'),
      );
    }
  }

  /// Render schedule to different days
  List<Widget> renderSchedule() {
    List<Widget> children = [];
    for (int i = 0; i < tabs.length; i++) {
      final list = schedules.where((s) => s.weekday == i);
      children.add(SafeArea(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (c, i) {
            final item = list.elementAt(i);
            return AnimeScheduleTile(schedule: item);
          },
        ),
      ));
    }

    return children;
  }
}
