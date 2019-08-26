import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/core/anime/AnimeVideo.dart';
import 'package:animeone/core/parser/AnimeScheduleParser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  
  Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
  
}

class _ScheduleState extends State<Schedule> with AutomaticKeepAliveClientMixin {

  final global = new GlobalData();
  bool loading = true;
  String link;
  AnimeVideo video;
  List<AnimeSchedule> schedules;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this.link = GlobalData.domain + global.getSeason();
    final parser = new AnimeScheduleParser(link);
    parser.downloadHTML().then((d) {
      setState(() {
        this.schedules = parser.parseHTML(d);
        this.video = parser.parseIntroductoryVideo(d);
        this.loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(global.getSeason()),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.play_circle_outline),
              tooltip: '這裏新番介紹視頻',
              onPressed: () {
                if (this.video != null) {
                  this.video.launchURL();
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
        
      );
    }
  }

}