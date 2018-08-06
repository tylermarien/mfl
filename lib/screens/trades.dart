import 'package:flutter/material.dart';
import 'package:mfl/models/league.dart';


class TradesScreen extends StatelessWidget {
  final League league;

  TradesScreen(this.league);

  @override
  build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text('Trades'),
          ),
        ),
      ],
    );
  }
}