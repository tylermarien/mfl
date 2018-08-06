import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:mfl/models/message.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/widgets/message_list.dart';
import 'package:mfl/widgets/message_bar.dart';

class ChatScreen extends StatefulWidget {
  final String cookieName;
  final String cookieValue;
  final League league;
  final List<Franchise> franchises;

  ChatScreen(this.cookieName, this.cookieValue, this.franchises, this.league);

  @override
  State<StatefulWidget> createState() => ChatScreenState(
    league,
    franchises,
    cookieName,
    cookieValue
  );
}

class ChatScreenState extends State<ChatScreen> {
  final League league;
  final List<Franchise> franchises;
  final String cookieName;
  final String cookieValue;

  Timer timer;

  TextEditingController controller = TextEditingController();
  List<Message> messages = List<Message>();

  ChatScreenState(this.league, this.franchises, this.cookieName, this.cookieValue);

  void handleSendMessage(String message) {
    sendMessage(league, cookieName, cookieValue, message)
        .then((http.Response response) {
          loadMessages();
        });
  }

  void loadMessages() {
    fetchMessages(league, franchises).then((messages) {
      this.setState(() {
        this.messages = messages;
      });
    });
  }

  List<Message> filteredMessages() {
    return messages.where((message) => message.to == null).toList();
  }

  @override
  void initState() {
    super.initState();

    loadMessages();
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      loadMessages();
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    timer.cancel();
  }

  @override
  build(BuildContext context) {
    return Column(
      children: [
        MessageList(filteredMessages()),
        MessageBar(handleSendMessage),
      ],
    );
  }
}

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

Future<http.Response> sendMessage(League league, String cookieName, String cookieValue, String message) async {
  final headers = {
    'Cookie': '$cookieName=$cookieValue',
  };
  final params = {
    'L': league.id,
    'MESSAGE': message,
  };
  final url = Uri.https(league.host, '/2018/chat_save', params);
  return http.get(url, headers: headers);
}