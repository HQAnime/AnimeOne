import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/ui/component/AnimeInfoCard.dart';
import 'package:animeone/ui/page/settings.dart';
import 'package:flutter/material.dart';

class AnimeList extends StatefulWidget {

  AnimeList({Key key}) : super(key: key);

  @override
  _AnimeListState createState() => _AnimeListState();
  
}

class _AnimeListState extends State<AnimeList> {

  static GlobalData global = new GlobalData();
  List<AnimeInfo> list;
  final all = global.getAnimeList();

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
                style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration.collapsed(
                  hintText: '快速搜尋',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
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
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) => Settings()
              ));
            },
          ),
        ],
      ),
      body: Container(
        child: this.renderBody(),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    this._resetList();
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

  /// Filter list by string
  void _filterList(String t) {
    // At least two characters
    if (t == '') this._resetList();
    else if (t.length > 1) {
      setState(() {
        this.list = this.all.where((e) {
          return e.contains(t);
        }).toList();
      });
    }
  }

  /// Reset list to only 100 items
  void _resetList() {
    setState(() {
      this.list = this.all;
    });
  }

}