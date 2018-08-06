import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/screens/main.dart';
import 'package:mfl/widgets/login_form.dart';
import 'package:mfl/models/league.dart';

const loginUrl = 'https://www66.myfantasyleague.com/2018/login';

class LoginScreen extends StatelessWidget {
  final League league;

  LoginScreen(this.league);

  Future<String> login(BuildContext context, String username, String password) async {
    final body = {
      'LEAGUE_ID': league.id,
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
        final cookieName = status.first.attributes.first.name.toString();
        final cookieValue = status.first.attributes.first.value;

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => MainScreen(league, cookieName, cookieValue),
        ), (route) => false);

        return '';
      } else {
        return error.first.text;
      }
    } else {
      return 'Login unsuccessful';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                league.name,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Expanded(
                child: LoginForm(login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}