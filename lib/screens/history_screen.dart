import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class HistoryScreen extends StatelessWidget {
  final List<Transaction> transactions;
  const HistoryScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final t = transactions[index];
          return ListTile(
            title: Text(t.concept),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(t.date)),
            trailing: Text('\$${t.amount.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
