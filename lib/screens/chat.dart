import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class ChatScreen extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Column(
      children: [
        MessageListBuilder(),
        TextField()
      ],
    );
  }
}

class MessageListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MessageList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
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

fetchMessages() async {
  final response = await http.get('http://www66.myfantasyleague.com/fflnetdynamic2018/40298_chat.xml?random=H71ns12');

  if (response.statusCode == 200) {
    return xml.parse(response.body)
        .findAllElements('message')
        .map((message) => Message.fromXml(message))
        .toList();
  } else {
    throw Exception('Failed to load messages');
  }
}

class Message {
  Message(this.id, this.franchiseId, this.message, this.posted);

  final id;
  final franchiseId;
  final message;
  final posted;

  factory Message.fromXml(xml.XmlElement element) {
    return Message(
      element.getAttribute('id'),
      element.getAttribute('franchise_id'),
      element.getAttribute('message'),
      element.getAttribute('posted'),
    );
  }
}