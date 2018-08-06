import 'package:flutter/material.dart';
import 'package:mfl/models/franchise.dart';
import 'package:mfl/models/league.dart';
import 'package:mfl/api/transactions.dart';

class TransactionsScreen extends StatelessWidget {
  final League league;
  final List<Franchise> franchises;

  TransactionsScreen(this.league, this.franchises);

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