import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/ui/component/AnimeInfoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Latest extends StatefulWidget {

  Latest({Key key}) : super(key: key);

  @override
  _LatestState createState() => _LatestState();
  
}

class _LatestState extends State<Latest> with AutomaticKeepAliveClientMixin {

  static GlobalData global = new GlobalData();
  List<AnimeInfo> list;
  final hundred = global.getAnimeList().take(100).toList();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._resetList();
  }

  /// Reset list to only 100 items
  void _resetList() {
    setState(() {
      this.list = this.hundred;
    });
  }

  /// Filter list by string
  void _filterList(String t) {
    // At least two characters
    if (t == '') this._resetList();
    else if (t.length > 1) {
      setState(() {
        this.list = global.getAnimeList().where((e) {
          return e.contains(t);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.search),
            ),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 17),
                decoration: InputDecoration.collapsed(
                  hintText: '快速搜尋',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 17),
                ),
                autocorrect: false,
                autofocus: false,
                onChanged: (t) => this._filterList(t),
              ),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: "關於AnimeOne",
            onPressed: () {
              // Go to information page
            },
          ),
        ],
      ),
      body: Container(
        child: this.renderBody(),
      )
    );
  }

  /// render body and deal with 0 result
  Widget renderBody() {
    if (this.list.length == 0) {
      return Center(
        child: Text('找不到任何東西 (´;ω;`)'),
      );
    } else {
      return ListView.builder(
        itemCount: this.list.length,
        itemBuilder: (context, index) {
          return AnimeInfoCard(info: this.list[index], index: index);
        },
      );
    }
  }

}