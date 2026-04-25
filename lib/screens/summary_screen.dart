import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class SummaryScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const SummaryScreen({super.key, required this.transactions});

  // --- LÓGICA DE FILTRADO ---

  double _calculateTotal(List<Transaction> list) {
    double incomes =
        list.where((t) => t.isIncome).fold(0, (p, c) => p + c.amount);
    double expenses =
        list.where((t) => !t.isIncome).fold(0, (p, c) => p + c.amount);
    return incomes - expenses;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Filtrar transacciones de los últimos 7 días (Semanal)
    final weeklyTransactions = transactions.where((t) {
      final difference = now.difference(t.date).inDays;
      return difference <= 7;
    }).toList();

    // Filtrar transacciones del mes actual (Mensual)
    final monthlyTransactions = transactions.where((t) {
      return t.date.month == now.month && t.date.year == now.year;
    }).toList();

    final weeklyBalance = _calculateTotal(weeklyTransactions);
    final monthlyBalance = _calculateTotal(monthlyTransactions);

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen de Cuentas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.analytics_outlined,
                size: 80, color: Colors.greenAccent),
            const SizedBox(height: 30),

            // --- SECCIÓN SEMANAL ---
            _buildSummaryCard(
              title: "Balance Semanal",
              subtitle: "Últimos 7 días",
              amount: weeklyBalance,
              color: Colors.blueAccent,
              icon: Icons.calendar_view_week,
            ),

            const SizedBox(height: 20),

            // --- SECCIÓN MENSUAL ---
            _buildSummaryCard(
              title: "Balance Mensual",
              subtitle: DateFormat('MMMM yyyy', 'es').format(now).toUpperCase(),
              amount: monthlyBalance,
              color: Colors.greenAccent,
              icon: Icons.calendar_month,
            ),

            const SizedBox(height: 40),

            const Text(
              "Consejo: Mantén tus gastos impulsivos bajos para aumentar tu balance neto.",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 10),
              Text(
                "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: amount >= 0 ? Colors.white : Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
