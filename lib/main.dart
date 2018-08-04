import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'MyFantasyLeague',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Chat'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final title;

  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: [
            getMessagesList(),
            TextField()
          ],
        )
    );
  }
}

getMessagesList() {
  return FutureBuilder(
      future: fetchMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data[index].message),
                      Divider(),
                    ],
                  );
                },
                itemCount: snapshot.data.length,
              )
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Expanded(child: Center(child: CircularProgressIndicator()));
      }
  );
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
