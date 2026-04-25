import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../widgets/balance_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String, double, bool) onAdd;

  const HomeScreen(
      {super.key, required this.transactions, required this.onAdd});

  // --- 1. Lógica para agrupar por fecha ---
  Map<String, List<Transaction>> _groupTransactions(List<Transaction> list) {
    Map<String, List<Transaction>> grouped = {};
    final sortedList = list.toList()..sort((a, b) => b.date.compareTo(a.date));

    for (var t in sortedList) {
      String dateKey = DateFormat('yyyy-MM-dd').format(t.date);
      if (grouped[dateKey] == null) grouped[dateKey] = [];
      grouped[dateKey]!.add(t);
    }
    return grouped;
  }

  String _getFriendlyDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return "HOY";
    if (checkDate == yesterday) return "AYER";
    return DateFormat('EEEE, d MMMM', 'es').format(date).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final double income =
        transactions.where((t) => t.isIncome).fold(0, (p, c) => p + c.amount);
    final double expenses =
        transactions.where((t) => !t.isIncome).fold(0, (p, c) => p + c.amount);

    final groupedData = _groupTransactions(transactions);
    final dateKeys = groupedData.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Caja Diaria')),
      body: Column(
        children: [
          BalanceCard(income: income, expenses: expenses),
          const Divider(),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text("No hay movimientos registrados"))
                : ListView.builder(
                    itemCount: dateKeys.length,
                    itemBuilder: (context, index) {
                      String dateKey = dateKeys[index];
                      List<Transaction> dayTransactions = groupedData[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              _getFriendlyDate(DateTime.parse(dateKey)),
                              style: TextStyle(
                                  color: Colors.greenAccent[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // ✅ SE ELIMINÓ EL .toList() AL FINAL DEL MAP
                          ...dayTransactions.map((t) => ListTile(
                                leading: Icon(
                                    t.isIncome
                                        ? Icons.add_circle
                                        : Icons.remove_circle,
                                    color:
                                        t.isIncome ? Colors.green : Colors.red),
                                title: Text(t.concept),
                                subtitle:
                                    Text(DateFormat('hh:mm a').format(t.date)),
                                trailing: Text(
                                  '\$${t.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: t.isIncome
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    final concCtrl = TextEditingController();
    final montCtrl = TextEditingController();
    bool isIncome = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Nuevo Movimiento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: concCtrl,
                decoration: const InputDecoration(labelText: 'Concepto'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: montCtrl,
                decoration: const InputDecoration(
                    labelText: 'Monto', prefixText: '\$ '),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                ],
              ),
              SwitchListTile(
                title: Text(isIncome ? "Ganancia" : "Gasto"),
                value: isIncome,
                onChanged: (v) => setModalState(() => isIncome = v),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final String concepto = concCtrl.text.trim();
                final double? monto = double.tryParse(montCtrl.text);

                if (concepto.isNotEmpty && monto != null && monto > 0) {
                  onAdd(concepto, monto, isIncome);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ingresa concepto y monto válido')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
