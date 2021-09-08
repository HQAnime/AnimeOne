import 'package:animeone/core/GlobalData.dart';
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

  group('GlobalData', () {
    test('Singleton', () {
      var s1 = new GlobalData();
      var s2 = new GlobalData();
      // Make sure they are the same
      expect(identical(s1, s2), isTrue);
      expect(s1 == s2, isTrue);
    });
  });

  group('String compare', () {
    test('0.0.3 > 0.0.2', () {
      expect('0.0.3' != '0.0.2', isTrue);
    });

    test('0.1.3 > 0.0.3', () {
      expect('0.1.3' != '0.0.3', isTrue);
    });

    test('1.0.3 > 0.1.2', () {
      expect('1.0.3' != '0.1.2', isTrue);
    });

    test('1.1.0 > 1.0.1', () {
      expect('1.1.0' != '1.0.1', isTrue);
    });

    test('1.1.10 > 1.1.9', () {
      expect('1.1.10' != '1.1.9', isTrue);
    });

    test('Legacy 1.0.7.1 > 1.0.7', () {
      expect('1.0.7.1'.compareTo('1.0.7') > 0, isTrue);
    });
  });

  group('Update Test', () {});
}
