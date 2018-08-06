import 'package:xml/xml.dart' as xml;

class Franchise {
  final String id;
  final String name;
  final String owner;
  final String username;

  Franchise(this.id, this.name, this.owner, this.username);

  factory Franchise.fromXml(xml.XmlElement element) {
    return Franchise(
      element.getAttribute('id'),
      element.getAttribute('name'),
      element.getAttribute('owner_name'),
      element.getAttribute('username'),
    );
  }
}