import 'package:flutter/material.dart';
import 'dart:async';

typedef LoginFunction = Future<String> Function(String username, String password);

class LoginScreen extends StatelessWidget {
  final LoginFunction login;

  LoginScreen({Key key, this.login}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(login: this.login),
    );
  }
}

class LoginForm extends StatefulWidget {
  final LoginFunction login;

  LoginForm({this.login});

  @override
  State<StatefulWidget> createState() => LoginFormState(login: this.login);
}

class LoginFormState extends State<LoginForm> {
  final LoginFunction login;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  LoginFormState({this.login});

  String username;
  String password;
  String error = '';

  void submit() async {
    _formKey.currentState.save();

    final response = await this.login(username, password);
    this.setState(() {
      error = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
        ),
        onSaved: (value) => username = value,
      ),
      TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        onSaved: (value) => password = value,
      ),
      Container(
        margin: EdgeInsets.only(top: 16.0),
        child: RaisedButton(
          child: Text('Log in', style: TextStyle(color: Colors.white)),
          color: Colors.green,
          onPressed: submit,
        ),
      ),
    ];

    if (error != '') {
      children.insert(0, Text(error));
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}