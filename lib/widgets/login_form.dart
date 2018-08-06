import 'package:flutter/material.dart';
import 'package:mfl/types/login_function.dart';

class LoginForm extends StatefulWidget {
  final LoginFunction login;

  LoginForm(this.login);

  @override
  State<StatefulWidget> createState() => LoginFormState(this.login);
}

class LoginFormState extends State<LoginForm> {
  final LoginFunction login;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  LoginFormState(this.login);

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String username;
  String password;
  String error = '';

  void submit(BuildContext context) {
    _formKey.currentState.save();

    this.login(context, username, password)
      .then((response) {
        this.setState(() {
          error = response;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      TextFormField(
        controller: usernameController,
        decoration: InputDecoration(
          labelText: 'Username',
        ),
        onSaved: (value) => username = value,
      ),
      TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        onSaved: (value) => password = value,
      ),
      Container(
        margin: EdgeInsets.only(top: 16.0),
        child: RaisedButton(
          child: Text('Log in', style: TextStyle(color: Colors.white)),
          color: Colors.green,
          onPressed: () => submit(context),
        ),
      ),
    ];

    if (error != '') {
      children.insert(0, Text(error));
    }

    return Form(
      key: _formKey,
      child: ListView(
        children: children,
      ),
    );
  }
}