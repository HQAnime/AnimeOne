import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/ui/page/support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => Support()));
            },
            title: Text('支持開發'),
            subtitle: Text('特別喜歡本APP的話，可以支持一下~~'),
            trailing: Icon(Icons.favorite, color: Colors.red),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  onTap: () => launch('https://61.uy/d'),
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
                Divider(),
                ListTile(
                  onTap: () {
                    launch('https://github.com/HenryQuan/AnimeOne');
                  },
                  title: Text('軟件源代碼'),
                  subtitle: Text('源代碼在GitHub上開放，歡迎Pull Request'),
                ),
                ListTile(
                  onTap: () {
                    launch('https://github.com/HenryQuan/AnimeOne/blob/master/README.md#%E9%9A%B1%E7%A7%81%E6%A2%9D%E6%AC%BE');
                  },
                  title: Text('隱私條款'),
                  subtitle: Text('AnimeOne不會收集用戶的任何數據'),
                ),
                ListTile(
                  title: Text('開源許可證'),
                  subtitle: Text('查看所有的開源許可證'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) => LicensePage(
                        applicationName: 'AnimeOne',
                        applicationVersion: GlobalData.version,
                        applicationLegalese: '開源許可證',
                      )
                    ));
                  },
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    launch(GlobalData.eminaOne);
                  },
                  title: Text('下載  Emina One '),
                  subtitle: Text('splitline 製作的 anime1 app'),
                ),
                ListTile(
                  onTap: () {
                    launch(GlobalData.animeGo);
                  },
                  title: Text('下載 AnimeGo'),
                  subtitle: Text('非官方 gogoanime app (還在開發中)'),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    GlobalData().sendEmail('');
                  },
                  title: Text('電子郵件'),
                  subtitle: Text('聯係本軟件的開發者'),
                ),
                ListTile(
                  onTap: () {
                    Share.share(GlobalData.latestRelease);
                  },
                  title: Text('分享軟件'),
                  subtitle: Text('喜歡本APP的話，可以分享給朋友們'),
                ),
                ListTile(
                  title: Text('軟件更新'),
                  subtitle: Text(GlobalData.version),
                  onTap: () {
                    GlobalData().checkGithubUpdate().then((_) {
                      GlobalData().getGithubUpdate()?.checkUpdate(context, showAlertWhenNoUpdate: true);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}