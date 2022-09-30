import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Support class
class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支持AnimeOne'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('PayPal'),
            subtitle: const Text('短期或一次性'),
            onTap: () => launchUrlString('https://www.paypal.me/yihengquan'),
          ),
          ListTile(
            title: const Text('Patreon'),
            subtitle: const Text('長期且穩定'),
            onTap: () => launchUrlString('https://patreon.com/HenryQuan'),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('非常感謝您的支持！'),
          )
        ],
      ),
    );
  }
}
