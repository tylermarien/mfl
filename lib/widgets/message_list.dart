import 'package:flutter/material.dart';
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messages[index].message,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                Divider(),
              ],
            );
          },
          itemCount: messages.length,
        )
    );
  }
}