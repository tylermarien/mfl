import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/models/transaction.dart';

Future<List<Transaction>> fetchTransactions(List<Franchise> franchises, League league) async {
  final params = {
    'TYPE': 'transactions',
    'L': league.id,
  };
  final url = Uri.https(league.host, '/2018/export', params);

  final response = await http.get(url);
  final document = xml.parse(response.body);
  return document.findAllElements('transaction')
      .map((element) => Transaction.fromXml(franchises, element))
      .toList();
}