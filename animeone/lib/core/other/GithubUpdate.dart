import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// This class has Github app version and its download link
class GithubUpdate {
  String? version;
  String? link;
  String? whatsnew;
  final Map<String, String> localizedWhatsNew = {};

  GithubUpdate.fromJson(Map<String, dynamic> json)
      : version = json['version'],
        link = json['link'],
        whatsnew = json['new'] {
    for (final entry in json.entries) {
      if (entry.key.startsWith('new-') && entry.value is String) {
        localizedWhatsNew[entry.key.substring(4)] = entry.value as String;
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'link': link,
        'new': whatsnew,
        for (final entry in localizedWhatsNew.entries)
          'new-${entry.key}': entry.value,
      };

  /// Localised changelog for [locale], falls back to the default "new"
  String? whatsNewFor(Locale locale) =>
      localizedWhatsNew[locale.languageCode] ?? whatsnew;

  /// Check if version is current and launch the link if so
  void checkUpdate(BuildContext context, {bool showAlertWhenNoUpdate = false}) {
    final l = AppLocalizations.of(context)!;
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    String extraInfo = '';
    if (!isAndroid) extraInfo = l.recompileApp;

    if (version != GlobalData.version) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('v$version'),
            content: Text((whatsNewFor(Localizations.localeOf(context)) ?? '') + extraInfo),
            actions: <Widget>[
              TextButton(
                child: Text(l.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              isAndroid
                  ? TextButton(
                      child: Text(l.downloadNow),
                      onPressed: () {
                        final link = this.link;
                        if (link != null) launchUrl(Uri.parse(link));
                        Navigator.of(context).pop();
                      },
                    )
                  : Container(),
            ],
          );
        },
      );
    } else if (showAlertWhenNoUpdate) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('v$version'),
            content: Text(l.noUpdateFound),
            actions: <Widget>[
              TextButton(
                child: Text(l.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }
}
