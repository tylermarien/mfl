import 'package:xml/xml.dart' as xml;
import 'franchise.dart';

class Message {
  Message(this.id, this.to, this.franchiseId, this.message, this.posted, this.franchise);

  final String id;
  final String to;
  final String franchiseId;
  final String message;
  final String posted;
  final Franchise franchise;

  factory Message.fromXml(List<Franchise> franchises, xml.XmlElement element) {
    final franchiseId = element.getAttribute('franchise_id');

    return Message(
      element.getAttribute('id'),
      element.getAttribute('to'),
      franchiseId,
      element.getAttribute('message'),
      element.getAttribute('posted'),
      franchises.firstWhere((franchise) => franchise.id == franchiseId),
    );
  }
}