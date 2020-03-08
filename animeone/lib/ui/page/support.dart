import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Support class
class Support extends StatelessWidget {

  Support({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('支持AnimeOne'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('PayPal'),
            subtitle: Text('短期或一次性'),
            onTap: () => launch('https://www.paypal.me/yihengquan'),
          ),
          ListTile(
            title: Text('Patreon'),
            subtitle: Text('長期且穩定'),
            onTap: () => launch('https://patreon.com/HenryQuan'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('非常感謝您的支持！'),
          )
        ],
      )
    );
  }

}
