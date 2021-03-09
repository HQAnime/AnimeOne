import 'dart:math';

import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/core/parser/AnimePageParser.dart';
import 'package:animeone/ui/component/AnimeEntryCard.dart';
import 'package:animeone/ui/component/ErrorButton.dart';
import 'package:animeone/ui/page/video.dart';
import 'package:flutter/material.dart';

/// This class handles anime page
/// - One episode
/// - All episode
/// - Load next page if possible
class Anime extends StatefulWidget {
  
  final String? link;
  final bool? seasonal;

  Anime({Key? key, required this.link, this.seasonal}): super(key: key);

  @override
  _AnimeState createState() => _AnimeState();

}

class _AnimeState extends State<Anime> {

  final global = new GlobalData();

  // Always start from page 1
  String? fullLink = '';
  bool loading = true;
  // paging
  int page = 1;
  bool hasMoreData = true;
  bool canLoadMore = true;

  // Catch error messages
  String hasError = '';

  String title = '加載失敗了...';
  late AnimePageParser parser;
  List<AnimeEntry> entries = [];
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    this._getEntry();
    this.controller = new ScrollController()..addListener(() => this.loadMore());
  }

  /// Get entries from link (support page)
  void _getEntry() {
    setState(() {
      this.canLoadMore = false;
    });

    String? rLink = this.fullLink == '' ? widget.link : this.fullLink ?? '' + '/page/${this.page}';
    this.parser = new AnimePageParser(rLink);
    this.parser.downloadHTML().then((d) {
      if (d == null) {
        // Stop loading more data
        this.hasMoreData = false;

        setState(() {
          this.canLoadMore = true;
          this.loading = false;
        });
      } else {
        // Category also contains cat so you need to make it longer
        if (widget.link?.contains('/?cat=') ?? false) {
          this.fullLink = this.parser.getFullLink(d);
        } else {
          this.fullLink = widget.link;
        }

        final newEntries = this.parser.parseHTML(d);
        setState(() {
          // Append more data
          this.entries.addAll(newEntries);
          this.title = this.parser.getPageTitle(d);
          this.loading = false;
          this.canLoadMore = true;

          // Start playing if there is only one entry
          if (newEntries.length == 1) {
            Navigator.push(context, new MaterialPageRoute(builder: (context) => Video(video: newEntries.first.videoLink)));
          }
        });
      }
    }).catchError((error) {
      // Something is broken
      setState(() {
        this.hasError = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('努力加載中...')
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (hasError != '') {
      return Scaffold(
        appBar: AppBar(
          title: Text('加载失败 QAQ')
        ),
        body: ErrorButton(msg: this.hasError)
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
          actions: <Widget>[
            this.renderSearch()
          ],
        ),
        body: this.renderBody()
      );
    }
  }

  /// Render a search icon to go to wikipedia
  Widget renderSearch() {
    if (this.title != '' && widget.seasonal == null && this.title != '加載失敗了...') {
      return IconButton(
        icon: Icon(Icons.search),
        onPressed: () => global.getWikipediaLink(this.title),
        tooltip: '使用維基百科搜索',
      );
    } else {
      return SizedBox.shrink();
    }
  }

  /// Render differently with different number of elements
  Widget renderBody() {
    if (this.entries.length == 0) {
      return ErrorButton();
    } else if (this.entries.length == 1) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxHeight,
              child: AnimeEntryCard(entry: this.entries.first, showEpisode: true)
            )
          );
        }
      );
    } else {
      return SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            int count = max(min((constraints.maxWidth / 300).floor(), 3), 1);
            double imageWidth = constraints.maxWidth / count.toDouble();
            // Adjust offset
            double offset = 93;
            if (widget.seasonal != null) offset = 125;
            // Calculat ratio
            double ratio = imageWidth / (imageWidth / 1.777 + offset);

            int length = this.entries.length;
            return Stack(
              children: <Widget>[
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    childAspectRatio: ratio
                  ),
                  itemCount: length,
                  itemBuilder: (context, index) {
                    return AnimeEntryCard(entry: this.entries.elementAt(index), showEpisode: widget.seasonal == null ? false : true);
                  },
                  controller: this.controller,
                ),
                this.loadDivider()
              ],
            );
          },
        ),
      );
    }
  }

  Widget loadDivider() {
    if (!this.loading && !this.canLoadMore) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: LinearProgressIndicator(),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  /// Load more anime here
  void loadMore() {
    if ((controller?.position.extentAfter ?? 10) < 10 && this.entries.length % 14 == 0 && this.hasMoreData) {
      if (canLoadMore) {
        this.page += 1;
        this._getEntry();
      } 
    }
  }
  
}