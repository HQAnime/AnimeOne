import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/component/AnimeScheduleTile.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/page/desktop_player.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

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

  List<Tab> tabs(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return <Tab>[
      Tab(text: l.dayMon),
      Tab(text: l.dayTue),
      Tab(text: l.dayWed),
      Tab(text: l.dayThu),
      Tab(text: l.dayFri),
      Tab(text: l.daySat),
      Tab(text: l.daySun),
    ];
  }

  @override
  void initState() {
    super.initState();

    int weekday = DateTime.now().weekday - 1;
    controller = TabController(
      vsync: this,
      length: 7,
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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
          bottom: TabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: tabs(context),
            labelColor: Theme.of(context).colorScheme.onSurface,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            indicatorColor: Theme.of(context).colorScheme.onSurface,
            indicatorWeight: 3,
            indicatorPadding: EdgeInsets.zero,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Anime(link: global.getSeasonLink(), seasonal: true),
                    ),
                  );
                },
                child: GlassContainer(
                  quality: GlassQuality.minimal,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const LiquidRoundedRectangle(borderRadius: 20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      global.getSeasonName(AppLocalizations.of(context)!),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              tooltip: AppLocalizations.of(context)!.introVideo,
              onPressed: () async {
                final l = AppLocalizations.of(context)!;
                if (video != null) {
                  String? url;
                  Map<String, String> headers = {
                    'referer': 'https://anime1.me/',
                    'user-agent': GlobalData().getUserAgent(),
                  };
                  final v = video;
                  final videoUrl = v?.video;
                  if (v != null && v.hasToken == true && videoUrl != null) {
                    final parser = VideoSourceParser();
                    final result = await parser.resolve(videoUrl);
                    url = result.url;
                    final cookie = result.cookie;
                    headers['Cookie'] = cookie == null
                        ? GlobalData().getCookie()
                        : '${GlobalData().getCookie()}; $cookie';
                  } else {
                    url =
                        videoUrl?.startsWith('http') == true ? videoUrl : null;
                    headers['Cookie'] = GlobalData().getCookie();
                  }
                  if (url != null && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DesktopPlayer(
                          url: url!,
                          headers: headers,
                          episodeLink: video?.video,
                          episodeName: l.introVideo,
                        ),
                      ),
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l.appTitle),
                        content: Text(l.noIntroVideo),
                        actions: <Widget>[
                          TextButton(
                            child: Text(l.iSee),
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
      body: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: renderBody(),
      ),
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
      return Center(
        child: Text(AppLocalizations.of(context)!.dataNotUpdated),
      );
    }
  }

  /// Render schedule to different days
  List<Widget> renderSchedule() {
    List<Widget> children = [];
    for (int i = 0; i < 7; i++) {
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
