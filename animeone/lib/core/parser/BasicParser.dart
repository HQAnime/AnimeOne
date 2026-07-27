import 'package:animeone/core/ApiService.dart';
import 'package:html/dom.dart';

abstract class BasicParser {
  final String _link;
  final ApiService api;

  BasicParser(this._link) : api = ApiService(_link);

  Future<Document?> downloadHTML() async {
    var target = _link;
    if (target.contains('/?cat')) target = await api.resolveRedirect(target);
    final res = await api.get(link: target);
    return api.handleResponse(res);
  }

  dynamic parseHTML(Document? body);
}
