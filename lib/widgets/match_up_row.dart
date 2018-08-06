import 'package:flutter/material.dart';
import 'package:mfl/widgets/match_up_franchise_row.dart';
import 'package:mfl/models/match_up.dart';

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