import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/WatchEntry.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/widgets/TranslatedText.dart';
import 'package:flutter/material.dart';

class WatchHistory extends StatefulWidget {
  const WatchHistory({super.key});

  @override
  State<WatchHistory> createState() => _WatchHistoryState();
}

class _WatchHistoryState extends State<WatchHistory> {
  final _global = GlobalData();
  List<WatchEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
    GlobalData.historyNotifier.addListener(_onHistoryChanged);
  }

  @override
  void dispose() {
    GlobalData.historyNotifier.removeListener(_onHistoryChanged);
    super.dispose();
  }

  void _onHistoryChanged() {
    _load();
  }

  void _load() {
    setState(() => _history = _global.getHistory());
  }

  String _fmtDuration(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.watchHistory),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: l.clearHistory,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l.clearHistoryTitle),
                    content: Text(l.clearHistoryConfirm),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.confirm)),
                    ],
                  ),
                ).then((ok) {
                  if (ok == true) {
                    _global.clearHistory();
                    _load();
                  }
                });
              },
            ),
        ],
      ),
      body: _history.isEmpty
          ? Center(child: Text(l.noWatchHistory))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final entry = _history[index];
                final pct = (entry.progress * 100).toStringAsFixed(0);
                return ListTile(
                  leading: Icon(
                    entry.done ? Icons.check_circle : Icons.play_circle_outline,
                    color: entry.done ? Colors.green : Theme.of(context).colorScheme.secondary,
                  ),
                  title: TranslatedText(
                    originalText: entry.episodeName,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    l.watchHistorySubtitle(_fmtDuration(entry.positionSec), _fmtDuration(entry.durationSec), pct),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Anime(link: entry.episodeLink),
                      ),
                    ).then((_) => _load());
                  },
                );
              },
            ),
    );
  }
}
