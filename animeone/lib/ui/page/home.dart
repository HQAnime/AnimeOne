import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/ui/page/latest.dart';
import 'package:animeone/ui/page/schedule.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool loading = true;

  GlobalData global;

  final tabWidgets = <Widget>[
    Latest(),
    Schedule()
  ];

  @override
  void initState() {
    super.initState();

    this.global = new GlobalData();
    this.global.init().then((_) {
      this.setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.loading) {
      // Simply show an empty view with a loading indicator
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Load all tabs
      return Scaffold(
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
              icon: Icon(Icons.calendar_view_day),
              title: Text('時間表'),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ),
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
