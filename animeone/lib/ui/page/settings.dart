import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/ui/page/support.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('關於AnimeOne'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Support()),
              );
            },
            title: const Text('支持開發'),
            subtitle: const Text('特別喜歡本APP的話，可以支持一下~~'),
            trailing: const Icon(Icons.favorite, color: Colors.red),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  onTap: () => launch('https://61.uy/d'),
                  title: const Text('官方Discord伺服器'),
                  subtitle: const Text('https://61.uy/d'),
                ),
                ListTile(
                  onTap: () {
                    launch('https://anime1.me/%e9%97%9c%e6%96%bc');
                  },
                  title: const Text('官方網站 - 關於'),
                  subtitle: const Text('官方網站的聯繫方式和捐款'),
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    launch('https://github.com/HenryQuan/AnimeOne');
                  },
                  title: const Text('軟件源代碼'),
                  subtitle: const Text('源代碼在GitHub上開放，歡迎Pull Request'),
                ),
                ListTile(
                  onTap: () {
                    launch(
                      'https://github.com/HenryQuan/AnimeOne/blob/master/README.md#%E9%9A%B1%E7%A7%81%E6%A2%9D%E6%AC%BE',
                    );
                  },
                  title: const Text('隱私條款'),
                  subtitle: const Text('AnimeOne不會收集用戶的任何數據'),
                ),
                ListTile(
                  title: const Text('開源許可證'),
                  subtitle: const Text('查看所有的開源許可證'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LicensePage(
                          applicationName: 'AnimeOne',
                          applicationVersion: GlobalData.version,
                          applicationLegalese: '開源許可證',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    launch(GlobalData.eminaOne);
                  },
                  title: const Text('下載  Emina One '),
                  subtitle: const Text('splitline 製作的 anime1 app'),
                ),
                ListTile(
                  onTap: () {
                    launch(GlobalData.animeGo);
                  },
                  title: const Text('下載 AnimeGo'),
                  subtitle: const Text('非官方 gogoanime app (還在開發中)'),
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    GlobalData().sendEmail('');
                  },
                  title: const Text('電子郵件'),
                  subtitle: const Text('聯係本軟件的開發者'),
                ),
                ListTile(
                  onTap: () {
                    Share.share(GlobalData.latestRelease);
                  },
                  title: const Text('分享軟件'),
                  subtitle: const Text('喜歡本APP的話，可以分享給朋友們'),
                ),
                ListTile(
                  title: const Text('軟件更新'),
                  subtitle: const Text(GlobalData.version),
                  onTap: () {
                    GlobalData().checkGithubUpdate().then((_) {
                      GlobalData()
                          .getGithubUpdate()
                          ?.checkUpdate(context, showAlertWhenNoUpdate: true);
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
