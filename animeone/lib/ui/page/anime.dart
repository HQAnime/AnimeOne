import 'dart:developer';
import 'dart:developer' as prefix0;
import 'dart:math';

import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/core/parser/AnimePageParser.dart';
import 'package:animeone/core/parser/AnimeParser.dart';
import 'package:animeone/ui/component/AnimeEntryCard.dart';
import 'package:flutter/material.dart';

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
      this.fullLink = this.parser.getFullLink(d);
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
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(this.title)
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            int count = max(min((constraints.maxWidth / 300).floor(), 7), 1);
            prefix0.log(constraints.maxWidth.toString());
            double imageWidth = constraints.maxWidth / count.toDouble();
            // Calculat ratio
            double ratio = imageWidth / (imageWidth / 1.777 + 120);
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
        )
      );
    }
  }
  
}