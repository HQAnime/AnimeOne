import 'package:html/dom.dart';

/// This class parses a Node and stores anime info like anime name, anime link, total episodes, year, season and subtitle group
class AnimeRecent {

  String name;
  String link;

  AnimeRecent(Node tr) {
    final anime = tr.firstChild;
    try {
      this.name = anime.text;
      this.link = anime.attributes['href'];
    } catch (e) {
      throw new Exception('AnimeRecent - Tr has been changed\n${e.toString()}');
    }
  }

}
