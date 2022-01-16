import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/ui/component/AnimeCoverImage.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/widgets/flat_button.dart';
import 'package:flutter/material.dart';

/// Takes an AnimeEntry object and render it to a card
class AnimeEntryCard extends StatelessWidget {
  AnimeEntryCard({
    Key? key,
    required this.entry,
    this.showEpisode,
  }) : super(key: key);

  final AnimeEntry entry;
  final bool? showEpisode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              this.entry.formattedName() ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              this.entry.getEnhancedDate(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ),
          AnimeCoverImage(
            video: this.entry.needPassword() ? null : this.entry.getVideo(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: <Widget>[
                this.renderAllEpisode(context),
                this.renderNextEpisode(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Render all episode if exists or should be shown
  Widget renderAllEpisode(BuildContext context) {
    if (this.showEpisode == true && this.entry.allEpisodes != null) {
      return AnimeFlatButton(
        child: Text('全集連結'),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Anime(link: this.entry.allEpisodes),
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
    if (this.showEpisode == true &&
        this.entry.nextEpisode != null &&
        this.entry.hasNextEpisode()) {
      return AnimeFlatButton(
        child: Text('下一集'),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Anime(link: this.entry.nextEpisode),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
