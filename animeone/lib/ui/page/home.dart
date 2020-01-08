import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/ui/component/EmailButton.dart';
import 'package:animeone/ui/page/latest.dart';
import 'package:animeone/ui/page/list.dart';
import 'package:animeone/ui/page/schedule.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Randomly choose a tab
  int selectedIndex = 0;
  bool loading = true;
  String error = '';

  GlobalData global;

  @override
  void initState() {
    super.initState();

    this.global = new GlobalData();
    this._loadData();
  }

  void _loadData() {
    // Reset everything
    setState(() { 
      loading = true;
      error = '';
    });

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
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '無法加載數據 :(',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ),
                Text(
                  '請稍後重試，如果問題依然存在，請聯係開發者\n（也許是服務器的問題 也有可能是 APP 的問題）',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox.fromSize(size: Size.fromHeight(24)),
                Text(
                  '錯誤消息!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                SizedBox.fromSize(size: Size.fromHeight(24)),
                Text(
                  '那現在怎麽辦？',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline,
                ),
                FlatButton(
                  child: Text('使用瀏覽器打開 Anime1.me'),
                  onPressed: () => launch(GlobalData.domain),
                ),
                Text('或者',
                  style: Theme.of(context).textTheme.caption,
                ),
                FlatButton(
                  child: Text('檢查 APP 是否有更新'),
                  onPressed: () {
                    GlobalData().checkGithubUpdate().then((_) {
                      GlobalData().getGithubUpdate().checkUpdate(context, showAlertWhenNoUpdate: true);
                    });
                  },
                ),
              ],
            )
          ),
          Positioned(
            right: 16,
            top: 36,
            child: Tooltip(
              message: '重新加載數據',
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => this._loadData()
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: EmailButton(message: error),
          )
        ],
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
