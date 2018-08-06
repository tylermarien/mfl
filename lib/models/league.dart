import 'package:xml/xml.dart' as xml;

class League {
  final String id;
  final String name;
  final String host;
  final String homeUrl;

  League(this.id, this.name, this.host, this.homeUrl);

  factory League.fromXml(xml.XmlElement element) {
    final homeUrl = element.getAttribute('homeURL');
    return League(
      element.getAttribute('id'),
      element.getAttribute('name'),
      homeUrl.split('/')[2],
      homeUrl,
    );
  }
}