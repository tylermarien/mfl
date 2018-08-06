import 'package:flutter/material.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/screens/login.dart';

class LeaguesScreen extends StatelessWidget {
  final List<League> leagues;

  LeaguesScreen(this.leagues);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final League league = leagues[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: GestureDetector(
                    child: Text(league.name),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return LoginScreen(league);
                      }));
                    },
                  ),
                ),
                Divider(),
              ],
            );
          },
          itemCount: leagues.length,
        ),
      ),
    );
  }
}