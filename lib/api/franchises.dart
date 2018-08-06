import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';

Future<List<Franchise>> fetchFranchises(League league, String cookieName, String cookieValue) async {
  final params = {
    'TYPE': 'league',
    'L': league.id,
  };

  final url = Uri.https(league.host, '/2018/export', params);
  final headers = {
    'Cookie': '$cookieName=$cookieValue',
  };
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    return xml.parse(response.body)
        .findAllElements('franchise')
        .map((element) => Franchise.fromXml(element))
        .toList();
  } else {
    throw Exception('Cannot load franchises');
  }
}