import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// EmailButton class
class EmailButton extends StatelessWidget {
  const EmailButton({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return FractionallySizedBox(
      widthFactor: 0.618,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(l.loadFailedEmailTitle),
                content: Text(l.loadFailedEmailContent),
                actions: <Widget>[
                  TextButton(
                    child: Text(l.sendEmail),
                    onPressed: () => GlobalData().sendEmail(message),
                  ),
                  TextButton(
                    child: Text(l.cancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
        },
        child: Text(l.details),
      ),
    );
  }
}
