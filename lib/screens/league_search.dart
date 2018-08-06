import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/screens/leagues.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/screens/login.dart';

class LeagueSearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeagueSearchScreenState();
}

class LeagueSearchScreenState extends State<LeagueSearchScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String query;

  void search(BuildContext context) {
    _formKey.currentState.save();

    final params = {
      'TYPE': 'leagueSearch',
      'SEARCH': query,
    };

    final url = Uri.https('www03.myfantasyleague.com', '/2018/export', params);
    http.get(url)
        .then((http.Response response) {
          final document = xml.parse(response.body);
          final leagues = document.findAllElements('league')
            .map((element) => League.fromXml(element))
            .toList();

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