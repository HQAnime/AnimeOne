import 'package:animeone/core/AnimeOne.dart';
import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';

class ErrorButton extends StatelessWidget {
  ErrorButton({
    Key? key,
    this.msg,
  }) : super(key: key);

  final String? msg;
  final global = new GlobalData();

  @override
  Widget build(BuildContext context) {
    String finalMsg = '404 無法加載\n\n${msg ?? ''}';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(finalMsg, textAlign: TextAlign.center),
          this.renderFixButton(),
        ],
      ),
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
            if (cookieStr.contains('cf_clearance')) {
              global.updateCookie(cookieStr);
              // Ask if they want to try and fix it
              one.restartApp();
            }
          });
        },
        child: Text('啓動自動修復程序'),
      );
    } else {
      return Container();
    }
  }
}
