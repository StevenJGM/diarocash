import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/transaction_model.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/savings_screen.dart'; // <--- Nueva pantalla importada

void main() async {
  // 2. AGREGA ESTAS DOS LÍNEAS:
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null); // Inicializa el idioma español

  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery Cash',
      // Tema oscuro profesional
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.green),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  // 1. Indice de la pantalla actual
  int _index = 0;

  // 2. Fuente de datos compartida para las pantallas
  List<Transaction> transactions = [];

  // 3. Función para agregar transacciones desde la Home
  void _addTransaction(String c, double m, bool i) {
    setState(() {
      transactions.add(Transaction(
          id: DateTime.now().toString(),
          concept: c,
          amount: m,
          date: DateTime.now(),
          isIncome: i));
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4. Lista de pantallas (Ahora son 4)
    final List<Widget> screens = [
      HomeScreen(transactions: transactions, onAdd: _addTransaction),
      HistoryScreen(transactions: transactions),
      const SavingsScreen(), // <--- Agregada la pantalla de ahorros
      SummaryScreen(transactions: transactions),
    ];

    return Scaffold(
      // IndexedStack mantiene el estado de las pantallas al cambiar de pestaña
      body: IndexedStack(index: _index, children: screens),

      // 5. Barra de navegación actualizada
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'Historial'),
          NavigationDestination(
              icon: Icon(Icons.savings_outlined),
              selectedIcon: Icon(Icons.savings),
              label: 'Ahorro' // <--- Nuevo botón
              ),
          NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Resumen'),
        ],
      ),
    );
  }
}
