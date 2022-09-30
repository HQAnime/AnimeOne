import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// WebsiteClosed class
class WebsiteClosed extends StatelessWidget {
  const WebsiteClosed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('lib/assets/icon/logo.png'),
              height: 200,
              width: 200,
              color: Colors.pink,
            ),
            Text('網站已關閉', style: Theme.of(context).textTheme.headline4),
            const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Text('「楓林網」遭查封'),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'AnimeOne 並不是官方的應用程式，\n這只是我個人的開源項目，\n因為網站已經關閉所以開發已終止。',
                textAlign: TextAlign.center,
              ),
            ),
            const Text('如果你喜歡英文字幕的話'),
            ElevatedButton(
              onPressed: () {
                launchUrlString(
                  'https://github.com/HenryQuan/AnimeGo-Re/releases',
                );
              },
              child: const Text('下載 AnimeGo'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: TextButton(
                onPressed: () {
                  launchUrlString('https://github.com/HenryQuan/AnimeOne');
                },
                child: const Text('https://github.com/HenryQuan/AnimeOne'),
              ),
            ),
            const Text(
              'Aug 2019 - Apr 2020',
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

//
// 永遠のAnimeOne
