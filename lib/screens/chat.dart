import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mfl/models/message.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/widgets/message_list.dart';
import 'package:mfl/widgets/message_bar.dart';
import 'package:mfl/api/messages.dart';

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
        .then((bool sent) {
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