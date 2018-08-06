import 'package:xml/xml.dart' as xml;

class Franchise {
  final String id;
  final String name;

  Franchise(this.id, this.name);

  factory Franchise.fromXml(xml.XmlElement element) {
    return Franchise(
      element.getAttribute('id'),
      element.getAttribute('name'),
    );
  }
}