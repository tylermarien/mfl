import 'package:flutter/material.dart';
import 'package:mfl/widgets/match_up_row.dart';
import 'package:mfl/models/match_up.dart';

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