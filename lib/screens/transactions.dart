import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:async';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/models/transaction.dart';

class TransactionsScreen extends StatelessWidget {
  final League league;
  final List<Franchise> franchises;

  TransactionsScreen(this.league, this.franchises);

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

  @override
  build(BuildContext context) {
    return FutureBuilder(
      future: fetchTransactions(franchises, league),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Text(snapshot.data[index].type);
            },
            itemCount: snapshot.data.length,
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}