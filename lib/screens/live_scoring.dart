import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/widgets/match_up_list.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/models/match_up.dart';

class LiveScoringScreen extends StatefulWidget {
  final League league;
  final List<Franchise> franchises;

  LiveScoringScreen(this.league, this.franchises);

  @override
  State<StatefulWidget> createState() => LiveScoringScreenState(league, franchises);
}

class LiveScoringScreenState extends State<LiveScoringScreen> {
  final League league;
  final List<Franchise> franchises;
  List<MatchUp> matchUps = List<MatchUp>();

  LiveScoringScreenState(this.league, this.franchises);

  Future<Null> loadMatchUps() {
    final completer = Completer<Null>();

    fetchMatchUps(league, franchises).then((matchUps) {
      this.setState(() {
        this.matchUps = matchUps;
      });
      completer.complete();
    });

    return completer.future;
  }

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

  @override
  void initState() {
    super.initState();
    loadMatchUps();
  }

  @override
  build(BuildContext context) => RefreshIndicator(
    onRefresh: () => loadMatchUps(),
    child: Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: MatchUpList(matchUps),
    ),
  );
}
