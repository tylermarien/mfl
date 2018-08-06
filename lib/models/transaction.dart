import 'package:xml/xml.dart' as xml;
import 'franchise.dart';

class Transaction {
  final String type;
  final Franchise franchise;
  final Franchise franchise2;

  Transaction(this.type, this.franchise, this.franchise2);

  factory Transaction.fromXml(List<Franchise> franchises, xml.XmlElement element) {
    final franchise = franchises.firstWhere((franchise) {
      return franchise.id == element.getAttribute('franchise');
    });

    final franchise2 = franchises.firstWhere((franchise) {
      return franchise.id == element.getAttribute('franchise2');
    });

    return Transaction(
      element.getAttribute('type'),
      franchise,
      franchise2,
    );
  }
}