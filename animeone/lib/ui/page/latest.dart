import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/core/parser/AnimeRecentParser.dart';
import 'package:animeone/ui/component/AnimeRecentTile.dart';
import 'package:flutter/material.dart';

class Latest extends StatefulWidget {

  Latest({Key key}) : super(key: key);

  @override
  _LatestState createState() => _LatestState();
  
}

class _LatestState extends State<Latest> {
 
  AnimeRecentParser parser;
  bool loading = true;
  List<AnimeRecent> list = [];

  @override
  void initState() {
    super.initState();
    this.loadRecentAnime();
  }

  /// Load or refresh latest anime
  void loadRecentAnime() {
    // Reset to loading
    setState(() {
      this.loading = true;
    });

    this.parser = new AnimeRecentParser(GlobalData.domain + '留言板');
    this.parser.downloadHTML().then((d) {
      setState(() {
        this.list = this.parser.parseHTML(d);       
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
            onPressed: () => this.loadRecentAnime(),
          )
        ],
      ),
      body: Center(
        child: this.renderBody(),
      )
    );

  }

  Widget renderBody() {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return AnimeRecentTile(recent: list.elementAt(index));
        },
      );
    }
  }

}