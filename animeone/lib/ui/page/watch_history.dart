import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/WatchEntry.dart';
import 'package:animeone/core/parser/AnimePageParser.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/page/desktop_player.dart';
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
  int? _loadingIndex;

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
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l.cancel)),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l.confirm)),
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
                  leading: _loadingIndex == index
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          entry.done
                              ? Icons.check_circle
                              : Icons.play_circle_outline,
                          color: entry.done
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                  title: TranslatedText(
                    originalText: entry.episodeName,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    l.watchHistorySubtitle(_fmtDuration(entry.positionSec),
                        _fmtDuration(entry.durationSec), pct),
                  ),
                  onTap: _loadingIndex != null
                      ? null
                      : () async {
                          setState(() => _loadingIndex = index);
                          final parser = AnimePageParser(entry.episodeLink);
                          final doc = await parser.downloadHTML();
                          final results =
                              doc != null ? parser.parseHTML(doc) : [];
                          if (!context.mounted) return;
                          if (results.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Anime(link: entry.episodeLink),
                              ),
                            )
                                .then((_) => _load())
                                .whenComplete(() => _loadingIndex = null);
                            return;
                          }
                          final animeEntry = results.first;
                          final video = animeEntry.getVideo();
                          if (video == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Anime(link: entry.episodeLink),
                              ),
                            )
                                .then((_) => _load())
                                .whenComplete(() => _loadingIndex = null);
                            return;
                          }
                          String? url;
                          Map<String, String> headers = {
                            'referer': 'https://anime1.me/',
                            'user-agent': GlobalData().getUserAgent(),
                          };
                          final videoUrl = video.video;
                          if (video.hasToken && videoUrl != null) {
                            final result =
                                await VideoSourceParser().resolve(videoUrl);
                            url = result.url;
                            final cookie = result.cookie;
                            headers['Cookie'] = cookie == null
                                ? GlobalData().getCookie()
                                : '${GlobalData().getCookie()}; $cookie';
                          } else {
                            url = videoUrl?.startsWith('http') == true
                                ? videoUrl
                                : null;
                            headers['Cookie'] = GlobalData().getCookie();
                          }
                          if (!context.mounted) return;
                          if (url != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DesktopPlayer(
                                  url: url!,
                                  headers: headers,
                                  episodeLink: entry.episodeLink,
                                  episodeName: entry.episodeName,
                                ),
                              ),
                            )
                                .then((_) => _load())
                                .whenComplete(() => _loadingIndex = null);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Anime(link: entry.episodeLink),
                              ),
                            )
                                .then((_) => _load())
                                .whenComplete(() => _loadingIndex = null);
                          }
                        },
                );
              },
            ),
    );
  }
}
