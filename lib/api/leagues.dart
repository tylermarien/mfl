import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/models/league.dart';

Future<List<League>> searchLeagues(String query) async {
  final params = {
    'TYPE': 'leagueSearch',
    'SEARCH': query,
  };

  final url = Uri.https('www03.myfantasyleague.com', '/2018/export', params);
  final response = await http.get(url);
  final document = xml.parse(response.body);
  return document.findAllElements('league')
      .map((element) => League.fromXml(element))
      .toList();
}
