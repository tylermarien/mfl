import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:mfl/models/message.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/widgets/message_list.dart';
import 'package:mfl/widgets/message_bar.dart';

const host = 'www66.myfantasyleague.com';
const leagueId = '40298';

class ChatScreen extends StatefulWidget {
  final String cookieName;
  final String cookieValue;
  final List<Franchise> franchises;

  ChatScreen(this.cookieName, this.cookieValue, this.franchises);

  @override
  State<StatefulWidget> createState() => ChatScreenState(
    this.franchises,
    this.cookieName,
    this.cookieValue
  );
}

class ChatScreenState extends State<ChatScreen> {
  final List<Franchise> franchises;
  final String cookieName;
  final String cookieValue;

  Timer timer;

  TextEditingController controller = TextEditingController();
  List<Message> messages = List<Message>();

  ChatScreenState(this.franchises, this.cookieName, this.cookieValue);

  void handleSendMessage(String message) {
    sendMessage(cookieName, cookieValue, message)
        .then((http.Response response) {
          loadMessages();
        });
  }

  void loadMessages() {
    fetchMessages(franchises).then((messages) {
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

Future<List<Message>> fetchMessages(List<Franchise> franchises) async {
  final url = Uri.https(host, '/fflnetdynamic2018/${leagueId}_chat.xml');
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

Future<http.Response> sendMessage(String cookieName, String cookieValue, String message) async {
  final headers = {
    'Cookie': '$cookieName=$cookieValue',
  };
  final params = {
    'L': leagueId,
    'MESSAGE': message,
  };
  final url = Uri.https(host, '/2018/chat_save', params);
  return http.get(url, headers: headers);
}