import 'package:flutter/material.dart';
import 'package:mfl/screens/leagues.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/screens/login.dart';
import 'package:mfl/api/leagues.dart';

class LeagueSearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeagueSearchScreenState();
}

class LeagueSearchScreenState extends State<LeagueSearchScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String query;

  void search(BuildContext context) {
    _formKey.currentState.save();

    searchLeagues(query)
      .then((List<League> leagues) {
        if (leagues.length == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen(leagues.first)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LeaguesScreen(leagues)));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'League name',
                ),
                onSaved: (value) => query = value,
              ),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: RaisedButton(
                  child: Text('Search', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                  onPressed: () => search(context),
                ),
              ),
            ] ,
          ),
        ),
      ),
    );
  }
}