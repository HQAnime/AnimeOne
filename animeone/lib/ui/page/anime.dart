import 'dart:math';

import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/core/parser/AnimePageParser.dart';
import 'package:animeone/ui/component/AnimeEntryCard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// This class handles anime page
/// - One episode
/// - All episode
/// - Load next page if possible
class Anime extends StatefulWidget {
  
  final String link;

  Anime({Key key, @required this.link}): super(key: key);

  @override
  _AnimeState createState() => _AnimeState();

}

class _AnimeState extends State<Anime> {

  // Always start from page 1
  String fullLink = '';
  bool loading = true;
  // paging
  int page = 1;
  bool hasMoreData = true;
  bool canLoadMore = true;

  String title;
  AnimePageParser parser;
  List<AnimeEntry> entries = [];
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    this._getEntry();
    this.controller = new ScrollController()..addListener(() => this.loadMore());
  }

  /// Get entries from link (support page)
  void _getEntry() {
    this.canLoadMore = false;
    String rLink = this.fullLink == '' ? widget.link : this.fullLink + '/page/${this.page}';
    this.parser = new AnimePageParser(rLink);
    this.parser.downloadHTML().then((d) {
      if (d == null) {
        // Stop loading more data
        this.hasMoreData = false;
      } else {
        if (widget.link.contains('cat')) {
          this.fullLink = this.parser.getFullLink(d);
        } else {
          this.fullLink = widget.link;
        }
        setState(() {
          // Append more data
          this.entries.addAll(this.parser.parseHTML(d));
          this.title = this.parser.getPageTitle(d);
          this.loading = false;
        });
      }
      this.canLoadMore = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('加載中...')
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
          actions: <Widget>[
            this.renderSearch(),
            IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => launch(this.fullLink),
              tooltip: '用瀏覽器打開',
            )
          ],
        ),
        body: this.renderBody()
      );
    }
  }

  /// Render a search icon to go to wikipedia
  Widget renderSearch() {
    if (this.title != '') {
      return IconButton(
        icon: Icon(Icons.search),
        onPressed: () => launch('https://zh.wikipedia.org/w/index.php?search=${this.title}'),
        tooltip: '使用維基百科搜索',
      );
    } else {
      return SizedBox.shrink();
    }
  }

  /// Render differently with different number of elements
  Widget renderBody() {
    if (this.entries.length == 0) {
      return Center(
        child: Text('未知錯誤 >_<')
      );
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
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          int count = max(min((constraints.maxWidth / 300).floor(), 7), 1);
          double imageWidth = constraints.maxWidth / count.toDouble();
          // Calculat ratio
          double ratio = imageWidth / (imageWidth / 1.777 + 90);

          int length = this.entries.length;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              childAspectRatio: ratio
            ),
            itemCount: length,
            itemBuilder: (context, index) {
              return AnimeEntryCard(entry: this.entries.elementAt(index));
            },
            controller: this.controller,
          );
        },
      );
    }
  }

  /// Load more anime here
  void loadMore() {
    if (controller.position.extentAfter < 10 && this.entries.length % 14 == 0 && this.hasMoreData && !loading) {
      if (canLoadMore) {
        this.page += 1;
        this._getEntry();
      } 
    }
  }
  
}