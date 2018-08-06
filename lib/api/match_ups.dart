import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/models/match_up.dart';

Future<List<MatchUp>> fetchMatchUps(League league, List<Franchise> franchises) async {
  final params = {
    'TYPE': 'liveScoring',
    'L': league.id,
  };
  final url = Uri.https(league.host, '/2018/export', params);

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return xml.parse(response.body)
        .findAllElements('matchup')
        .map((element) => MatchUp.fromXml(franchises, element))
        .toList();
  } else {
    throw Exception('Cannot fetch matchups');
  }
}