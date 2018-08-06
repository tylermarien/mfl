import 'package:xml/xml.dart' as xml;
import 'franchise.dart';

class MatchUpFranchise {
  final String id;
  final String name;
  final String score;

  MatchUpFranchise(this.id, this.name, this.score);

  factory MatchUpFranchise.fromXml(List<Franchise> franchises, xml.XmlElement element) {
    final id = element.getAttribute('id');
    final franchise = franchises.firstWhere((element) => element.id == id);
    return MatchUpFranchise(
      id,
      franchise.name,
      element.getAttribute('score'),
    );
  }
}