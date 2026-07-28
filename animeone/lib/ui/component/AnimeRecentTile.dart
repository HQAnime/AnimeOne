import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/ui/component/AnimeButton.dart';
import 'package:flutter/material.dart';

class AnimeRecentTile extends StatelessWidget {
  AnimeRecentTile({
    super.key,
    required this.recent,
    this.autofocus = false,
  });

  final AnimeRecent recent;
  final bool autofocus;
  final GlobalData global = GlobalData();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: GlobalData.historyNotifier,
      builder: (context, _, __) {
        final entry = recent.link != null ? global.getWatchEntry(recent.link!) : null;
        return Row(
      children: [
        Expanded(
          child: AnimeButton(
            basic: recent,
            recent: true,
            autofocus: autofocus,
            translate: true,
          ),
        ),
        if (entry != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: entry.done
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : Text(
                    '${(entry.progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
                  ),
          ),
      ],
        );
      },
    );
  }
}
