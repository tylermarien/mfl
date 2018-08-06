import 'package:flutter/material.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';

class MflDrawerHeader extends StatelessWidget {
  final Franchise franchise;
  final League league;

  MflDrawerHeader(this.franchise, this.league);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            franchise.owner,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            league.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.green,
      ),
    );
  }
}