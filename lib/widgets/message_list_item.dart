import 'package:flutter/material.dart';
import 'package:mfl/models/message.dart';


class MessageListItem extends StatelessWidget {
  final Message message;

  MessageListItem(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(message.franchise.name),
        ),
        Text(
          message.message,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        Divider(),
      ],
    );
  }
}