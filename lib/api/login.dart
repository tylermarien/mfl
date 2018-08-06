import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/models/league.dart';

const loginUrl = 'https://www66.myfantasyleague.com/2018/login';

class LoginData {
  final bool isSuccessful;
  final String cookieName;
  final String cookieValue;
  final String error;

  LoginData(this.isSuccessful, this.cookieName, this.cookieValue, this.error);
}

Future<LoginData> login(League league, String username, String password) async {
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

      return LoginData(true, cookieName, cookieValue, null);
    } else {
      return LoginData(false, null, null, error.first.text);
    }
  } else {
    return LoginData(false, null, null, 'Login unsuccessful');
  }
}