import 'package:animeone/core/anime/AnimeInfo.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Takes an AnimeInfo object and render it to a card
class AnimeInfoCard extends StatelessWidget {
  AnimeInfoCard({
    Key? key,
    required this.info,
    required this.index,
  }) : super(key: key);

  final AnimeInfo info;
  final int index;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final first = isDark ? Colors.grey[900] : Colors.white;
    final second = isDark ? Colors.grey[800] : Colors.grey[200];

    // TODO: A temp fix to the wrong text colour, it was working properly, themedata is somehow different now
    final textStyle = TextStyle(color: isDark ? Colors.white : Colors.black);

    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          index % 2 == 0 ? first : second,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Anime(link: this.info.link),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(info.name ?? "賽博朋克",
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
                      .merge(textStyle)),
            ),
            Table(children: [
              TableRow(children: [
                Text(info.episode ?? "77",
                    textAlign: TextAlign.center, style: textStyle),
                // Cyperpunk?
                Text((info.year ?? "2077") + (info.season ?? ""),
                    textAlign: TextAlign.center, style: textStyle),
                Text(info.subtitle ?? "",
                    textAlign: TextAlign.center, maxLines: 1, style: textStyle),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}
