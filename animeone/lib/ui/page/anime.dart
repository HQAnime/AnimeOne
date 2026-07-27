import 'dart:math';

import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/core/parser/AnimePageParser.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/component/AnimeEntryCard.dart';
import 'package:animeone/ui/component/ErrorButton.dart';
import 'package:flutter/material.dart';

/// This class handles anime page
/// - One episode
/// - All episode
/// - Load next page if possible
class Anime extends StatefulWidget {
  const Anime({
    super.key,
    required this.link,
    this.seasonal,
    this.recent,
  });

  final String? link;
  final bool? seasonal;
  final bool? recent;

  @override
  State<Anime> createState() => _AnimeState();
}

class _AnimeState extends State<Anime> {
  final global = GlobalData();

  // Always start from page 1
  String? fullLink = '';
  bool loading = true;
  // paging
  int page = 1;
  bool hasMoreData = true;
  bool canLoadMore = true;

  // Catch error messages
  String hasError = '';

  String title = '';
  late AnimePageParser parser;
  List<AnimeEntry> entries = [];
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    GlobalData.historyNotifier.addListener(_onHistoryChanged);
    _getEntry();
    controller = ScrollController()..addListener(() => loadMore());
  }

  @override
  void dispose() {
    GlobalData.historyNotifier.removeListener(_onHistoryChanged);
    super.dispose();
  }

  void _onHistoryChanged() {
    setState(() {});
  }

  /// Get entries from link (support page)
  void _getEntry() {
    setState(() {
      canLoadMore = false;
    });

    String? rLink = widget.link;
    if (fullLink != null && fullLink != '') {
      rLink = '${fullLink!}/page/$page';
    }

    parser = AnimePageParser(rLink!);
    parser.downloadHTML().then((d) {
      if (d == null) {
        // Stop loading more data
        hasMoreData = false;

        setState(() {
          canLoadMore = true;
          loading = false;
        });
      } else {
        // Category also contains cat so you need to make it longer
        if (widget.link?.contains('/?cat=') ?? false) {
          fullLink = parser.getFullLink(d);
        } else {
          fullLink = widget.link;
        }

        final newEntries = parser.parseHTML(d);
        setState(() {
          // Append more data
          entries.addAll(newEntries);
          title = parser.getPageTitle(d);
          loading = false;
          canLoadMore = true;

          // Don't auto play here, it can be quite annoying
        });
      }
    }).catchError((error) {
      // Something is broken
      setState(() {
        hasError = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Always show error message first even if it is loading
    if (hasError != '') {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.loadFailedQaq)),
        body: ErrorButton(msg: hasError),
      );
    } else if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.loading)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[renderSearch()],
        ),
        body: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: renderBody(),
        ),
      );
    }
  }

  /// Render a search icon to go to wikipedia
  Widget renderSearch() {
    if (title != '' && widget.seasonal == null) {
      return IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => global.getWikipediaLink(title),
        tooltip: AppLocalizations.of(context)!.wikipediaSearch,
      );
    } else {
      return Container();
    }
  }

  /// Render differently with different number of elements
  Widget renderBody() {
    if (entries.isEmpty) {
      return ErrorButton(msg: AppLocalizations.of(context)!.nothingFound);
    } else if (entries.length == 1) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: SizedBox(
            width: constraints.maxHeight,
            child: AnimeEntryCard(
              entry: entries.first,
              showEpisode: true,
              pageUrl: widget.link,
              progress: global.getWatchEntry(widget.link ?? '')?.progress,
            ),
          ),
        );
      });
    } else {
      return SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final scaler = MediaQuery.of(context).textScaler;
            int count = max(min((constraints.maxWidth / scaler.scale(300)).floor(), 3), 1);
            double imageWidth = constraints.maxWidth / count.toDouble();
            double offset = scaler.scale(93);
            if (widget.seasonal != null) offset = scaler.scale(125);
            // Calculat ratio
            double ratio = imageWidth / (imageWidth / 1.777 + offset);

            int length = entries.length;
            return Stack(
              children: <Widget>[
                GridView.builder(
                  key: ValueKey('grid_${count}_${ratio.toStringAsFixed(3)}'),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    childAspectRatio: ratio,
                  ),
                  itemCount: length,
                  itemBuilder: (context, index) {
                    final e = entries.elementAt(index);
                    return AnimeEntryCard(
                      entry: e,
                      showEpisode: widget.seasonal == null ? false : true,
                      pageUrl: widget.link,
                      progress: global.getWatchEntry(widget.link ?? e.link ?? '')?.progress,
                    );
                  },
                  controller: controller,
                ),
                loadDivider()
              ],
            );
          },
        ),
      );
    }
  }

  Widget loadDivider() {
    if (!loading && !canLoadMore) {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: LinearProgressIndicator(),
      );
    } else {
      return Container();
    }
  }

  /// Load more anime here
  void loadMore() {
    if ((controller?.position.extentAfter ?? 10) < 10 &&
        entries.length % 14 == 0 &&
        hasMoreData) {
      if (canLoadMore) {
        page += 1;
        _getEntry();
      }
    }
  }
}
