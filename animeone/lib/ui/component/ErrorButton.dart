import 'package:animeone/core/AnimeOne.dart';
import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ErrorButton extends StatelessWidget {
  ErrorButton({
    super.key,
    this.msg,
  });

  final String? msg;
  final global = GlobalData();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    String finalMsg = '${l.error404}\n\n${msg ?? ''}';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(finalMsg, textAlign: TextAlign.center),
          renderFixButton(context),
        ],
      ),
    );
  }

  Widget renderFixButton(BuildContext context) {
    if (GlobalData.requestCookieLink?.isNotEmpty ?? false) {
      return ElevatedButton(
        onPressed: () {
          final one = AnimeOne();
          one.bypassWebsiteCheck(context);
        },
        child: Text(AppLocalizations.of(context)!.autoFix),
      );
    } else {
      return Container();
    }
  }
}
