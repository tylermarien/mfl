import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/models/franchise.dart';
import 'package:mfl/screens/login.dart';
import 'package:mfl/screens/chat.dart';
import 'package:mfl/screens/live_scoring.dart';
import 'package:mfl/screens/trades.dart';

const leagueUrl = 'http://www66.myfantasyleague.com/2018/export?TYPE=league&L=40298';

Future<List<Franchise>> fetchFranchises() async {
  final response = await http.get(leagueUrl);

  if (response.statusCode == 200) {
    return xml.parse(response.body)
        .findAllElements('franchise')
        .map((element) => Franchise.fromXml(element))
        .toList();
  } else {
    throw Exception('Cannot load franchises');
  }
}

void main() async {
  final franchises = await fetchFranchises();
  runApp(MyApp(franchises));
}

const loginUrl = 'https://www66.myfantasyleague.com/2018/login';

class MyApp extends StatefulWidget {
  final List<Franchise> franchises;

  MyApp(this.franchises);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String cookieName;
  String cookieValue;

  Future<String> login(String username, String password) async {
    final body = {
      'LEAGUE_ID': '40298',
      'USERNAME': username,
      'PASSWORD': password,
      'XML': '1',
    };

    final response = await http.post(loginUrl, body: body);
    if (response.statusCode == 200) {
      final data = xml.parse(response.body);
      final error = data.findAllElements('error');

      if (error.isEmpty) {
        final status = data.findAllElements('status');

        this.setState(() {
          cookieName = status.first.attributes.first.name.toString();
          cookieValue = status.first.attributes.first.value;
        });

        return 'Login successful';
      } else {
        return error.first.text;
      }
    } else {
      return 'Login unsuccessful';
    }
  }

  @override
  build(BuildContext context) {
    Widget home;

    if (cookieValue != null) {
      home = FutureBuilder(
        future: fetchFranchises(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage(title: 'Chat', franchises: snapshot.data, cookieName: cookieName, cookieValue: cookieValue);
          }

          return Center(child: CircularProgressIndicator());
        },
      );
    } else {
      home = LoginScreen(login: login);
    }

    return MaterialApp(
      title: 'MyFantasyLeague',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: home,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.franchises, this.cookieName, this.cookieValue}) : super(key: key);

  final String title;
  final String cookieName;
  final String cookieValue;
  final List<Franchise> franchises;

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState(franchises, cookieName, cookieValue);
  }
}

class MyHomePageState extends State<MyHomePage> {
  final List<Franchise> franchises;
  final String cookieName;
  final String cookieValue;

  MyHomePageState(this.franchises, this.cookieName, this.cookieValue) {
    _children = [
      LiveScoringScreen(franchises),
      ChatScreen(cookieName: cookieName, cookieValue: cookieValue),
      TradesScreen(),
    ];
  }

  var _currentIndex = 0;
  var _children = [];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered),
              title: Text('Live Scoring'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('Chat'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered),
              title: Text('Trades'),
            ),
          ],
        ),
    );
  }
}