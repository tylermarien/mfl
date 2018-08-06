import 'package:flutter/material.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/screens/league_search.dart';
import 'mfl_drawer_header.dart';

class MflDrawer extends StatelessWidget {
  final Franchise franchise;
  final League league;

  MflDrawer(this.franchise, this.league);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            MflDrawerHeader(franchise, league),
            ListTile(
                title: Text('Log out'),
                onTap: () {
                  final newRoute = MaterialPageRoute(builder: (context) => LeagueSearchScreen());
                  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                }
            )
          ],
        )
    );
  }
}