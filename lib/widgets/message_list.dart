import 'package:flutter/material.dart';
import 'package:mfl/widgets//message_list_item.dart';
import 'package:mfl/models/message.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  MessageList(this.messages);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          return MessageListItem(messages[index]);
        },
        itemCount: messages.length,
      ),
    );
  }
}