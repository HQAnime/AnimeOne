import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/ui/component/AnimeRecentTile.dart';
import 'package:animeone/ui/component/ErrorButton.dart';
import 'package:animeone/ui/page/support.dart';
import 'package:flutter/material.dart';

class Latest extends StatefulWidget {
  const Latest({Key? key}) : super(key: key);

  @override
  State<Latest> createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  bool loading = false;
  List<AnimeRecent> list = [];
  final global = GlobalData();

  @override
  void initState() {
    super.initState();
    setState(() {
      list = global.getRecentList();
    });
  }

  /// Load or refresh latest anime
  void loadRecentAnime() {
    // Reset to loading
    setState(() {
      loading = true;
    });

    global.getRecentAnime().then((d) {
      setState(() {
        list = global.getRecentList();
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('最新動畫'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新最新動畫',
            onPressed: () => loadRecentAnime(),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.favorite),
          tooltip: '支持發開',
          onPressed: () {
            // Push to support page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Support(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: renderBody(),
      ),
    );
  }

  Widget renderBody() {
    if (loading) {
      return const CircularProgressIndicator();
    } else if (list.isEmpty) {
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
}
