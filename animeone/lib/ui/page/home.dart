import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool loading = true;

  /// Title of those widgets
  final tabTitles = ["最新動畫", "搜索動畫", new GlobalData().getSeason()];
  /// There are 3 widgets
  final tabWidgets = <Widget>[
    Text('0'),
    Text('1'),
    Text('2'),
  ];

  @override
  void initState() {
    super.initState();
    new GlobalData().init().then((_) {
      this.setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.loading) return Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: Text(tabTitles[selectedIndex]),
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
      body: Center(
        child: tabWidgets.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            title: Text('最新'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('搜索'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            title: Text('時間表'),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

  /// Switch tabs
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
