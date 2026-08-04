import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeSchedule.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/component/AnimeButton.dart';
import 'package:flutter/material.dart';

class AnimeScheduleTile extends StatelessWidget {
  AnimeScheduleTile({
    super.key,
    required this.schedule,
  });

  final AnimeSchedule schedule;
  final GlobalData global = GlobalData();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: AnimeButton(basic: schedule),
          ),
        ),
        IconButton(
          tooltip: AppLocalizations.of(context)!
              .wikipediaSearchAnime(schedule.name ?? '??'),
          icon: const Icon(Icons.info_outline),
          onPressed: () => global.getWikipediaLink(schedule.name),
        )
      ],
    );
  }
}
