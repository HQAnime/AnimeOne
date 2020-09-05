import 'package:animeone/core/parser/AnimeListParser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test my classes related to fetching data from Internet and see if they work as intended
void main() {
  group("test BasicParser", () {
    test('basic functionality', () async {
      // Try parsing home page
      final parser = new AnimeListParser('https://anime1.cc/');
      final doc = await parser.downloadHTML();
      expect(doc != null, isTrue);
    });

    test('handle AnimeNotFound correctly', () async {
      // Try parsing a 404 page
      final parser = new AnimeListParser('https://anime1.cc/category/2019%E5%B9%B4%E6%98%A5%E5%AD%A3/%E9%AC%BC%E6%BB%85%E4%B9%8B%E5%88%83/page/9/');
      final doc = await parser.downloadHTML();
      expect(doc == null, isTrue);
    });
  });
}
