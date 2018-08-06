import 'package:flutter/material.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/screens/chat.dart';
import 'package:mfl/screens/live_scoring.dart';
import 'package:mfl/widgets/mfl_drawer.dart';
import 'package:mfl/api/franchises.dart';

class MainScreen extends StatelessWidget {
  final String username;
  final League league;
  final String cookieName;
  final String cookieValue;

  MainScreen(this.username, this.league, this.cookieName, this.cookieValue);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFranchises(league, cookieName, cookieValue),
      builder: (context, AsyncSnapshot<List<Franchise>> snapshot) {
        if (snapshot.hasData) {
          return MyHomePage(
            title: 'Chat',
            league: league,
            franchise: snapshot.data.firstWhere((franchise) => franchise.username == username),
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
  MyHomePage({Key key, this.title, this.league, this.franchise, this.franchises, this.cookieName, this.cookieValue}) : super(key: key);

  final String title;
  final String cookieName;
  final String cookieValue;
  final League league;
  final Franchise franchise;
  final List<Franchise> franchises;

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState(league, franchise, franchises, cookieName, cookieValue);
  }
}

class MyHomePageState extends State<MyHomePage> {
  final League league;
  final Franchise franchise;
  final List<Franchise> franchises;
  final String cookieName;
  final String cookieValue;

  int _currentIndex = 0;
  List<Widget> _children = [];
  List<BottomNavigationBarItem> _items;

  MyHomePageState(this.league, this.franchise, this.franchises, this.cookieName, this.cookieValue);

  @override
  void initState() {
    super.initState();

    _children = [
      LiveScoringScreen(league, franchises),
      ChatScreen(cookieName, cookieValue, franchises, league),
//      TransactionsScreen(league, franchises),
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
//      BottomNavigationBarItem(
//        icon: Icon(Icons.format_list_numbered),
//        title: Text('Transactions'),
//      ),
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
      drawer: MflDrawer(franchise, league),
    );
  }
}