import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/widgets/TranslatedText.dart';
import 'package:animeone/ui/widgets/flat_button.dart';
import 'package:flutter/material.dart';

String _locMeta(String text, AppLocalizations l) {
  return text
      .replaceAll('連載中', l.airing)
      .replaceAll('劇場版', l.movie)
      .replaceAll('OVA', l.ova)
      .replaceAll('OAD', l.oad)
      .replaceAll('冬季', l.winter)
      .replaceAll('春季', l.spring)
      .replaceAll('夏季', l.summer)
      .replaceAll('秋季', l.autumn)
      .replaceAll('冬', l.winter)
      .replaceAll('春', l.spring)
      .replaceAll('夏', l.summer)
      .replaceAll('秋', l.autumn);
}

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
              child: TranslatedText(
                originalText: info.name ?? AppLocalizations.of(context)!.unknownName,
                maxLines: 1,
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
                  child: Text(_locMeta(info.episode ?? "77", AppLocalizations.of(context)!), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                ),
                // Cyperpunk?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    _locMeta((info.year ?? "2077") + (info.season ?? ""), AppLocalizations.of(context)!),
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
