import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/models/message.dart';

Future<List<Message>> fetchMessages(League league, List<Franchise> franchises) async {
  final url = Uri.https(league.host, '/fflnetdynamic2018/${league.id}_chat.xml');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return xml.parse(utf8.decode(response.bodyBytes))
        .findAllElements('message')
        .map((message) => Message.fromXml(franchises, message))
        .toList();
  } else {
    throw Exception('Failed to load messages');
  }
}

Future<bool> sendMessage(League league, String cookieName, String cookieValue, String message) async {
  final headers = {
    'Cookie': '$cookieName=$cookieValue',
  };
  final params = {
    'L': league.id,
    'MESSAGE': message,
  };
  final url = Uri.https(league.host, '/2018/chat_save', params);
  await http.get(url, headers: headers);

  return true;
}