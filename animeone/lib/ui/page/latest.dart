import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/ui/component/AnimeRecentTile.dart';
import 'package:animeone/ui/component/ErrorButton.dart';
import 'package:flutter/material.dart';

import 'cookie.dart';

class Latest extends StatefulWidget {

  Latest({Key key}) : super(key: key);

  @override
  _LatestState createState() => _LatestState();
  
}

class _LatestState extends State<Latest> {
 
  bool loading = false;
  List<AnimeRecent> list = [];
  final global = new GlobalData();

  @override
  void initState() {
    super.initState();
    setState(() {
      this.list = global.getRecentList();
    });
  }

  /// Load or refresh latest anime
  void loadRecentAnime() {
    // Reset to loading
    setState(() {
      this.loading = true;
    });

    global.getRecentAnime().then((d) {
      setState(() {
        this.list = global.getRecentList();  
        this.loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('最新動畫'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: '刷新最新動畫',
            onPressed: () => this.loadRecentAnime(),
          )
        ],
      ),
      body: Center(
        child: this.testNative(),
      )
    );

  }

  Widget renderBody() {
    if (loading) {
      return CircularProgressIndicator();
    } else if (list.length == 0) {
      // If somehow we cannot get recent anime
      return ErrorButton();
    } else {
      return SafeArea(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return AnimeRecentTile(recent: list.elementAt(index));
          },
        ),
      );
    }
  }

  Widget testNative() {
    return FlatButton(onPressed: () {
      GlobalData.nativeChannel.invokeMethod('getAnimeOneCookie').then((cookie) {
        print(cookie);
        GlobalData.nativeChannel.invokeMethod('restart');
      });
    }, child: Text('Cookie'));
  }
}