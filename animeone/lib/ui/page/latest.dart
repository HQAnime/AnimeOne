import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeRecent.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/component/AnimeRecentTile.dart';
import 'package:animeone/ui/component/ErrorButton.dart';
import 'package:animeone/ui/page/settings.dart';
import 'package:animeone/ui/page/support.dart';
import 'package:flutter/material.dart';

class Latest extends StatefulWidget {
  const Latest({super.key});

  @override
  State<Latest> createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  bool loading = false;
  List<AnimeRecent> list = [];
  final global = GlobalData();

  @override
  void initState() {
    super.initState();
    setState(() {
      list = global.getRecentList();
    });
    GlobalData.historyNotifier.addListener(_onHistoryChanged);
  }

  @override
  void dispose() {
    GlobalData.historyNotifier.removeListener(_onHistoryChanged);
    super.dispose();
  }

  void _onHistoryChanged() {
    setState(() {});
  }

  /// Load or refresh latest anime
  void loadRecentAnime() {
    // Reset to loading
    setState(() {
      loading = true;
    });

    global.getRecentAnime().then((d) {
      setState(() {
        list = global.getRecentList();
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.latestAnime),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.refreshLatest,
            onPressed: () => loadRecentAnime(),
          ),
          Ink.image(
            image: const AssetImage('lib/assets/icon/logo.png'),
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
            width: 32,
            height: 32,
            child: Tooltip(
              message: l.aboutAnimeOne,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.favorite),
          tooltip: l.supportDev,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Support(),
              ),
            );
          },
        ),
      ),
      body: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Center(
          child: renderBody(),
        ),
      ),
    );
  }

  Widget renderBody() {
    if (loading) {
      return const CircularProgressIndicator();
    } else if (list.isEmpty) {
      // If somehow we cannot get recent anime
      return ErrorButton();
    } else {
      return SafeArea(
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return AnimeRecentTile(
                recent: list.elementAt(index),
                autofocus: index == 0,
              );
            },
          ),
        ),
      );
    }
  }
}
