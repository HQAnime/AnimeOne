import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';

/// EmailButton class
class EmailButton extends StatelessWidget {
  final String message;
  EmailButton({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.618,
      child: RaisedButton(
        color: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
        onPressed: () {
          // Just to make sure the user doesn't send multiple emails
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('關於發送報告'),
                content: Text('請不要重複發送多個報告！'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('發送郵件📧'),
                    onPressed: () => GlobalData().sendEmail(message),
                  ),
                  FlatButton(
                    child: Text('取消❌'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              );
            }
          );
          
        },
        child: Text('發送報告'),
      )
    );
  }
}
