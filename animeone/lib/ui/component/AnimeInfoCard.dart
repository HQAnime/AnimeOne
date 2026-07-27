import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/widgets/flat_button.dart';
import 'package:flutter/material.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatelessWidget {
  const AnimeInfoCard({
    super.key,
    required this.info,
    required this.index,
  });

  final AnimeInfo info;
  final int index;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final first = isDark ? Colors.grey[900] : Colors.white;
    final second = isDark ? Colors.grey[800] : Colors.grey[200];

    return Material(
      color: index % 2 == 0 ? first : second,
      child: AnimeFlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Anime(link: info.link),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                info.name ?? AppLocalizations.of(context)!.unknownName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            Table(children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(info.episode ?? "77", textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                ),
                // Cyperpunk?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    (info.year ?? "2077") + (info.season ?? ""),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    info.subtitle ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}
