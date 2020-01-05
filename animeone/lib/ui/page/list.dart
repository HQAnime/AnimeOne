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

  // Maybe in the future
  final quickFilters = [
    '連載中', 
    '劇場版', 
    'OVA', 
    'OAD',
    '春',
    '夏',
    '秋',
    '冬',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(Icons.search, size: 32),
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
          Ink.image(
            image: AssetImage('lib/assets/icon/logo.png'),
            width: 64,
            height: 64,
            child: Tooltip(
              message: '關於AnimeOne',
              child: InkWell(
                onTap: () {
                  // Go to information page
                  Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => Settings()
                  ));
                },
                child: null,
              ),
            )
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox.fromSize(
            size: Size.fromHeight(48),
            child: this.renderQuickFilter(),
          ),
          Expanded(
            child: this.renderBody(),
          ),
        ]
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._resetList();
  }

  /// render a list of quick filter
  Widget renderQuickFilter() {
    return SafeArea(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: this.quickFilters.length,
              itemBuilder: (context, index) {
                // Get current filter
                final filter = this.quickFilters[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                  child: Tooltip(
                    message: '搜索 $filter 動畫',
                    child: ActionChip(
                      label: Text(filter), 
                      onPressed: () => this._filterList(filter),
                    ),
                  )
                );
              }
            ),
          ),
          Tooltip(
            message: '重設整個列表',
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => this._resetList(),
            ),
          )
        ],
      ),
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

  /// Filter list by string
  void _filterList(String t) {
    // At least two characters
    if (t == '') this._resetList();
    else if (t.length > 0) {
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