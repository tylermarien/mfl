import 'package:xml/xml.dart' as xml;
import 'franchise.dart';
import 'match_up_franchise.dart';

class MatchUp {
  final MatchUpFranchise franchise1;
  final MatchUpFranchise franchise2;

  MatchUp(this.franchise1, this.franchise2);

  factory MatchUp.fromXml(List<Franchise> franchises, xml.XmlElement element) {
    final franchiseElements = element.findAllElements('franchise').toList();
    return MatchUp(
      MatchUpFranchise.fromXml(franchises, franchiseElements[0]),
      MatchUpFranchise.fromXml(franchises, franchiseElements[1]),
    );
  }
}