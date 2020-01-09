import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorButton extends StatelessWidget {

  final String msg;
  ErrorButton({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.render();
  }

  Widget render() {
    if (GlobalData.needCookie) {
      // Navigator.push(context, route);
    }

    String finalMsg = '讀取竟然失敗了...\n' + this.msg;
    return Center(
      child: Text(finalMsg, textAlign: TextAlign.center),
    );
  }
  
}
