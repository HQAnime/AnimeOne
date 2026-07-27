import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Support class
class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.supportAnimeOne),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('PayPal'),
            subtitle: Text(l.paypalSubtitle),
            onTap: () => launchUrlString('https://www.paypal.me/yihengquan'),
          ),
          ListTile(
            title: const Text('Patreon'),
            subtitle: Text(l.patreonSubtitle),
            onTap: () => launchUrlString('https://patreon.com/HenryQuan'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(l.thankYou),
          )
        ],
      ),
    );
  }
}
