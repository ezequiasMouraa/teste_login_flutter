// widgets/transaction_list.dart
import 'package:flutter/material.dart';
import '../models/transaction.dart' as app;
import '../services/transaction_service.dart';

class TransactionList extends StatelessWidget {
  final String userId;

  TransactionList({required this.userId});

  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<app.MyTransaction>>(
      stream: _transactionService.getTransactions(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final transactions = snapshot.data!;
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              title: Text(transaction.description),
              subtitle: Text(transaction.date.toIso8601String()),
              trailing: Text(transaction.amount.toString()),
              onTap: () {
                // Navigate to transaction details page
              },
            );
          },
        );
      },
    );
  }
}
