import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:html/dom.dart';

/// This class parses a Node and stores anime recent (only name and link)
class AnimeRecent extends AnimeBasic {
  AnimeRecent(Node tr) : super.fromJson(null) {
    final anime = tr.firstChild;
    try {
      name = anime?.text;
      link = anime?.attributes['href'];
    } catch (e) {
      throw Exception('AnimeRecent - Tr has been changed\n${e.toString()}');
    }
  }
}
