import 'package:flutter/material.dart';
import 'package:mfl/screens/league_search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'MyFantasyLeague',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LeagueSearchScreen(),
    );
  }
}