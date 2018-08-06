import 'package:flutter/material.dart';
import 'package:mfl/types/login_function.dart';
import 'package:mfl/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final LoginFunction login;

  LoginScreen({Key key, this.login}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(this.login),
    );
  }
}