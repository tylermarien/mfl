import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

const url = 'http://www66.myfantasyleague.com/2018/export?TYPE=liveScoring&L=40298';

class LiveScoringScreen extends StatefulWidget {
  final List<Franchise> franchises;

  LiveScoringScreen(this.franchises);

  @override
  State<StatefulWidget> createState() => LiveScoringScreenState(franchises);
}

class LiveScoringScreenState extends State<LiveScoringScreen> {
  final List<Franchise> franchises;
  List<MatchUp> matchUps = List<MatchUp>();

  LiveScoringScreenState(this.franchises);

  Future<Null> loadMatchUps() {
    final completer = Completer<Null>();

    fetchMatchUps(franchises).then((matchUps) {
      this.setState(() {
        this.matchUps = matchUps;
      });
      completer.complete();
    });

    return completer.future;
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

class MatchUpList extends StatelessWidget {
  final List<MatchUp> matchUps;

  MatchUpList(this.matchUps);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: matchUps.length,
      itemBuilder: (context, index) => MatchUpRow(matchUps[index]),
    );
  }
}

class MatchUpRow extends StatelessWidget {
  final MatchUp matchUp;

  MatchUpRow(this.matchUp);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              MatchUpFranchiseRow(matchUp.franchise1),
              MatchUpFranchiseRow(matchUp.franchise2),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class MatchUpFranchiseRow extends StatelessWidget {
  final MatchUpFranchise franchise;

  MatchUpFranchiseRow(this.franchise);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(franchise.name)),
        Text(franchise.score),
      ],
    );
  }
}

Future<List<MatchUp>> fetchMatchUps(List<Franchise> franchises) async {
  final response = await http.get(url);

  print(response.statusCode);
  if (response.statusCode == 200) {
    return xml.parse(response.body)
        .findAllElements('matchup')
        .map((element) => MatchUp.fromXml(franchises, element))
        .toList();
  } else {
    throw Exception('Cannot fetch matchups');
  }
}

class Franchise {
  final String id;
  final String name;

  Franchise(this.id, this.name);

  factory Franchise.fromXml(xml.XmlElement element) {
    return Franchise(
      element.getAttribute('id'),
      element.getAttribute('name'),
    );
  }
}

class MatchUp {
  final MatchUpFranchise franchise1;
  final MatchUpFranchise franchise2;

  MatchUp(this.franchise1, this.franchise2);

  factory MatchUp.fromXml(List<Franchise> franchises, xml.XmlElement element) {
    final franchiseElements = element.findAllElements('franchise').toList();
    return MatchUp(
      MatchUpFranchise.fromXml(franchises, franchiseElements[0]),
      MatchUpFranchise.fromXml(franchises, franchiseElements[1]),
    );
  }
}

class MatchUpFranchise {
  final String id;
  final String name;
  final String score;

  MatchUpFranchise(this.id, this.name, this.score);

  factory MatchUpFranchise.fromXml(List<Franchise> franchises, xml.XmlElement element) {
    final id = element.getAttribute('id');
    final franchise = franchises.firstWhere((element) => element.id == id);
    return MatchUpFranchise(
      id,
      franchise.name,
      element.getAttribute('score'),
    );
  }
}
