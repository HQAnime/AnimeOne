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
          GlobalData().sendEmail(message);
        },
        child: Text('發送報告'),
      )
    );
  }
}
