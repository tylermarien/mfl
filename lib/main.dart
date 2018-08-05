import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'chat.dart';
import 'live_scoring.dart';
import 'trades.dart';

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

const leagueUrl = 'http://www66.myfantasyleague.com/2018/export?TYPE=league&L=40298';

class MyApp extends StatelessWidget {
  final List<Franchise> franchises;

  MyApp(this.franchises);

  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'MyFantasyLeague',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Chat', franchises: franchises),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.franchises}) : super(key: key);

  final String title;
  final List<Franchise> franchises;

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState(franchises);
  }
}

class MyHomePageState extends State<MyHomePage> {
  final List<Franchise> franchises;

  MyHomePageState(this.franchises) {
    _children = [
      LiveScoringScreen(franchises),
      ChatScreen(),
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