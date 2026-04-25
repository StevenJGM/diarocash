import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double income;
  final double expenses;

  const BalanceCard({super.key, required this.income, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statColumn("Ingresos", income, Colors.green),
            _statColumn("Gastos", expenses, Colors.red),
            _statColumn("Neto", income - expenses, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, double value, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        Text('\$${value.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
