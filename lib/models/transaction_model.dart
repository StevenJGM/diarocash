class Transaction {
  final String id;
  final String concept;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.concept,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}
