import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/WatchEntry.dart';
import 'package:animeone/core/parser/AnimePageParser.dart';
import 'package:animeone/core/parser/VideoSourceParser.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:animeone/ui/page/desktop_player.dart';
import 'package:animeone/ui/widgets/TranslatedText.dart';
import 'package:flutter/material.dart';

class _HistoryGroup {
  _HistoryGroup(this.title, this.entries);
  final String title;
  final List<WatchEntry> entries;
}

class WatchHistory extends StatefulWidget {
  const WatchHistory({super.key});

  @override
  State<WatchHistory> createState() => _WatchHistoryState();
}

class _WatchHistoryState extends State<WatchHistory> {
  final _global = GlobalData();
  List<WatchEntry> _history = [];
  String? _loadingKey;

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

  /// Group episodes that belong to the same anime, ordered by the most
  /// recently updated group first.
  List<_HistoryGroup> _buildGroups() {
    final groups = <_HistoryGroup>[];
    final indexByKey = <String, int>{};
    for (final entry in _history) {
      final key = entry.groupKey;
      final idx = indexByKey[key];
      if (idx == null) {
        indexByKey[key] = groups.length;
        groups.add(_HistoryGroup(entry.groupTitle, [entry]));
      } else {
        groups[idx].entries.add(entry);
      }
    }
    return groups;
  }

  void _openEpisode(String link) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Anime(link: link)),
    );
  }

  void _openEpisodePage(WatchEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Anime(link: entry.episodeLink)),
    ).then((_) => _load()).whenComplete(() => _loadingKey = null);
  }

  Future<void> _playEntry(WatchEntry entry) async {
    setState(() => _loadingKey = entry.episodeLink);
    try {
      final parser = AnimePageParser(entry.episodeLink);
      final doc = await parser.downloadHTML();
      final results = doc != null ? parser.parseHTML(doc) : [];
      if (!mounted) return;
      if (results.isEmpty) {
        _openEpisodePage(entry);
        return;
      }
      final animeEntry = results.first;
      final video = animeEntry.getVideo();
      if (video == null) {
        _openEpisodePage(entry);
        return;
      }
      String? url;
      Map<String, String> headers = {
        'referer': 'https://anime1.me/',
        'user-agent': GlobalData().getUserAgent(),
      };
      final videoUrl = video.video;
      if (video.hasToken && videoUrl != null) {
        final result = await VideoSourceParser().resolve(videoUrl);
        url = result.url;
        final cookie = result.cookie;
        headers['Cookie'] = cookie == null
            ? GlobalData().getCookie()
            : '${GlobalData().getCookie()}; $cookie';
      } else {
        url = videoUrl?.startsWith('http') == true ? videoUrl : null;
        headers['Cookie'] = GlobalData().getCookie();
      }
      if (!mounted) return;
      if (url != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DesktopPlayer(
              url: url!,
              headers: headers,
              episodeLink: entry.episodeLink,
              episodeName: entry.episodeName,
              animeLink: entry.animeLink,
              animeName: entry.animeName,
            ),
          ),
        ).then((_) => _load()).whenComplete(() => _loadingKey = null);
      } else {
        _openEpisodePage(entry);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingKey = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.loadFailed)),
      );
    }
  }

  Widget _buildTile(WatchEntry entry) {
    final l = AppLocalizations.of(context)!;
    final pct = (entry.progress * 100).toStringAsFixed(0);
    final loading = _loadingKey == entry.episodeLink;
    return ListTile(
      leading: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              entry.done ? Icons.check_circle : Icons.play_circle_outline,
              color: entry.done
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.secondary,
            ),
      title: TranslatedText(
        originalText: entry.episodeName,
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.watchHistorySubtitle(_fmtDuration(entry.positionSec),
                _fmtDuration(entry.durationSec), pct),
          ),
          const SizedBox(height: 4),
          TextButton(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            child: Text(l.allEpisodes),
            onPressed: () => _openEpisode(entry.animeLink ?? entry.episodeLink),
          ),
        ],
      ),
      onTap: _loadingKey != null ? null : () => _playEntry(entry),
    );
  }

  Widget _buildGroup(_HistoryGroup group) {
    final l = AppLocalizations.of(context)!;
    return ExpansionTile(
      leading: Icon(
        Icons.video_library,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: TranslatedText(
        originalText: group.title,
        maxLines: 1,
      ),
      subtitle: Text(l.watchHistoryEpisodeCount(group.entries.length)),
      children: group.entries.map(_buildTile).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final groups = _buildGroups();
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
      body: groups.isEmpty
          ? Center(child: Text(l.noWatchHistory))
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) => _buildGroup(groups[index]),
            ),
    );
  }
}
