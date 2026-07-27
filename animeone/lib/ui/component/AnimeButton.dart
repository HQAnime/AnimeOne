import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/widgets/TranslatedText.dart';
import 'package:flutter/material.dart';

/// This a button that accepts AnimeSchedule or AnimeRecent
class AnimeButton extends StatelessWidget {
  const AnimeButton({
    super.key,
    required this.basic,
    this.recent,
    this.autofocus = false,
    this.translate = false,
  });

  final AnimeBasic basic;
  final bool? recent;
  final bool autofocus;
  final bool translate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      autofocus: autofocus,
      onTap: () {
        if (basic.link != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Anime(link: basic.link, recent: recent),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(AppLocalizations.of(context)!.noFirstEpisode, textAlign: TextAlign.center),
              );
            },
          );
        }
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TranslatedText(
            originalText: basic.formattedName() ?? AppLocalizations.of(context)!.unknownName,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            canFetch: translate,
          ),
        ),
      ),
    );
  }
}
