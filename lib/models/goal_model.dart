class Goal {
  final String id;
  final String title;
  final double targetAmount;
  double currentSaved;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentSaved = 0,
  });

  double get percentage => (currentSaved / targetAmount).clamp(0.0, 1.0);
}
