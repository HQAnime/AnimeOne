import 'dart:developer';

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
    log(widget.link);

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
        body: ListView.builder(
          itemCount: this.entries.length,
          itemBuilder: (context, index) {
            return AnimeEntryCard(entry: this.entries.elementAt(index));
          },
        ),
      );
    }
  }
  
}