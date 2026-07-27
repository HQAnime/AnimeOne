import 'package:animeone/core/AnimeOne.dart';
import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/component/EmailButton.dart';
import 'package:animeone/ui/page/latest.dart';
import 'package:animeone/ui/page/list.dart';
import 'package:animeone/ui/page/schedule.dart';
import 'package:animeone/ui/page/watch_history.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  bool loading = true;
  String error = '';

  final global = GlobalData();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() {
    // Reset everything
    setState(() {
      loading = true;
      error = '';
    });

    // Init if not and check for update
    global.init().then((_) {
      if (!mounted) return;
      final update = global.getGithubUpdate();
      if (update != null) {
        update.checkUpdate(context);
      }

      if (global.showShowAgeAlert()) {
        // Show the alert
        showDialog(
          context: context,
          // Prevent accidental dismiss
          barrierDismissible: false,
          builder: (BuildContext context) {
            // No update
            final l = AppLocalizations.of(context)!;
            return AlertDialog(
              title: Text(l.ageRestrictionTitle),
              content: Text(l.ageRestrictionContent),
              actions: <Widget>[
                TextButton(
                  child: Text(l.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Don't show this again
                    global.updateAgeAlert();
                  },
                ),
              ],
            );
          },
        );
      }

      setState(() {
        loading = false;
      });
    }).catchError((e) {
      setState(() {
        error = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.new_releases),
            label: AppLocalizations.of(context)!.tabLatest,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: AppLocalizations.of(context)!.tabAnimeList,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.tabSchedule,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: AppLocalizations.of(context)!.tabWatchHistory,
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        onTap: onItemTapped,
      ),
    );
  }

  /// Loading or index stacked
  Widget renderBody() {
    if (error != '') {
      final l = AppLocalizations.of(context)!;
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  l.loadFailed,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  l.retryMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox.fromSize(size: const Size.fromHeight(24)),
                Text(
                  l.errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                SizedBox.fromSize(size: const Size.fromHeight(24)),
                Text(
                  l.whatNow,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  child: Text(l.openInBrowser),
                  onPressed: () => launchUrlString(GlobalData.domain),
                ),
                Text(
                  l.or,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                  child: Text(l.checkUpdate),
                  onPressed: () {
                    GlobalData().checkGithubUpdate().then((_) {
                      if (!mounted) return;
                      GlobalData()
                          .getGithubUpdate()
                          ?.checkUpdate(context, showAlertWhenNoUpdate: true);
                    });
                  },
                ),
                Text(
                  l.or,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                  child: Text(
                    l.tryFix,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    GlobalData.requestCookieLink ??= GlobalData.domain;
                    final channel = AnimeOne();
                    channel.bypassWebsiteCheck(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 36,
            child: Tooltip(
              message: l.reloadData,
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _loadData(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: EmailButton(message: error),
          )
        ],
      );
    } else if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return IndexedStack(
        index: selectedIndex,
        children: const [
          Latest(),
          AnimeList(),
          Schedule(),
          WatchHistory(),
        ],
      );
    }
  }

  /// Switch tabs
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
