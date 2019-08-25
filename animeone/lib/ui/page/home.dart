import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  /// Title of those widgets
  final tabTitles = ["最新動畫", "搜索動畫", "2019年夏季新番"];
  /// There are 3 widgets
  final tabWidgets = <Widget>[
    Text('0'),
    Text('1'),
    Text('2'),
  ];

  /// Switch tabs
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.new_releases),
            title: Text('最新'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('搜索'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.satellite),
            title: Text('新番'),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
