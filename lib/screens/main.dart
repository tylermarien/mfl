import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:async';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/screens/chat.dart';
import 'package:mfl/screens/live_scoring.dart';
import 'package:mfl/screens/trades.dart';

Future<List<Franchise>> fetchFranchises(League league) async {
  final params = {
    'TYPE': 'league',
    'L': league.id,
  };

  final url = Uri.https(league.host, '/2018/export', params);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return xml.parse(response.body)
        .findAllElements('franchise')
        .map((element) => Franchise.fromXml(element))
        .toList();
  } else {
    throw Exception('Cannot load franchises');
  }
}

class MainScreen extends StatelessWidget {
  final League league;
  final String cookieName;
  final String cookieValue;

  MainScreen(this.league, this.cookieName, this.cookieValue);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFranchises(league),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage(
            title: 'Chat',
            franchises: snapshot.data,
            cookieName: cookieName,
            cookieValue: cookieValue,
          );
        }

        return Center(child: CircularProgressIndicator());
      },
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

  int _currentIndex = 0;
  List<Widget> _children = [];
  List<BottomNavigationBarItem> _items;

  MyHomePageState(this.franchises, this.cookieName, this.cookieValue);

  @override
  void initState() {
    super.initState();

    _children = [
      LiveScoringScreen(franchises),
      ChatScreen(cookieName, cookieValue, franchises),
      TradesScreen(),
    ];

    _items = [
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
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _items[_currentIndex].title,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: _items,
      ),
    );
  }
}