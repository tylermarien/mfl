import 'package:flutter/material.dart';
import 'package:mfl/models/match_up_franchise.dart';

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