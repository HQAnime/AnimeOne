import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/component/AnimeCoverImage.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/widgets/TranslatedText.dart';
import 'package:animeone/ui/widgets/flat_button.dart';
import 'package:flutter/material.dart';

/// Takes an AnimeEntry object and render it to a card
class AnimeEntryCard extends StatelessWidget {
  const AnimeEntryCard({
    super.key,
    required this.entry,
    this.showEpisode,
    this.pageUrl,
    this.progress,
  });

  final AnimeEntry entry;
  final bool? showEpisode;
  final String? pageUrl;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TranslatedText(
              originalText: entry.formattedName() ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              entry.getEnhancedDate(AppLocalizations.of(context)!) + _progressText(context),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ),
          AnimeCoverImage(
            video: entry.needPassword() ? null : entry.getVideo(),
            pageLink: entry.link ?? pageUrl,
            episodeName: entry.formattedName(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: <Widget>[
                renderAllEpisode(context),
                renderNextEpisode(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _progressText(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (progress == null || progress! <= 0) return '';
    if (progress! >= 1.0) return ' | ${l.watchComplete}';
    return l.progressFormat((progress! * 100).toStringAsFixed(0));
  }

  /// Render all episode if exists or should be shown
  Widget renderAllEpisode(BuildContext context) {
    if (showEpisode == true && entry.allEpisodes != null) {
      return AnimeFlatButton(
        child: Text(AppLocalizations.of(context)!.allEpisodes),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Anime(link: entry.allEpisodes),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  /// Render next episode if exists or should be shown
  Widget renderNextEpisode(BuildContext context) {
    // Check if this is the last episode
    if (showEpisode == true &&
        entry.nextEpisode != null &&
        entry.hasNextEpisode()) {
      return AnimeFlatButton(
        child: Text(AppLocalizations.of(context)!.nextEpisode),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Anime(link: entry.nextEpisode),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
