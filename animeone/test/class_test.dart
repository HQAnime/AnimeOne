import 'package:animeone/core/anime/AnimeSeason.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test my classes and see if they work as intended
void main() {
  group("AnimeSeason", () { 
    test('test spring 4/4/2019', () {
      final season = new AnimeSeason(new DateTime(2019, 4, 4));
      expect(season.toString() == '2019年春季新番', isTrue);
    });

    test('test summer 4/7/2019', () {
      final season = new AnimeSeason(new DateTime(2019, 7, 4));
      expect(season.toString() == '2019年夏季新番', isTrue);
    });

    test('test autumn 4/10/2019', () {
      final season = new AnimeSeason(new DateTime(2019, 10, 4));
      expect(season.toString() == '2019年秋季新番', isTrue);
    });

    test('test winter 1/1/2019', () {
      final season = new AnimeSeason(new DateTime(2019, 1, 1));
      expect(season.toString() == '2019年冬季新番', isTrue);
    });

    test('test summer 25/8/2020', () {
      final season = new AnimeSeason(new DateTime(2020, 8, 25));
      expect(season.toString() == '2020年夏季新番', isTrue);
    });

    test('test site link', () {
      final season = new AnimeSeason(new DateTime(2019, 8, 25));
      expect(season.getLink() == 'https://anime1.me/2019年夏季新番', isTrue);
    });
  });
}
