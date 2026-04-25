import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para validación de números
import 'package:intl/intl.dart';
import '../models/goal_model.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  List<Goal> goals = [];
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  void _addNewGoal(String title, double amount) {
    setState(() {
      goals.add(Goal(
          id: DateTime.now().toString(), title: title, targetAmount: amount));
    });
  }

  // NUEVA FUNCIÓN: Permite sumar un monto específico
  void _addCustomAmount(int index, double value) {
    setState(() {
      goals[index].currentSaved += value;
      if (goals[index].currentSaved < 0) goals[index].currentSaved = 0;
    });
  }

  void _deleteGoal(int index) {
    setState(() => goals.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Metas')),
      body: goals.isEmpty
          ? const Center(child: Text("Crea tu primera meta"))
          : ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(goal.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                            value: goal.percentage, color: Colors.greenAccent),
                        const SizedBox(height: 5),
                        Text(
                            "${currencyFormat.format(goal.currentSaved)} de ${currencyFormat.format(goal.targetAmount)}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // BOTÓN PARA AGREGAR DINERO PERSONALIZADO
                        IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => _showAddMoneyDialog(context, index),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteGoal(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGoalDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // DIÁLOGO PARA INGRESAR EL MONTO MANUALMENTE
  void _showAddMoneyDialog(BuildContext context, int index) {
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ahorrar en: ${goals[index].title}'),
        content: TextField(
          controller: amountCtrl,
          autofocus: true,
          decoration:
              const InputDecoration(hintText: "Monto a sumar (Ej: 15.50)"),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(amountCtrl.text);
              if (val != null) {
                _addCustomAmount(index, val);
                Navigator.pop(context);
              }
            },
            child: const Text('Sumar'),
          ),
        ],
      ),
    );
  }

  // DIÁLOGO PARA CREAR META (TAMBIÉN CON VALIDACIÓN)
  void _showCreateGoalDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: 'Monto Meta'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(amountCtrl.text);
              if (nameCtrl.text.isNotEmpty && val != null) {
                _addNewGoal(nameCtrl.text, val);
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}
