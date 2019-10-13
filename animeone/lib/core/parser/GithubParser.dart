import 'dart:convert';

import 'package:animeone/core/other/GithubUpdate.dart';
import 'package:animeone/core/parser/BasicParser.dart';
import 'package:html/dom.dart';

/// This class get anime schedule and possibly an introductory video
class GithubParser extends BasicParser {
  
  GithubParser(String link) : super(link);

  @override
  GithubUpdate parseHTML(Document body) {
    return GithubUpdate.fromJson(jsonDecode(body.firstChild.text));
  }

}
