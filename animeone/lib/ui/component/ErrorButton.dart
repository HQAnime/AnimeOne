import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorButton extends StatelessWidget {

  final String msg;
  ErrorButton({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String finalMsg = '404 無法加載\n';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(finalMsg, textAlign: TextAlign.center),
          this.renderFixButton(context)
        ],
      ),
    );
  }

  Widget renderFixButton(BuildContext context) {
    if (GlobalData.requestCookieLink != '') {
      // Get cookie
      return MaterialButton(
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => CookiePage()));
        },
        child: Text('一鍵修復'),
      );
    } else {
      return SizedBox.shrink();
    }
  }

}
