import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/ui/page/latest.dart';
import 'package:animeone/ui/page/list.dart';
import 'package:animeone/ui/page/schedule.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  bool loading = true;
  String error = '';

  GlobalData global;

  @override
  void initState() {
    super.initState();

    this.global = new GlobalData();
    this.global.init().then((_) {
      final update = global.getGithubUpdate();
      if (update != null) {
        update.checkUpdate(context);
      }

      setState(() {
        loading = false;
      });
    }).catchError((e) {
      setState(() {
        error = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.renderBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            title: Text('最新'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('動畫列表'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('時間表'),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

  /// Loading or index stacked
  Widget renderBody() {
    if (this.error != '') {
      return Center(
        child: Text('無法加載數據\n\n$error', textAlign: TextAlign.center)
      );
    } else if (this.loading) {
      return Center(
        child: CircularProgressIndicator()
      );
    } else {
      return IndexedStack(
        index: selectedIndex,
        children: [
          Latest(),
          AnimeList(),
          Schedule(),
        ],
      );
    }
  }

  /// Switch tabs
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
