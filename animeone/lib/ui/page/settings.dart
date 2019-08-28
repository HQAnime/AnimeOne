import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('關於AnimeOne'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              launch('https://61.uy/d');
            },
            title: Text('官方Discord伺服器'),
            subtitle: Text('https://61.uy/d'),
          ),
          ListTile(
            onTap: () {
              launch('https://anime1.me/%e9%97%9c%e6%96%bc');
            },
            title: Text('官方網站 - 關於'),
            subtitle: Text('官方網站的聯繫方式和捐款'),
          ),
          ListTile(
            onTap: () {
              launch('mailto:development.henryquan@gmail.com?subject=[AnimeOne ${GlobalData.version}]');
            },
            title: Text('電子郵件'),
            subtitle: Text('聯係本軟件開發者'),
          ),
          ListTile(
            onTap: () {
              launch('https://61.uy/d');
            },
            title: Text('軟件源代碼'),
            subtitle: Text('https://github.com/HenryQuan/AnimeOne'),
          ),
          ListTile(
            title: Text('軟件版本'),
            subtitle: Text(GlobalData.version),
          ),
        ],
      ),
    );
  }

}