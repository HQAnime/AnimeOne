import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// This class has Github app version and its download link
class GithubUpdate {
  String? version;
  String? link;
  String? whatsnew;

  GithubUpdate.fromJson(Map<String, dynamic> json)
      : version = json['version'],
        link = json['link'],
        whatsnew = json['new'];

  Map<String, dynamic> toJson() => {
        'version': version,
        'link': link,
        'new': whatsnew,
      };

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
            content: Text(whatsnew! + extraInfo),
            actions: <Widget>[
              TextButton(
                child: Text(l.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              isAndroid
                  ? TextButton(
                      child: Text(l.downloadNow),
                      onPressed: () {
                        launchUrl(Uri.parse(link!));
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
