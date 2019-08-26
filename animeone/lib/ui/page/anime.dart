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
  int page = 1;
  bool loading = true;
  String title;
  AnimePageParser parser;
  List<AnimeEntry> entries = [];

  @override
  void initState() {
    super.initState();
    this._getEntry();
  }

  /// Get entries from link (support page)
  void _getEntry() {
    String rLink = this.fullLink == '' ? widget.link : this.fullLink + '/page/$page';
    this.parser = new AnimePageParser(rLink);
    this.parser.downloadHTML().then((d) {
      if (widget.link.contains('cat')) {
        this.fullLink = this.parser.getFullLink(d);
      } else {
        this.fullLink = widget.link;
      }
      setState(() {
        this.entries = this.parser.parseHTML(d);
        this.title = this.parser.getPageTitle(d);
        this.loading = false;
      });
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
            IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () => launch(this.fullLink),
            )
          ],
        ),
        body: this.renderBody()
      );
    }
  }

  /// Render differently with different number of elements
  Widget renderBody() {
    if (this.entries.length == 0) {
      return Center(
        child: Text('位置錯誤 >_<')
      );
    } else if (this.entries.length == 1) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxHeight,
              child: AnimeEntryCard(entry: this.entries.first)
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
          double ratio = imageWidth / (imageWidth / 1.777 + 150);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              childAspectRatio: ratio
            ),
            itemCount: this.entries.length,
            itemBuilder: (context, index) {
              return AnimeEntryCard(entry: this.entries.elementAt(index));
            },
          );
        },
      );
    }
  }
  
}