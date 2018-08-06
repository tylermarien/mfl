import 'package:flutter/material.dart';

class MessageBar extends StatefulWidget {
  final sendMessage;

  MessageBar(this.sendMessage);

  @override
  State<StatefulWidget> createState() => MessageBarState(this.sendMessage);
}

class MessageBarState extends State<MessageBar> {
  final TextEditingController controller = TextEditingController();
  final sendMessage;

  MessageBarState(this.sendMessage);

  void handleMessageSubmitted(String message) {
    sendMessage(controller.text);
    controller.text = '';
  }

  void handleSendPressed() {
    sendMessage(controller.text);
    controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  contentPadding: const EdgeInsets.all(12.0),
                ),
                controller: controller,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                onSubmitted: handleMessageSubmitted,
              )
          ),
          Padding (
            padding: const EdgeInsets.only(left: 8.0),
            child: RaisedButton(
              child: Text('Send', style: const TextStyle(color: Colors.white)),
              color: Colors.green,
              onPressed: handleSendPressed,
            ),
          ),
        ],
      ),
    );
  }
}