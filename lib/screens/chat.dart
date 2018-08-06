import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

final fetchDuration = Duration(seconds: 2);

class ChatScreen extends StatefulWidget {
  final String cookieName;
  final String cookieValue;

  ChatScreen({this.cookieName, this.cookieValue});

  @override
  State<StatefulWidget> createState() => ChatScreenState(cookieName: this.cookieName, cookieValue: this.cookieValue);
}

class ChatScreenState extends State<ChatScreen> {
  final String cookieName;
  final String cookieValue;

  TextEditingController controller = TextEditingController();
  List<Message> messages = List<Message>();

  ChatScreenState({this.cookieName, this.cookieValue});

  void handleMessageSubmitted(String message) {
      controller.text = '';
      sendMessage(cookieName, cookieValue, message).then((http.Response response) {
        loadMessages();
      });
  }

  void loadMessages() {
    fetchMessages().then((messages) {
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
//    Timer.periodic(fetchDuration, (Timer timer) {
//      loadMessages();
//    });
  }

  @override
  build(BuildContext context) {
    return Column(
      children: [
        MessageList(filteredMessages()),
        TextField(
          controller: controller,
          onSubmitted: handleMessageSubmitted,
        )
      ],
    );
  }
}

class MessageList extends StatelessWidget {
  final List<Message> messages;

  MessageList(this.messages);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(messages[index].message),
                Divider(),
              ],
            );
          },
          itemCount: messages.length,
        )
    );
  }
}

const host = 'www66.myfantasyleague.com';
const leagueId = '40298';

Future<List<Message>> fetchMessages() async {
  final url = Uri.https(host, '/fflnetdynamic2018/${leagueId}_chat.xml');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return xml.parse(utf8.decode(response.bodyBytes))
        .findAllElements('message')
        .map((message) => Message.fromXml(message))
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

class Message {
  Message(this.id, this.to, this.franchiseId, this.message, this.posted);

  final String id;
  final String to;
  final String franchiseId;
  final String message;
  final String posted;

  factory Message.fromXml(xml.XmlElement element) {
    return Message(
      element.getAttribute('id'),
      element.getAttribute('to'),
      element.getAttribute('franchise_id'),
      element.getAttribute('message'),
      element.getAttribute('posted'),
    );
  }
}