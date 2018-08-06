import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mfl/screens/main.dart';
import 'package:mfl/widgets/login_form.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/api/login.dart';

class LoginScreen extends StatelessWidget {
  final League league;

  LoginScreen(this.league);

  Future<String> doLogin(BuildContext context, String username, String password) async {
    final LoginData data = await login(league, username, password);
    if (data.isSuccessful) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => MainScreen(username, league, data.cookieName, data.cookieValue),
      ), (route) => false);

      return '';
    } else {
      return data.error;
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
                child: LoginForm(doLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}