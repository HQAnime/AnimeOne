import 'package:animeone/core/AnimeOne.dart';
import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorButton extends StatelessWidget {

  final String? msg;
  final global = new GlobalData();
  ErrorButton({Key? key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String finalMsg = '404 無法加載\n';
    return Column(
      children: <Widget>[
        Text(finalMsg, textAlign: TextAlign.center),
        this.renderFixButton(),
      ],
    );
  }

  Widget renderFixButton() {
    if (GlobalData.requestCookieLink != '') {
      // Get cookie
      return MaterialButton(
        onPressed: () {
          final one = AnimeOne();
          one.getAnimeOneCookie()?.then((cookie) {
            String cookieStr = cookie;
            print(cookieStr);
            if (cookieStr.contains('__cfduid')) {
              global.updateCookie(cookieStr);
              // Ask if they want to try and fix it
              one.restartApp();
            }
          });
        },
        child: Text('啓動自動修復程序'),
      );
    } else {
      return SizedBox.shrink();
    }
  }

}
