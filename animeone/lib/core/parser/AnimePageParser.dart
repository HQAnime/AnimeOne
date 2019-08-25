import 'package:animeone/core/anime/AnimeEntry.dart';
import 'package:animeone/core/parser/AnimeParser.dart';
import 'package:html/dom.dart';

/// This class gets all episodes of an anime or just one episode
/// - https://anime1.me/category/2019年春季/鬼滅之刃/page/0
/// - https://anime1.me/10391
/// 
/// The long link can up to 14 episodes and the short one only has one. 
/// They have a link to all episodes or next episode
class AnimePageParser extends AnimeParser {
  
  AnimePageParser(String link) : super(link);

  @override
  parseHTML(Document body) {
    List<AnimeEntry> list = [];

    final elements = body.getElementsByClassName("hentry");
    elements.forEach((e) {
      list.add(new AnimeEntry(e));
    });

    return list;
  }

}
