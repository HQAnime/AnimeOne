import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// This class has Github app version and its download link
class GithubUpdate {

  String version;
  String link;
  String whatsnew;

  GithubUpdate.fromJson(Map<String, dynamic> json) : 
    version = json['version'],
    link = json['link'],
    whatsnew = json['new'];

  Map<String, dynamic> toJson() =>
  {
    'version': version,
    'link': link,
    'new': whatsnew
  };

  /// Check if version is current and launch the link if so
  void checkUpdate(BuildContext context) {
    // Only Android devices can download new apk
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    String extraInfo = '';
    if (!isAndroid) extraInfo = '\n請重新編譯APP';

    if (version.compareTo(GlobalData.version) > 0) {
      showDialog(
        context: context,
        // Prevent accidental dismiss
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('v$version'),
            content: Text(whatsnew + extraInfo),
            actions: <Widget>[
              FlatButton(
                child: Text('關閉'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // Render nothing for non-android devices
              isAndroid ? FlatButton(
                child: Text('立即下載'),
                onPressed: () {
                  launch(link);
                  Navigator.of(context).pop();
                },
              ) : SizedBox.shrink(),
            ],
          );
        },
      );
    }
  }

}