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
          renderFixButton(context),
        ],
      ),
    );
  }

  Widget renderFixButton(BuildContext context) {
    // don't show this all the time
    if (GlobalData.requestCookieLink?.isNotEmpty ?? false) {
      // Get cookie
      return ElevatedButton(
        onPressed: () {
          final one = AnimeOne();
          one.bypassWebsiteCheck(context);
        },
        child: Text('啓動自動修復程序'),
      );
    } else {
      return Container();
    }
  }
}
