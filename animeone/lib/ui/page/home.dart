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

    // Init if not and check for update
    this.global.init().then((_) {
      final update = global.getGithubUpdate();
      if (update != null) {
        update.checkUpdate(context);
      }

      if (global.showShowAgeAlert()) {
        // Show the alert
        showDialog(
          context: context,
          // Prevent accidental dismiss
          barrierDismissible: false,
          builder: (BuildContext context) {
            // No update
            return AlertDialog(
              title: Text('關於年齡限制'),
              content: Text('最近因爲某異世界 xxx 評鑑指南的播出，雖然沒有官方的分級審核，但還是決定為 AnimeOne 增加年齡限制。本 App 至少需要 15 歲（建議18嵗）才可以使用本 App，如果你不到 15 嵗請立即刪除本 App。'),
              actions: <Widget>[
                FlatButton(
                  child: Text('好的'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Don't show this again
                    global.updateAgeAlert();
                  },
                ),
              ],
            );
          },
        );
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
                  style: Theme.of(context).textTheme.headline5,
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
                  style: Theme.of(context).textTheme.headline5,
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
                  '現在怎麽辦？',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                FlatButton(
                  child: Text('使用瀏覽器打開 anime1.me'),
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
