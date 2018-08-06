import 'package:xml/xml.dart' as xml;

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