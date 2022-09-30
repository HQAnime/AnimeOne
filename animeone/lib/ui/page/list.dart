import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/ui/component/AnimeInfoCard.dart';
import 'package:animeone/ui/page/settings.dart';
import 'package:flutter/material.dart';

class AnimeList extends StatefulWidget {
  const AnimeList({Key? key}) : super(key: key);

  @override
  State<AnimeList> createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  static GlobalData global = GlobalData();
  List<AnimeInfo> list = [];
  final all = global.getAnimeList();

  final quickFilters = global.getQuickFilters();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.search, size: 32),
            ),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: const InputDecoration.collapsed(
                  hintText: '快速搜尋',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
                autocorrect: false,
                autofocus: false,
                onChanged: (t) => _filterList(t),
              ),
            )
          ],
        ),
        actions: <Widget>[
          Ink.image(
            image: const AssetImage('lib/assets/icon/logo.png'),
            width: 64,
            height: 64,
            child: Tooltip(
              message: '關於AnimeOne',
              child: InkWell(
                onTap: () {
                  // Go to information page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ),
                  );
                },
                child: null,
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        SizedBox.fromSize(
          size: const Size.fromHeight(48),
          child: renderQuickFilter(),
        ),
        Expanded(
          child: renderBody(),
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    _resetList();
  }

  /// render a list of quick filter
  Widget renderQuickFilter() {
    return SafeArea(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quickFilters.length,
              itemBuilder: (context, index) {
                // Get current filter
                final filter = quickFilters[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                  child: Tooltip(
                    message: '搜索 $filter 動畫',
                    child: ActionChip(
                      label: Text(filter),
                      onPressed: () => _filterList(filter),
                    ),
                  ),
                );
              },
            ),
          ),
          Tooltip(
            message: '重設整個列表',
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _resetList(),
            ),
          )
        ],
      ),
    );
  }

  /// render body and deal with 0 result
  Widget renderBody() {
    if (list.isEmpty) {
      return const Center(
        child: Text('找不到任何東西 (´;ω;`)'),
      );
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return AnimeInfoCard(info: list[index], index: index);
        },
      );
    }
  }

  /// Filter list by string
  void _filterList(String t) {
    // At least two characters
    if (t == '') {
      _resetList();
    } else if (t.isNotEmpty) {
      setState(() {
        list = all.where((e) {
          return e.contains(t);
        }).toList();
      });
    }
  }

  /// Reset list to only 100 items
  void _resetList() {
    setState(() {
      list = all;
    });
  }
}
